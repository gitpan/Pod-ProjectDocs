use strict;
use FindBin;
use Test::More 'no_plan';
use Pod::ProjectDocs;

Pod::ProjectDocs->new(
    outroot => "$FindBin::Bin/output",
    libroot => "$FindBin::Bin/sample/lib",
    forcegen => 1,
)->gen;

# using XML::XPath might be better
open my $fh, "$FindBin::Bin/output/Sample/Project.pm.html";
my $html = join '', <$fh>;

like $html, qr!See <a href="#SYNOPSIS">SYNOPSIS</a> for its usage!;
like $html, qr!<a href="http://www.perl.org/">http://www.perl.org/</a>!;
like $html, qr!<a href="http://search.cpan.org/perldoc\?perlpod">Perl POD Syntax</a>!;


