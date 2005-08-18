package Pod::ProjectDocs::Parser::PerlPod;
use strict;
use warnings;
use base qw/Pod::ProjectDocs::Parser/;
use Pod::Xhtml;
use Pod::ProjectDocs::Template;

sub create_html {
	my($self, $doc, $components) = @_;
	my $parser = $self->_prepare($doc, $components);
	local $SIG{__WARN__} = sub { };
	$parser->parse_from_file($doc->origin);
	my $title = $self->_get_title($parser);
	$doc->title($title);
	return $parser->asString;
}

sub _prepare {
	my($self, $doc, $components) = @_;
	my $charset = $doc->config->charset || 'UTF-8';
	my $parser = Pod::Xhtml->new(
		StringMode => 1,
		MakeMeta   => 0,
		TopLinks   => $components->{arrow}->tag($doc),
		MakeIndex  => $doc->config->index,
	);
	$parser->addHeadText($components->{css}->tag($doc));
	$parser->addHeadText(qq|<meta http-equiv="Content-Type" content="text/html; charset=$charset" />\n|);
	$parser->addBodyOpenText($self->_get_data($doc));
	return $parser;
}

sub _get_title {
	my($self, $parser) = @_;
	my $name_node = 0;
	my $title = '';
	foreach my $node ( @{ $parser->parse_tree } ) {
		if ($node->{'-ptree'}[0] && $node->{'-ptree'}[0] eq 'NAME') {
			$name_node = 1; next;
		}
		if($name_node == 1){
			$title = join "", @{ $node->{'-ptree'} };
			last;
		}
	}
	$title =~ s/^\s*\S*\s*-\s(.*)$/$1/;
	return $title;
}

sub _get_data {
	my($self, $doc) = @_;
	my $tt = Pod::ProjectDocs::Template->new;
	my $text = $tt->process($doc, $doc->data, {
		title   => $doc->config->title,
		desc    => $doc->config->desc,
		name    => $doc->name,
		outroot => $doc->config->outroot,
		src     => $doc->_get_output_src_path,
	});
	return $text;
}

1;
__END__

