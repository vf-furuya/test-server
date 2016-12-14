#!/usr/bin/perl

my $file = 'getpath.cgi';
$ENV{'SCRIPT_FILENAME'} =~ /(.*)$file/;;
$myroot = $1;

print "Conten-type: text/html", "\n\n";
print "<html>";
print "$myroot";
print "</html>";
exit;
