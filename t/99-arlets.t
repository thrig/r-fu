#!perl
#
# Tests for included arlets, or really any r-fu invocation that produces
# exact output with the given ARLET_DIR. In particular, t/*.in files are
# read, run through r-fu, and the output compared to the contents of of
# the corresponding t/*.out files. Leading comments in the *.in file (#
# foo) will be skipped, and the first non-comment line used as arguments
# to r-fu. Standard input will be read from the remainder of the *.in
# file if - is the last argument on the argument line.

$ENV{ARLET_DIR} = './arlets';

use File::Spec ();
use Test::Cmd;
use Test::Most tests => 2 * 1;

my $deeply = \&eq_or_diff;

my $test_prog = './r-fu';
my $test_dir  = 't';

my $Test_Cmd = Test::Cmd->new(
    interpreter => $^X,
    prog        => $test_prog,
    verbose     => 0,            # TWEAK if need to see command being run
    workdir     => '',
);

opendir my $dh, $test_dir or die "could not open test dir: $!\n";
while ( my $test_file = readdir $dh ) {
    if ( $test_file =~ m/^(.*)\.in$/ ) {
        my $test_name = $1;
        run_test( $test_file, $test_name );
    }
}

sub run_test {
    my ( $test_file, $test_name ) = @_;
    my $test_output = File::Spec->catfile( $test_dir, "${test_name}.out" );
    my $args = '# comment';

    my $tfpath = File::Spec->catfile( $test_dir, $test_file );
    open my $tfh, '<', $tfpath or die "could not open $tfpath: $!\n";
    while ( substr( $args, 0, 1 ) eq '#' ) {
        $args = readline $tfh;
        die "empty test file $test_file\n" if !defined $args;
    }
    chomp $args;
    # NOTE may need additional flag to remove the - if the program being
    # tested does not follow the - convention
    # TODO may also need to hunt around for - if other arguments appear
    # after the stdin indicator (e.g. echo asdf | r-fu blah - 3.14 cat)
    my @stdin;
    if ( substr( $args, -1, 1 ) eq '-' ) {
        push @stdin, $_ while readline $tfh;
    }

    my @expect;
    open my $ofh, '<', $test_output or die "could not open $test_output: $!\n";
    push @expect, $_ while readline $ofh;
    chomp @expect;

    $Test_Cmd->run( length $args ? ( args => $args ) : (),
        @stdin ? ( stdin => \@stdin ) : () );
    my @got = $Test_Cmd->stdout;
    chomp @got;

    $deeply->( \@got, \@expect, "output check for $test_name" );
    is( $Test_Cmd->stderr, "", "no stderr for $test_name" );
}
