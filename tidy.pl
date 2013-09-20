#!/usr/bin/perl

use strict;
use warnings;

print "Content-type: text/plain\n\n";

my $data;
sysread( STDIN, $data, $ENV{CONTENT_LENGTH} );
print "$data\n";

exit;
