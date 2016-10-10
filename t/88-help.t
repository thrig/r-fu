#!perl
#
# Confirm *.help files contain something for each sample arlet.

$ENV{ARLET_DIR} = './arlets';

use Test::Cmd;
use Test::Most tests => 3 * 16;

my $test_prog = './r-fu';

my $Test_Cmd = Test::Cmd->new(
    interpreter => $^X,
    prog        => $test_prog,
    verbose     => 0,            # TWEAK if need to see command being run
    workdir     => '',
);

opendir my $dh, $ENV{ARLET_DIR} or die "could not open $ENV{ARLET_DIR}: $!\n";
while ( my $arlet = readdir $dh ) {
    next if $arlet =~ m/\./;
    $Test_Cmd->run( args => "--help $arlet" );
    my $out = $Test_Cmd->stdout;

    ok( defined $out && length $out > 0, "$arlet --help had output" );
    ok( $out =~ m/\Q$arlet/, "$arlet --help contains arlet name" );
    is( $Test_Cmd->stderr, "", "no stderr for $arlet --help" );
}
