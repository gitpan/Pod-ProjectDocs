use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Pod::ProjectDocs',
    VERSION_FROM      => 'lib/Pod/ProjectDocs.pm', # finds $VERSION
	EXE_FILES         => ['bin/pod2projdocs'],
    PREREQ_PM         => {
		Pod::Parser => 1.32,
		Pod::ParseUtils => 0,
		Class::Accessor::Fast => 0,
		Class::Data::Inheritable => 0,
		File::Spec => 0,
		File::Basename => 0,
		File::Find => 0,
        File::Copy => 0,
		MIME::Base64 => 0,
		Template => 0,
		Readonly => 0,
        URI::Escape => 0,
		JSON => 0.991,
    Syntax::Highlight::Universal => 0,
	}, # e.g., Module::Name => 1.1
);
