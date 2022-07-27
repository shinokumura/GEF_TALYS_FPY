#!/usr/bin/perl
###########################################################################
#
#  Check all FFY distribution
#
#                                                       2022 Jan by SO
#
###########################################################################

#use strict;
use warnings;
use File::Basename;

my $amin = 1;
my $amax = 190;

my $zmin = 1;
my $zmax = 110;

my $outpath = "/Users/okumuras/Desktop/tmp/";


# read file from the talys structure file, version autotalys_2021.08.09.tar
my $TalysStructurePath = "/Users/okumuras/Documents/codes/talys/structure/fission/ff/";
my @ffmodels = ("gef");


# select from ya tke txe ffex ffwidth
my $selection = "ya";


foreach $ffmodel (@ffmodels){
    unlink glob($outpath . $ffmodel . "/" . $selection . "/*");
    my @nuclides = glob($TalysStructurePath. $ffmodel . '/*');
    foreach my $n (@nuclides){
	my @base = basename($n);
	print "@base\n";

	foreach my $nuclide (@base){
	    #if ($nuclide eq "U236"){
	    my $path = $TalysStructurePath . $ffmodel . "/" . $nuclide . "/" . $nuclide;
	    my $EnergyList =  $path .  "_" . $ffmodel . ".E";
	    my @energy =  `cat $EnergyList`;
	    #print @energy;
	    
	    open(EN, $EnergyList) or die "no energy list file";

	    # loop over energy
	    while(<EN>){
		
		my @ffya = ();
		my @eex = ();
		
		chomp $_;
		my $en = $_;
		my $file = $path .  "_" . $en . "MeV_" . $ffmodel . ".ff";
		print "$file\n";

		if ($selection eq "ya"){
		    @ffya = &readfpy("ya", $nuclide, $file, $en);
		    &outya($outpath,$ffmodel, $nuclide, $en, @ffya);
		}
	        else {
		    @eex  = &readfpy($selection, $nuclide, $file, $en);
		    &outen($outpath,$ffmodel, $selection, $nuclide, $en, @eex);
		}
	    }
	    close(EN);
	    if ($selection eq "ya"){
		&outtexya($ffmodel, $nuclide, @energy);
	    }
	    else{
		&outtexen($ffmodel, $selection, $nuclide, @energy);
	    }
	}
    }
}

sub readfpy{   
    my ($selection, $nuclide, $file, $en) = @_;
    my @ffya = ();
    my @fftke = ();
    my @fftxe = ();
    my @ffe = ();
    my @ffewidth = ();
    open(FF, $file) or die "no such ff file";
    #print $file;
    while(my $line = <FF>){
	$line       =~ s/^#//;
	$line       =~ s/\s+//;
	my ($zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh) = split(/\s+/, $line);

	if ($zl =~ /^[0-9]/){
	    $ffya[$al] += $ffy;
	    $ffya[$ah] += $ffy;
	    
	    $fftke[$zl][$al] = $tke;
	    $fftke[$zh][$ah] = $tke;
	    
	    $fftxe[$zl][$al] = $txe;
	    $fftxe[$zh][$ah] = $txe;
	    
	    $ffe[$zl][$al] = $el;
	    $ffe[$zh][$ah] = $eh;

	    $ffewidth[$zl][$al] = $wl;
	    $ffewidth[$zh][$ah] = $wh;
	    
	    # print "$zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh\n";
	}
    }
    close(FF);
    if ($selection eq "ya"){return @ffya;}
    if ($selection eq "tke"){return @fftke;}
    if ($selection eq "txe"){return @fftxe;}
    if ($selection eq "ffex"){return @ffe;}
    if ($selection eq "ffewidth"){return @ffewidth;}
}


sub outen{    
    my ($outpath,$ffmodel, $selection, $nuclide, $en, @eex) = @_;
    
    my $outeex = $outpath . $ffmodel . "/" . $selection . "/" .  $nuclide . "_" . $en . ".dat";
    
    open (FFEN, "> $outeex");
    
    my $mass = 0;
    for ($mass=$amin; $mass <=$amax; $mass++){
	for ($charge=$zmin; $charge <=$zmax; $charge++){
	    
	    if (defined($eex[$charge][$mass]))  {
		printf FFEN ("%5d %5d   %11.4E\n",$charge, $mass,  $eex[$charge][$mass]);
	    }
	}
    }
    # output eps
    my $cmd = `gnuplot -e "outpath='$outpath';selection='$selection'; nuclide='$nuclide'; ffmodel='$ffmodel'; en='$en'" EN.plt`;
    system($cmd);
    close(FFEN);
}

    
sub outya{
    my ($outpath,$ffmodel, $nuclide, $en, @ffya) = @_;
    #print(@ffya);
    
    # define output file
    my $outya = $outpath . $ffmodel . "/ya/" .  $nuclide . "_" . $en . ".dat";
    open (YA, "> $outya");
    
    my $mass = 0;
    for ($mass=$amin; $mass <=$amax; $mass++){
    	if (defined($ffya[$mass]))  {
	    printf YA ("%5d  %11.4E\n",$mass, $ffya[$mass]);
	}
    }
    # output eps
    my $cmd = `gnuplot -e "outpath='$outpath'; nuclide='$nuclide'; en='$en'; ffmodel='$ffmodel'" YA.plt`;
    system($cmd);
    close(YA);
}



sub outtexya{    
    my ($ffmodel, $nuclide, @energy) = @_;
    print(@energy);
    
    # define output file
    my $listtex = $outpath . $ffmodel. "/ya/list.tex";
    my $outtex =  $outpath . $ffmodel. "/ya/" .  $nuclide . ".tex";
    open (LIST, ">> $listtex");
    print LIST "\\input{$outtex} \n";
    
    open (TEX, ">> $outtex");
    my $i = 0;
    print TEX "\\subsubsection{$nuclide}\n";
    for ($i=1; $i <= $#energy+1; $i++){
        chomp($energy[$i-1]);
	my $epsname = $outpath. $ffmodel .  "/ya/" .  $nuclide . "_" . $energy[$i-1] . ".eps";
	# if ($i == 1){print TEX "\\begin{figure}[htbp]\n";}
	if ($i % 3  == 0) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n\\end{figure}\n";}
	if ($i % 3  == 1) {print TEX "\\begin{figure}[H]\n \\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
	if ($i % 3  == 2) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
	if ($i % 3  != 0 && $i == $#energy+1) {print TEX "\\end{figure}\n";}
        
    }
    print TEX "\\clearpage\n\n";
    close(LIST);
    close(TEX);
}




sub outtexen{    
    my ($selecion, $nuclide, @energy) = @_;
    print(@energy);
    
    # define output file
    my $listtex = $outpath . $ffmodel. "/" . $selection . "/" . "list.tex";
    my $outtex = $outpath . $ffmodel. "/" . $selection . "/" . $nuclide . ".tex";
    open (LIST, ">> $listtex");
    print LIST "\\input{$outtex} \n";
    
    open (TEX, ">> $outtex");
    my $i = 0;
    print TEX "\\subsubsection{$nuclide}\n";
    for ($i=1; $i < $#energy+1; $i++){
        chomp($energy[$i-1]);
	my $epsname = $outpath. $ffmodel .  "/" . $selection . "/" .  $nuclide . "_" . $energy[$i-1] . ".eps";
	# if ($i == 1){print TEX "\\begin{figure}[htbp]\n";}
	if ($i % 3  == 0) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n\\end{figure}\n";}
	if ($i % 3  == 1) {print TEX "\\begin{figure}[H]\n \\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
	if ($i % 3  == 2) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
	if ($i % 3  != 0 && $i == $#energy+1) {print TEX "\\end{figure}\n";}
    }
    print TEX "\\end{figure}\\clearpage\n\n";
    close(LIST);
    close(TEX);
}





# Run tex compile
# my $return_value = `pdflatex main.tex`;
