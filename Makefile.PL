use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lingua::MPoem',
    AUTHOR              => q{JJoao <jj@di.uminho.pt>},
    VERSION_FROM        => 'lib/Lingua/MPoem.pm',
    ABSTRACT_FROM       => 'lib/Lingua/MPoem.pm',
    ($ExtUtils::MakeMaker::VERSION ## >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    EXE_FILES    => ['bin/poeta'],
    PREREQ_PM => {
        'Test::More' => 0,
	    'Test::Output' => 0,
        'Encode::Guess' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-MPoem-*' },
);
