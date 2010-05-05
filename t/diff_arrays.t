#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Algorithm::Diff::Callback 'diff_arrays';

my @old = qw( john jim james jackie jarule );
my @new = qw( john jim james jojo   jackie );

diff_arrays(
    \@old, \@new,
    sub {
        my $val = shift;
        is( $val, 'jarule', 'Goodbye jarule!' );
    },
    sub {
        my $val = shift;
        is( $val, 'jojo', 'Hello jojo!');
    },
);

my $empty_list = 0;
diff_arrays( [], [], sub { $empty_list++ }, sub { $empty_list++ } );
cmp_ok( $empty_list, '==', 0, 'Empty list does not get called' );

my $no_change = 0;
diff_arrays( \@old, \@old, sub { $no_change++ }, sub { $no_change++ } );
cmp_ok( $no_change, '==', 0, 'No change does not get called' );

my $new_count = 0;
diff_arrays( [], \@new, sub { $new_count-- }, sub { $new_count++ } );
cmp_ok( $new_count, '==', scalar @new, 'New from scratch' );

