#!perl

use strict;
use warnings;

use Test::More tests => 20;
use Algorithm::Diff::Callback 'diff_hashes', 'diff_arrays';

my %hash_tests = (
    'old hash' => [ 'Arg 1', 'hashref', undef, {},    sub {}, sub {}, sub {} ],
    'new hash' => [ 'Arg 2', 'hashref', {},    undef, sub {}, sub {}, sub {} ],
    'add cb'   => [ 'Arg 3', 'coderef', {},    {},    {},     sub {}, sub {} ],
    'del cb'   => [ 'Arg 4', 'coderef', {},    {},    undef,  {},     sub {} ],
    'ext cb'   => [ 'Arg 5', 'coderef', {},    {},    undef,  undef,  {}     ],
);

my %array_tests = (
    'old array' => [ 'Arg 1', 'arrayref', undef, [],    sub {}, sub {} ],
    'new array' => [ 'Arg 2', 'arrayref', [],    undef, sub {}, sub {} ],
    'add cb'    => [ 'Arg 3', 'coderef',  [],    [],    [],     sub {} ],
    'del cb'    => [ 'Arg 4', 'coderef',  [],    [],    undef,   []    ],
);

foreach my $hash_test ( keys %hash_tests ) {
    my @details = @{ $hash_tests{$hash_test} };
    my $arg     = shift @details;
    my $type    = shift @details;

    my ( $old_hash, $new_hash, $del_cb, $add_cb, $change_cb ) = @details;

    eval { diff_hashes( $old_hash, $new_hash, $del_cb, $add_cb, $change_cb ) };
    ok( $@, 'Caught error' );
    like( $@, qr/^$arg must be $type/, "$arg of $type not accepted" );
}

foreach my $array_test ( keys %array_tests ) {
    my @details = @{ $array_tests{$array_test} };
    my $arg     = shift @details;
    my $type    = shift @details;

    my ( $old_array, $new_array, $del_cb, $add_cb ) = @details;

    eval { diff_arrays( $old_array, $new_array, $del_cb, $add_cb ) };
    ok( $@, 'Caught error' );
    like( $@, qr/^$arg must be $type/, "$arg of $type not accepted" );
}

# these should always work
$@ = undef;
my $old_hash = { ack => 'back', now => 'here'  };
my $new_hash = { bad => 'luck', now => 'there' };

eval { diff_hashes( $old_hash, $new_hash, undef, undef, undef ) };
ok( ! $@, 'No error on diff_hashes' );

$@ = undef;
my $old_array = [ 'this', 'that' ];
my $new_array = [ 'this', 'got'  ];
eval { diff_arrays( $old_array, $new_array, undef, undef ) };
ok( ! $@, 'No error on diff_arrays' );
