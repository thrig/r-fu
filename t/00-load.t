#!perl
use Test::More tests => 1;

diag("Testing r-fu, Perl $], $^X");

qx"$^X -c ./r-fu";

is( $? >> 8, 0, 'syntax check' ) || print "Bail out!\n";
