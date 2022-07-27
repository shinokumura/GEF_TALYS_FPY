#!/usr/bin/perl
#
# check GEF FF in chart at 1MeV
#
#use strict;
#use warnings;
use File::Basename;


require '/Users/okumuras/Dropbox/integral/datasub.pl';


my $YApath = "/Users/okumuras/Documents/codes/talys/structure/fission/ff/gef/";
# my $YApath = "/Users/okumuras/Downloads/gef/";
my @dirs = glob($YApath. '*');

my @nuclides = ();
my $selection = "ya";

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

my $z = 0;
my $n = 0;

for ($z=116; $z >74; $z--){
    print "\\rule{1pt}{2pt}";
    print &ztoelem($z)."&";
    for ($n=92; $n < 180; $n++){
	if (defined $this[$z][$n]){
	    my $nul =  $this[$z][$n];
	    my @fnl = glob("/Users/okumuras/Desktop/tmp/gef/" . $selection . "/" . $nul  . "_" . "5.*e+00.eps");
	    if (!@fnl) {@fnl = glob("/Users/okumuras/Desktop/tmp/gef/" . $selection . "/" . $nul  . "_" . "6.*e+00.eps");}
	    if (!@fnl) {@fnl = glob("/Users/okumuras/Desktop/tmp/gef/" . $selection . "/" . $nul  . "_" . "7.*e+00.eps");}
	    if (!@fnl) {@fnl = glob("/Users/okumuras/Desktop/tmp/gef/" . $selection . "/" . $nul  . "_" . "8.*e+00.eps");}
	    if (!@fnl) {@fnl = glob("/Users/okumuras/Desktop/tmp/gef/" . $selection . "/" . $nul  . "_" . "9.*e+00.eps");}
	    if (!@fnl) {@fnl = glob("/Users/okumuras/Desktop/tmp/gef/" . $selection . "/" . $nul  . "_" . "1.*e+01.eps");}
	    my $fn = $fnl[0];
	    #my $fn = "Eex/" . $selection . "/" .  $nul . "_2.53e-08.eps";
	    print"\\begin{minipage}{5mm}\\scalebox{0.1}{\\includegraphics{$fn}}\\end{minipage} & ";
	    #print"y& ";
	}
	else{
	    print"&";
	}
    }
    print "\\\\ \\hline\n";
}
for ($n=91; $n < 180; $n++){print "$n &"}
print "\\end{tabular}\n\\end{table}\n";

## pdflatex -shell-escape chart.tex
