package Pod::ProjectDocs::DocManager;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;

use File::Find;
use Pod::ProjectDocs::Doc;

__PACKAGE__->mk_accessors(qw/
	config
	desc
	suffix
	parser
	docs
	components
/);

sub new {
	my $class = shift;
	my $self  = bless { }, $class;
	$self->_init(@_);
	return $self;
}

sub _init {
	my($self, %args) = @_;
	$self->config(     $args{config}     );
	$self->desc(       $args{desc}       );
	$self->suffix(     $args{suffix}     );
	$self->parser(     $args{parser}     );
	$self->components( $args{components} );
	$self->docs( [] );
}

sub publish {
	my $self = shift;
	$self->_find_files;
	foreach my $doc ( @{ $self->docs } ) {
		if ( $doc->is_modified ) {
			$doc->copy_src;
			my $data = $self->parser->create_html($doc, $self->components);
			$doc->publish($data);
		}
	}
}

sub _find_files {
	my $self = shift;
	foreach my $dir ( @{ $self->config->libroot } ) {
		unless ( -e $dir && -d _ ){
		$self->_craok(qq/$dir isn't detected or it's not a directory./);
		}
	}
	my $suffix = $self->suffix;
	foreach my $dir ( @{ $self->config->libroot } ) {
		my $wanted = sub {
			return unless $File::Find::name =~ /\.$suffix$/;
			(my $path = $File::Find::name) =~ s#^\\.##;
			push @{ $self->docs },
				Pod::ProjectDocs::Doc->new(
					config      => $self->config,
					origin      => $path,
					origin_root => $dir,
					suffix      => $suffix,
				);
		};
		File::Find::find( { no_chdir => 1, wanted => $wanted }, $dir );
	}
}

sub _croak {
	my($self, $msg) = @_;
	require Carp;
	Carp::croak($msg);
}

1;
__END__

