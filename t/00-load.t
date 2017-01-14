#!perl
use Test::More tests => 1;
use Test::UnixExit;

diag("Testing r-fu, Perl $], $^X");

qx"$^X -c ./r-fu";

exit_is( $?, 0, 'syntax check' ) || print "Bail out!\n";
