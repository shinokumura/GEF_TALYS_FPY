#!/usr/bin/perl
#
# check GEF FF in chart at 1MeV
#
#use strict;
#use warnings;
use File::Basename;


require '/Users/okumuras/Dropbox/integral/datasub.pl';


my $YApath = "/Users/okumuras/Documents/codes/talys/structure/fission/ff/gef/";
my @dirs = glob($YApath. '*');

my @nuclides = ();

foreach my $d (@dirs) {
    push(@nuclides, basename($d));
}
#print @nuclides;

my @this = ();
foreach my $nuclide (@nuclides){
    $nuclide =~ /([A-Za-z]{1,2})([0-9]{2,3})/;
    my $elem = $1;
    my $mass = $2;
    my $charge = &elemtoz($elem);
    my $neutron = $mass- $charge;
    #print "$elem $mass $charge, $neutron\n";
    $this[$charge][$neutron] = $nuclide;
}
#print @this;

my $col = "l" x 122;

print "\\begin{table}[htbp]\n\\begin{tabular}{$col}\n";
#print "\\begin{table}[htbp]\n\\begin{tabular}{}\n";
#print "\\begin{TAB}(r,1cm,2cm)[5pt]{$col}\n";

my $z = 0;
my $n = 0;

for ($z=116; $z >74; $z--){
    print "\\rule{1pt}{2pt}";
    print &ztoelem($z)."&";
    for ($n=92; $n < 180; $n++){
	if (defined $this[$z][$n]){
	    my $nul =  $this[$z][$n];
	    my $fn = "YA/" . $nul  . "_" . "1.00e+00-eps-converted-to.pdf";
	    print"\\begin{minipage}{5mm}\\scalebox{0.1}{\\includegraphics{$fn}}\\end{minipage} & ";
	    #print"y& ";
	}
	else{
	     print"&";
	}
    }
    print "\\\\ \\hline\n";
}
for ($n=90; $n < 180; $n++){print "$n &"}
print "\\end{tabular}\n\\end{table}\n";
#print "\\end{TAB}\n";

=pod
\begin{table}[htbp]
\begin{tabular}{llllllllllllllllllll}
z120
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  \\
 &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  &  & 
z10
n20                                                 n120
\end{tabular}
\end{table}
=cut
