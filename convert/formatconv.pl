#!/usr/bin/perl
#use warnings;
use File::Basename;
# require "/Users/okumuras/Dropbox/integral/datasub.pl";

@elem_list=("", 
	   "H" , "He", "Li", "Be", "B" , "C" , "N" , "O" , "F" , "Ne",
	   "Na", "Mg", "Al", "Si", "P" , "S" , "Cl", "Ar", "K" , "Ca",
	   "Sc", "Ti", "V" , "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn",
	   "Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y" , "Zr",
	   "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn",
	   "Sb", "Te", "I" , "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd",
	   "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb",
	   "Lu", "Hf", "Ta", "W" , "Re", "Os", "Ir", "Pt", "Au", "Hg",
	   "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th",
	   "Pa", "U" , "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm",
	   "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds",
	   "Rg", "Cn", "Nh", "Fl", "Mc", "Lv", "Ts", "Og", "Uue","Ubn",
	   "Ubu","Ubb","Ubt","Ubq","Ubp","Ubh","Ubs","Ubo","Ube","Utn",
	   "Utu","Utb","Utt","Utq","Utp","Uth","Uts","Uto","Ute","Uqn",);

sub ztoelem {
    my $z = shift;
    my $elem_name = "";
    if    ($z == "0")   {$elem_name = "g";}
    else{
	$elem_name = $elem_list[$z];
    }
    #print "$elem_list[$z]";
    return $elem_name;
}

sub elemtoz {
    my $elem_name = shift;
    #$z =  grep { $elem_list[$_] eq $elem_name} 0..$#elem_list;
    while(my($indexnum,$elemm) = each @elem_list){
	if($elemm eq  $elem_name){$z=$indexnum;}
    }
    #print "$elem_name  --> $z\n";
    return $z;
}

#################### for SPY files to spy/ | gef/ to gef/ hf3d to hf3d
my $f = $ARGV[0];
my $en = $ARGV[1];
my $mode = $ARGV[2];

#print $mode;
chomp($f);
open(FF, $f) or die "no such file";
my $base = basename($f);
while(my $line = <FF>){
    my $a = 0;
    if ($. eq 1){
	#  Ntotal =  868 Z =  92 A = 236 Ex =  6.54 MeV
	my ($xx, $nnnn, $ntotal, $zzz, $z, $aaa, $a, $eeee, $e) = split(/[\s=]+/, $line);
	my $edisp = 0;
	
	# if ($mode eq "spy"){
	#     $edisp = sprintf("%2.2e",$e);
	# }
	
	if($mode eq "gef"){
	    $a += 1;
	}
	
	if($mode eq "hf3d"){
	    $base =~ /([A-Za-z]+)([0-9]+)_/;
	    $el = $1;
	    $a = $2;
	    
	    $z = &elemtoz($el);
	}
	my $edisp = sprintf("%2.2e",$en);
	my $adisp = sprintf("%4d", $a);
	my $zdisp = sprintf("%4d", $z);
	my $ntotdisp = sprintf("%4d", $ntotal);
	
	print "# Z        = $zdisp\n";
	print "# A        = $adisp\n";
	print "# Ex (MeV) = $edisp\n";
	print "# Ntotal   = $ntotdisp\n";
    }
    elsif ($. eq 2){
	print "# Zl  Al  Zh  Ah  Yield       TKE[MeV]    TXE[MeV]    El[MeV]     Wl[MeV]     Eh[MeV]     Wh[MeV]\n";
    }
    else{
	if ($mode eq "hf3d"){
	    my ($xx, $n, $k, $zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh) = split(/\s+/, $line);
	    printf("%4d%4d%4d%4d%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n",$zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh);
	}
	else{
	    my ($xx, $zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh) = split(/\s+/, $line);
	    printf("%4d%4d%4d%4d%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n",$zl, $al, $zh, $ah, $ffy, $tke, $txe, $el, $wl, $eh, $wh);
	}
    }
}
close(FF);





