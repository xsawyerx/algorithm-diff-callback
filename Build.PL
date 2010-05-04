use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Algorithm::Diff::Callback',
    license             => 'perl',
    dist_author         => q{Sawyer X <xsawyerx@cpan.org>},
    dist_version_from   => 'lib/Algorithm/Diff/Callback.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Algorithm-Diff-Callback-*' ],
    create_makefile_pl => 'traditional',
    create_license     => 1,
    create_readme      => 1,
);

$builder->create_build_script();
