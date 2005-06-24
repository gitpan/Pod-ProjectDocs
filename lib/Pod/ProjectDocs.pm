package Pod::ProjectDocs;
use strict;
use base qw/Class::Accessor/;

use vars qw/$VERSION/;
$VERSION = "0.05";

use Pod::ProjectDocs::IndexPage;
use Pod::ProjectDocs::Doc;
use Pod::ProjectDocs::CSS;
use Pod::ProjectDocs::ArrowImage;
use File::Find ();
use File::Spec;

use constant DEFAULT_TITLE   => "MyProject's Perl Modules";
use constant DEFAULT_DESC	 => "manuals and modules";
use constant DEFAULT_CHARSET => 'UTF-8';

__PACKAGE__->mk_accessors(qw/
	title desc outroot libroot css charset arrow index verbose
/);

sub new {
	my $class = shift;
	my $self = bless {}, $class;
	$self->_init(@_);
	return $self;
}

sub _init {
	my($self, %args) = @_;
	$self->title($args{title} || DEFAULT_TITLE );
	$self->desc($args{desc} || DEFAULT_DESC);

	$args{outroot} ||= File::Spec->curdir;
	$args{outroot} = File::Spec->rel2abs($args{outroot}, File::Spec->curdir)
		unless File::Spec->file_name_is_absolute($args{outroot});	
	$self->outroot($args{outroot});

	$args{libroot} ||= File::Spec->curdir;
	$args{libroot} = File::Spec->rel2abs($args{libroot}, File::Spec->curdir)
		unless File::Spec->file_name_is_absolute($args{outroot});
	$self->libroot($args{libroot});

	$self->charset($args{charset} || DEFAULT_CHARSET);
	$self->verbose($args{verbose});
	$self->index($args{index});
	$self->css( Pod::ProjectDocs::CSS->new(outroot => $self->outroot) );
	$self->arrow( Pod::ProjectDocs::ArrowImage->new(outroot => $self->outroot) );

	$self->_message("...");
	$self->_message("...");
	$self->_message("output root:  [".$self->outroot."]");
	$self->_message("library root: [".$self->libroot."]");
	$self->_message("...");
}

sub _message {
	my $self = shift;
	my $msg  = shift;
	print STDERR $msg."\n" if $self->verbose;
}

sub _croak {
	my($self, $msg) = @_;
	require Carp;
	Carp::croak($msg);
}

sub gen {
	my $self = shift;

	$self->_message("...");
	$self->_message("...");
	$self->_message("checking output directory...");

	$self->_message("...");
	$self->_croak("[".$self->outroot."] doesn't exist or It's not a directory.")

		unless(-e $self->outroot && -d $self->outroot);

	$self->_message("output directory [".$self->outroot."] is ok.");

	$self->_message("...");
	$self->_message("...");
	$self->_message("searching your perl-modules in your library directory [".$self->libroot."]...");
	$self->_message("...");

	my @modules = ();
	foreach my $file ( sort $self->_find_packages('pm') ) {

		$self->_message("found $file.");

		my $doc = Pod::ProjectDocs::Doc->new(
			origin 	=> $file,
			outroot	=> $self->outroot,
			libroot => $self->libroot,
		);
		push(@modules, $doc);
	}

	$self->_message("...");
	$self->_message("...");
	$self->_message("searching your pod-manuals in your library directory [".$self->libroot."]...");
	$self->_message("...");

	my @mans = ();
	foreach my $file ( sort $self->_find_packages('pod') ){

		$self->_message("found $file.");

		my $doc = Pod::ProjectDocs::Doc->new(
			origin	=> $file,
			outroot => $self->outroot,
			libroot => $self->libroot,
		);
		push(@mans, $doc);
	}
		
	$self->_message("...");
	$self->_message("...");
	$self->_message("publishing css file [".$self->css->path."]...");
	$self->_message("...");
	$self->css->publish;
	$self->_message("finished.");

	$self->_message("...");
	$self->_message("...");
	$self->_message("publishing image file [".$self->arrow->path."]...");
	$self->_message("...");
	$self->arrow->publish;
	$self->_message("finished.");

	foreach my $doc ( @modules, @mans ){

		$self->_message("...");
		$self->_message("...");
		$self->_message("publishing  [".$doc->path."]...");
		$self->_message("...");

		eval{

		$doc->publish(
			css     => $self->css,
			arrow	=> $self->arrow,
			index	=> $self->index,
			title   => $self->title,
			desc	=> $self->desc,
			charset => $self->charset,
		);

		};
		if($@){

			$self->_message("failed.");
			$self->_message("ERROR:[".$@."]");
			next;
		}

		if($doc->has_document){

			$self->_message("finished.");

		}else{

			$self->_message($doc->name." doesn't have document.");

		}

	}

	my $index = Pod::ProjectDocs::IndexPage->new(
		outroot => $self->outroot,
	);

	$self->_message("...");
	$self->_message("...");
	$self->_message("publishing index-page [".$index->path."]...");
	$self->_message("...");

	$index->publish(
		title	=> $self->title,
		desc	=> $self->desc,
		css   	=> $self->css,
		docs  	=> \@modules,
		mans	=> \@mans,
		charset	=> $self->charset,
	);

	$self->_message("finished.");
	$self->_message("...");

	$self->_message("completed!");
	$self->_message("...");
	$self->_message("See [".$index->path."] via HTTP with your browser.");
}

sub _find_packages {
	my $self = shift;
	my $suffix = shift;
	my $search = $self->libroot;
	$self->_croak("$search isn't detected or it's not a directory.")
		unless( -e $search && -d $search );
	my @files  = ();
	my $wanted = sub {
		return unless $File::Find::name =~ /\.$suffix$/;
		(my $path = $File::Find::name ) =~ s#^\\.##;
		push @files, $path;
	};
	File::Find::find( { no_chdir => 1, wanted => $wanted }, $search );
	return @files;
}

1;

=head1 NAME

Pod::ProjectDocs - generates CPAN like pod pages

=head1 SYNOPSIS

	#!/usr/bin/perl -w
	use strict;
	use Pod::ProjectDocs;
	my $pd = Pod::ProjectDocs->new(
		outroot	=> '/output/directory',
		libroot => '/your/project/lib/root',
		title	=> 'ProjectName',
	);
	$pd->gen();

	#or use pod2projdocs on your shell
	pod2projdocs -out /output/directory -lib /your/project/lib/root

=head1 DESCRIPTION

This module allows you to generates CPAN like pod pages from your modules
for your projects. Set your library modules' root directory with libroot option.
And you have to set output directory's path with outroot option.
And this module searches your pm and pod files from your libroot, and generates
html files, and an index page lists up all your modules there.

See the generated pages via HTTP with your browser.
Your documents of your modules are displayed like CPAN website.

=head1 OPTIONS

=over 4

=item outroot

directory where you want to put the generated docs into.

=item libroot

your library's root directory

=item title

your project's name.

=item desc

description for your project.

=item charset

This is used in meta tag. default 'UTF-8'

=item index

whether you want to create index on each pod pages or not.
set 1 or 0.

=item verbose

whether you want to show messages on your shell or not.
set 1 or 0.

=back

=head1 pod2projdocs

You need not to write script with this module,
I put the script named 'pod2projdocs' in this package.
At first, please execute follows.

	pod2projdocs -help

or

	pod2projdocs -?

=head1 SEE ALSO

L<Pod::Xhtml>

=head1 AUTHOR

Lyo Kato E<lt>kato@lost-season.jpE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright(C) 2005 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.

=cut

