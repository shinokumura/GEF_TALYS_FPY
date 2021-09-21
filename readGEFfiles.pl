#!/usr/bin/perl
###########################################################################
#
#  Check GEF generated FFY distribution
#
#                                                       2021 Aug by SO
#
###########################################################################

use strict;
use warnings;
use File::Basename;

my $amin = 1;
my $amax = 190;

# read file from the talys structure file, version autotalys_2021.08.09.tar
my $TalysStructurePath = "/Users/okumuras/Documents/codes/talys/structure/fission/ff/gef/";

unlink glob('YA/*');

my @nuclides = glob($TalysStructurePath. '*');
foreach my $n (@nuclides){
    my @base = basename($n);
    # print "@base\n";

    foreach my $nuclide (@base){
	my $path = $TalysStructurePath . $nuclide . "/" . $nuclide;
	my $EnergyList =  $path .  "_gef.E";
	my @energy =  `cat $EnergyList`;
	#print @energy;
	
	open(EN, $EnergyList) or die "no energy list file";
	while(<EN>){
	    my @ffya = ();
	    chomp $_;
	    my $en = $_;
	    my $file = $path .  "_" . $en . "MeV_gef.ff";
	    print "$file\n";
	    my @ffya = &readfpy($nuclide, $file, $en);

	    &outeps($nuclide, $en, @ffya);
	}
	close(EN);

	&outtex($nuclide, @energy);
    }
}


sub readfpy{
    my @ffya = ();
    my ($nuclide, $file, $en) = @_;
    
    open(FF, $file) or die "no such ff file";
    while(my $line = <FF>){
	my ($xx, $zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh) = split(/\s+/, $line);
	if ($zl =~ /^[0-9]/){
	    $ffya[$al] += $ffy;
	    $ffya[$ah] += $ffy;
	    # print "$zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh\n";
	}
    }
    close(FF);
    return @ffya;
}


    
sub outeps{    
    my ($nuclide, $en, @ffya) = @_;
    #print(@ffya);
    
    # define output file
    my $outya = "YA/" .  $nuclide . "_" . $en . ".dat";
    open (YA, "> $outya");
    
    my $mass = 0;
    for ($mass=$amin; $mass <=$amax; $mass++){
    	if (defined($ffya[$mass]))  {
	    printf YA ("%5d  %11.4E\n",$mass, $ffya[$mass]);
	}
    }
    # output eps
    my $cmd = `gnuplot -e "nuclide='$nuclide'; en='$en'" YA.plt`;
    system($cmd);
    close(YA);
}


sub outtex{    
    my ($nuclide, @energy) = @_;
    print(@energy);
    
    # define output file
    my $listtex = "YA/list.tex";
    
    my $outtex = "YA/" .  $nuclide . ".tex";
    open (LIST, ">> $listtex");
    print LIST "\\input{$outtex} \n";
    
    open (TEX, ">> $outtex");
    my $i = 0;
    print TEX "\\section{$nuclide}\n";
    for ($i=1; $i < $#energy+1; $i++){
        chomp($energy[$i-1]);
	my $epsname = "YA/" .  $nuclide . "_" . $energy[$i-1] . ".eps";
	# if ($i == 1){print TEX "\\begin{figure}[htbp]\n";}
	if ($i % 3  == 0) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n\\end{figure}\n";}
	if ($i % 3  == 1) {print TEX "\\begin{figure}[htbp]\n \\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
	if ($i % 3  == 2) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
    }
    print TEX "\\clearpage\n\n";
    close(LIST);
    close(TEX);
}


# Run tex compile
my $return_value = `pdflatex main.tex`;
