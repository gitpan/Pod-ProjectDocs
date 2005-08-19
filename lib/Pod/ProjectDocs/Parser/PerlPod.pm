package Pod::ProjectDocs::Parser::PerlPod;
use strict;
use warnings;
use base qw/Pod::ProjectDocs::Parser/;
use Pod::ProjectDocs::Template;

sub create_html {
	my($self, $doc, $components, $mgr_desc) = @_;
	$self->_prepare($doc, $components, $mgr_desc);
	local $SIG{__WARN__} = sub { };
	$self->parse_from_file($doc->origin);
	my $title = $self->_get_title;
	$doc->title($title);
	return $self->asString;
}

sub _prepare {
	my($self, $doc, $components, $mgr_desc) = @_;
	my $charset = $doc->config->charset || 'UTF-8';
	$self->{StringMode} = 1;
	$self->{MakeMeta}   = 0;
	$self->{TopLinks}   = $components->{arrow}->tag($doc);
	$self->{MakeIndex}  = $doc->config->index;
	$self->initialize();
	$self->addHeadText($components->{css}->tag($doc));
	$self->addHeadText(qq|<meta http-equiv="Content-Type" content="text/html; charset=$charset" />\n|);
	$self->addBodyOpenText($self->_get_data($doc, $mgr_desc));
}

sub _get_title {
	my $self = shift;
	my $name_node = 0;
	my $title = '';
	foreach my $node ( @{ $self->parse_tree } ) {
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
	my($self, $doc, $mgr_desc) = @_;
	my $tt = Pod::ProjectDocs::Template->new;
	my $text = $tt->process($doc, $doc->data, {
		title    => $doc->config->title,
		desc     => $doc->config->desc,
		name     => $doc->name,
		outroot  => $doc->config->outroot,
		src      => $doc->_get_output_src_path,
		mgr_desc => $mgr_desc,
	});
	return $text;
}

1;
__END__

