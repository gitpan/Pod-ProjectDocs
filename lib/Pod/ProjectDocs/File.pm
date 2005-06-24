package Pod::ProjectDocs::File;
use strict;
use base qw/Class::Accessor Class::Data::Inheritable/;
use IO::File;
use File::Basename;
use File::Spec;

__PACKAGE__->mk_classdata($_) for qw/default_name data is_bin/;
__PACKAGE__->mk_accessors(qw/dir file path outroot/);
__PACKAGE__->is_bin(0);

sub new {
	my $class = shift;
	my $self = bless { }, $class;
	$self->_init(@_);
	return $self;
}

sub _init {

	my $self = shift;
	my %args = @_;

	my $out  = $args{outroot} || File::Spec->curdir;
	my $file = $args{file}    || $self->default_name;

	$self->outroot($out);
	$self->file($file);
	$self->dir( (exists $args{dir} && $args{dir})
		? File::Spec->catdir($out, $args{dir}) : $out);
	$self->_set_path;
}

sub _set_path {
	my $self = shift;
	my $path = File::Spec->catfile($self->dir, $self->file);
	unless(File::Spec->file_name_is_absolute($path)){
		$path = File::Spec->rel2abs($path, File::Spec->curdir);
	}
	$self->path($path);
}

sub _croak {
	my $self = shift;
	my $msg  = shift;
	require Carp; Carp::croak($msg);
}

sub publish {
	my $self = shift;
	my $fh = IO::File->new($self->path, "a")
		or $self->_croak("Can't open ".$self->path.".");
	$fh->seek(0,0);
	$fh->truncate(0);
	$fh->print($self->_save_data(@_));
	$fh->close;
}

sub _save_data {
	my $self = shift;
	return $self->data;
}

1;
__END__

