#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Lingua::MPoem' ) || print "Bail out!
";
}

diag( "Testing Lingua::MPoem $Lingua::MPoem::VERSION, Perl $], $^X" );
