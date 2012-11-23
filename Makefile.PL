use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'DBIx::ORMapper::Migration',
   VERSION_FROM => 'lib/DBIx/ORMapper/Migration.pm',
   PREREQ_PM => {'DBIx::ORMapper' => 0},
   LICENSE => 'perl',
   EXE_FILES => ['bin/dbix-ormapper-migrate'],
);

