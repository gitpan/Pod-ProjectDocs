package Pod::ProjectDocs::Config;
use strict;
use warnings;

use base qw/Class::Accessor::Fast/;

use Readonly;

__PACKAGE__->mk_accessors(qw/
    title
    desc
    charset
    verbose
    index
    outroot
    libroot
/);

Readonly my $DEFAULT_TITLE   => qq/MyProject's Libraries/;
Readonly my $DEFAULT_DESC    => qq/manuals and libraries/;
Readonly my $DEFAULT_CHARSET => qq/UTF-8/;

sub new {
    my $class = shift;
    my $self  = bless { }, $class;
    $self->_init(@_);
    return $self;
}

sub _init {
    my($self, %args) = @_;
    $self->title(   $args{title}   || $DEFAULT_TITLE   );
    $self->desc(    $args{desc}    || $DEFAULT_DESC    );
    $self->charset( $args{charset} || $DEFAULT_CHARSET );
    $self->verbose( $args{verbose}                     );
    $self->index(   $args{index}                       );
    $self->outroot( $args{outroot}                     );
    $self->libroot( $args{libroot}                     );
}

1;
__END__
