#!perl

use Test::Cmd;
use Test::Most tests => 2;

my $deeply = \&eq_or_diff;

my $test_prog = './r-fu';
my $test_dir  = 't';

$ENV{ARLET_DIR} = $test_dir;

my $Test_Cmd = Test::Cmd->new(
    interpreter => $^X,
    prog        => $test_prog,
    verbose     => 0,            # TWEAK if need to see command being run
    workdir     => '',
);

my @args = (
    "11 42", "640", "42", "0.6", "0.4", "xxx",
    "no y-label", "r-fu", "argsarlet", "1 2 3 dev.png", "png"
);
$Test_Cmd->run( args =>
      "--column=11 --column=42 --width=640 --height=42 --p-value=0.6 --xlabel=xxx argsarlet 1 2 3 dev.png"
);

my @got = $Test_Cmd->stdout;
chomp(@got);
$deeply->( \@got, \@args );

# or set 'use strictures 2;' over in r-fu to make it blow up on warning
is( $Test_Cmd->stderr, "", "no stderr" );
