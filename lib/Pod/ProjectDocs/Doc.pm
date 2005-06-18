package Pod::ProjectDocs::Doc;
use strict;
use base qw/Pod::ProjectDocs::File/;
use Pod::Xhtml;
use File::Basename;
use File::Spec::Functions qw/abs2rel curdir catfile catdir splitdir/;

__PACKAGE__->mk_accessors(qw/
	rel_path libroot origin name title author has_document
/);

__PACKAGE__->data( do{ local $/; <DATA> } );

sub _init {
	my $self = shift;
	my %args = @_;

	if(exists $args{origin} && $args{origin}){
		$self->origin($args{origin});
	}else{
		$self->_croak("Set args [origin libroot outroot].");
	}
	if(exists $args{libroot} && $args{libroot}){
		$self->libroot($args{libroot});
	}else{
		$self->_croak("Set args [origin libroot outroot].");
	}
	if(exists $args{outroot} && $args{outroot}){
		$self->outroot($args{outroot});
	}else{
		$self->_croak("Set args [origin libroot outroot].");
	}
	my($name, $directory) = fileparse $self->origin, qr/\.(?:pm|pod)/;
	$directory = abs2rel $directory, $self->libroot;
	$directory ||= curdir;
	$self->_check_dir($directory);
	my $rel_path = catdir $directory, $name;
	$self->name( join "-", splitdir $rel_path );
	$self->rel_path($rel_path.".html");
	$self->SUPER::_init(
		outroot => $self->outroot,
		file	=> $name.".html",
		dir		=> $directory,
	);
}

sub _check_dir {
	my $self = shift;
	my $dir  = shift;
	my @dirs = splitdir $dir;
	my $path = $self->outroot;
	foreach(@dirs){
		$path = catdir $path, $_;
		unless(-e $path && -d $path){
			mkdir($path, 0755)
				or $self->_croak("Can't make directory [$path].");
		}
	}
}

sub publish {
	my $self = shift;
	my %args = @_;
	my $charset = $args{charset} || 'UTF-8';
	my $parser= Pod::Xhtml->new(
		StringMode	=> 1,
		MakeMeta	=> 0,
		TopLinks	=> $args{arrow}->tag($self),
		MakeIndex	=> $args{index},
	);
	$parser->addHeadText($args{css}->tag($self)."\n");
	$parser->addHeadText(qq|<meta http-equiv="Content-Type" content="text/html; charset=$charset" />\n|);
	$parser->addBodyOpenText($self->_save_data(
		title => $args{title},
		name  => $self->name,
		mans  => $args{mans},
		desc  => $args{desc},
	));
	local $SIG{__WARN__} = sub { };
	$parser->addBodyOpenText(qq|\n<!-- DOCUMENT START -->\n|);
	$parser->addBodyCloseText(qq|\n<!-- DOCUMENT END -->\n|);
	$parser->parse_from_file($self->origin);
	if( $self->_document_is_empty($parser->asStringRef) ){
		$self->has_document(0);
		return;
	}
	$self->has_document(1);
	my $title  = $self->_get_title($parser);
	my $author = $self->_get_author($parser);
	$self->title($title);
	$self->author($author);
	my $fh = IO::File->new($self->path, "a")
		or $self->_croak("Can't open ".$self->path.".");
	$fh->seek(0, 0);
	$fh->truncate(0);
	$fh->print($parser->asString);
	$fh->close;
}

sub _document_is_empty {
	my $self	= shift;
	my $docref	= shift;
	(my $doc = $$docref) =~ s/(\r\n|\n)//g;
	$doc =~ /<!-- DOCUMENT START -->(.*)<!-- DOCUMENT END -->/;
	my $content = $1;
	$content =~ s/<!-- INDEX START -->(.*)<!-- INDEX END -->//;
	return $content =~ m!<div class="pod">(.+)</div>! ? 0 : 1;
}

sub _get_rel_path {
	my $self = shift;
	my $path = shift;
	my($name, $directory) = fileparse $self->path, qr/\.html/;
	return abs2rel $path, $directory;
}

sub _save_data {
	my $self = shift;
	my %args = @_;
	my $text = '';

	my $tt = Template->new({
		FILTERS => {
			relpath => sub {
				my $path = shift;
				return $self->_get_rel_path($path);
			},
			return2br => sub {
				my $text = shift;
				$text =~ s!\r\n!<br />!g;
				$text =~ s!\n!<br />!g;
				return $text;
			},
		},
	});
	my $html = $self->data;
	$tt->process(\$html, {
		title	=> $args{title},
		desc	=> $args{desc},
		name	=> $args{name},
		outroot => catfile($self->outroot,'index.html'),
	}, \$text)
		or $self->_croak($tt->error);
	return $text;
}

sub _get_author {
	my $self = shift;
	my $parser = shift;
	my $author_node = 0;
	my $author = '';
	foreach my $node ( @{ $parser->parse_tree } ) {
		if($node->{'-ptree'}[0] && $node->{'-ptree'}[0] eq 'AUTHOR'){
			$author_node = 1; next;
		}
		if($author_node == 1){
			$author = join "", @{ $node->{'-ptree'} }; last;
		}
	}
	return $author;
}

sub _get_title {
	my $self = shift;
	my $parser = shift;
	my $name_node = 0;
	my $title = '';
	foreach my $node ( @{ $parser->parse_tree } ){
		if($node->{'-ptree'}[0] && $node->{'-ptree'}[0] eq 'NAME'){
			$name_node = 1; next;
		}
		if($name_node == 1){
			$title = join "", @{ $node->{'-ptree'} }; last;
		}
	}
	$title =~ s/^\s*\S*\s*-\s(.*)$/$1/;
	return $title;
}

1;
__DATA__
<div class="box">
  <form name="form1">
  <h1 class="t1">[% title | html %]</h1>
  <table>
    <tr>
      <td class="label">Description</td>
      <td class="cell">[% desc | html | return2br %]</td>
    </tr>
  </table>
  </form>
</div>
<div class="path">
  <a href="[% outroot | relpath %]">[% title | html %]</a> >
  [% name | html %]
</div>

