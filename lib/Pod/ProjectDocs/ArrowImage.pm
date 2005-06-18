package Pod::ProjectDocs::ArrowImage;
use strict;
use base qw/Pod::ProjectDocs::File/;
use MIME::Base64;
use File::Basename;
use File::Spec::Functions qw/abs2rel/;

__PACKAGE__->default_name('up.gif');
__PACKAGE__->data( do{ local $/; <DATA> } );
__PACKAGE__->is_bin(1);

sub tag {
	my $self = shift;
	my $file = shift;
	my($name, $path) = fileparse $file->path, qw/\.html/;
	my $rel_path = abs2rel $self->path, $path;
	return sprintf qq|<a href="#TOP" class="toplink"><img alt="^" src="%s"></a>|, $rel_path;
}

sub _save_data {
	my $self = shift;
	return decode_base64($self->data);
}

1;
__DATA__
R0lGODlhDwAPAIAAAABmmf///yH5BAEAAAEALAAAAAAPAA8AAAIjhI8Jwe1tXlgvulMpS1crT33W
uGBkpm3pZEEr1qGZHEuSKBYAOw==
