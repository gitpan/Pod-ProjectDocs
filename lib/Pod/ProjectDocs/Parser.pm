package Pod::ProjectDocs::Parser;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;

__PACKAGE__->mk_accessors(qw/components/);

sub new {
	my $class = shift;
	my $self  = bless { }, $class;
	$self->_init(@_);
	return $self;
}

sub _init {
	my($self, %args) = @_;
	$self->components( $args{components} );
}

sub create_html {
	my($self, $doc) = @_;
}

1;
__END__

