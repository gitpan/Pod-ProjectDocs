use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Pod::ProjectDocs',
    VERSION_FROM      => 'lib/Pod/ProjectDocs.pm', # finds $VERSION
	EXE_FILES         => ['bin/pod2projdocs'],
    PREREQ_PM         => {
		Pod::Xhtml => 0,
		Pod::Usage => 0,
		File::Spec => 0,
		File::Basename => 0,
		File::Find => 0,
		MIME::Base64 => 0,
		Template => 0,
		Readonly => 0,
	}, # e.g., Module::Name => 1.1
);
