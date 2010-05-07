package Algorithm::Diff::Callback;

use strict;
use warnings;

use Carp;
use Exporter        'import';
use List::MoreUtils 'uniq';
use Algorithm::Diff 'diff';

our $VERSION   = '0.02';
our @EXPORT_OK = qw(diff_hashes diff_arrays);

sub diff_hashes {
    my ( $old, $new, $del_cb, $add_cb, $changed_cb ) = @_;
    my @changed = ();

    foreach my $cell ( keys %{$new} ) {
        if ( ! exists $old->{$cell} ) {
            $add_cb->( $cell, $new->{$cell} );
        } else {
            push @changed, $cell;
        }
    }

    foreach my $cell ( keys %{$old} ) {
        if ( ! exists $new->{$cell} ) {
            $del_cb->( $cell, $old->{$cell} );
        }
    }

    foreach my $changed (@changed) {
        my $before = $old->{$changed} || '';
        my $after  = $new->{$changed} || '';

        if ( $before ne $after ) {
            $changed_cb->( $changed, $before, $after );
        }
    }
}

sub diff_arrays {
    my ( $old, $new, $del_cb, $add_cb ) = @_;

    # normalize arrays
    my @old = uniq sort @{$old};
    my @new = uniq sort @{$new};

    my @diffs = diff( \@old, \@new );

    foreach my $diff (@diffs) {
        foreach my $changeset ( @{$diff} ) {
            my ( $change, undef, $value ) = @{$changeset};

            if ( $change eq '+' ) {
                $add_cb->($value);
            } elsif ( $change eq '-' ) {
                $del_cb->($value);
            } else {
                croak "Can't recognize change in changeset: '$change'";
            }
        }
    }
}

1;

__END__

=head1 NAME

Algorithm::Diff::Callback - Use callbacks on computed differences

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

Use callbacks in your diff process to get better control over what will happen.

    use Algorithm::Diff::Callback 'diff_arrays';

    diff_arrays(
        \@old_family_members,
        \@new_family_members,
        sub { print 'Happy to hear about ', shift },
        sub { print 'Sorry to hear about ', shift },
    );

Or using hashes:

    use Algorithm::Diff::Callback 'diff_hashes';

    diff_hashes(
        \%old_details,
        \%new_details,
        sub { print 'Lost ',   shift },
        sub { print 'Gained ', shift },
        sub {
            my ( $key, $before, $after ) = @_;
            print "$key changed from $before to $after\n";
        },
    );

One of the difficulties when using diff modules is that they assume they know
what you want the information for. Some give you formatted output, some give you
just the values that changes (but neglect to mention how each changed) and some
(such as L<Algorithm::Diff>) give you way too much information that you now have
to skim over and write long complex loops for.

L<Algorithm::Diff::Callback> let's you pick what you're going to diff (Array,
Hashes) and set callbacks for the diff process.

=head1 EXPORT

=head2 diff_arrays

=head2 diff_hashes

=head1 SUBROUTINES/METHODS

=head2 diff_arrays(\@old, \@new, \&removed, \&added)

The first two parameters are array references to compare.

The second two parameters are subroutine references which will be called and
given the value that was either removed or added during the diff process.

The comparison is explicitly the second one B<against> the first one.

That means that if you give a I<removed> subroutine, it really means that a
value that existed in the first arrayref does not exist in the second arrayref.

If you gave a I<added> subroutine, it really means that a value that did B<not>
exist in the first arrayref now exists in the second one.

=head2 diff_hashes(\%old, \%new, \&removed, \&added, \&change)

The first two parameters are hash references to compare.

The second two paramters are the subroutine references which will be called and
given the key and value that was either removed or added during the diff
process.

The third parameter is a subroutine reference of information that changed
between the first and second hashes. It will be given the key that was changed,
the value it had before and the value it now has in the new reference.

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report bugs on the Github issues page at
L<http://github.com/xsawyerx/algorithm-diff-callback/issues>.

=head1 SUPPORT

This module sports 100% test coverage, but in case you have more issues...

You can find documentation for this module with the perldoc command.

    perldoc Algorithm::Diff::Callback

You can also look for information at:

=over 4

=item * Github issues tracker

L<http://github.com/xsawyerx/algorithm-diff-callback/issues>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Algorithm-Diff-Callback>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Algorithm-Diff-Callback>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Algorithm-Diff-Callback>

=item * Search CPAN

L<http://search.cpan.org/dist/Algorithm-Diff-Callback/>

=back

=head1 DEPENDENCIES

L<Algorithm::Diff>

L<List::MoreUtils>

L<Carp>

L<Exporter>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Sawyer X.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

