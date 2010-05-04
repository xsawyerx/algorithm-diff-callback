#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Algorithm::Diff::Callback' ) || print "Bail out!
";
}

diag( "Testing Algorithm::Diff::Callback $Algorithm::Diff::Callback::VERSION, Perl $], $^X" );
