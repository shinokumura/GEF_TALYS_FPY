#!/bin/bash
##################################################################
###
### Convert GEF FF files to the excitation energy + compound nuleus representation
### 11 Oct. 2021
###
##################################################################

mode="gef"
# STRDIR=/Users/okumuras/Documents/codes/talys/structure/fission/ff/${mode}/*
STRDIR=/Users/okumuras/Downloads/gefyieldfiles_1e6_1MeVspacing/


cd $STRDIR

ls -1 [O-Z]*.ff |cut -f1 -d'_' | xargs mkdir

for cn in *.ff
do
    dir=`ls $cn | cut -f1 -d'_'`
    mv $cn $dir/
    
done

############ (4) Change GEF file names
FFTMPDIR=/Users/okumuras/Downloads/${mode}-conv/

cd $FFTMPDIR
rm -rf $FFTMPDIR/*

for tnucl in $STRDIR
do
    echo $tnucl
    
    for file in $tnucl/*.ff
    do
	echo "Process: " $file
	base=`basename $file | sed -E 's/_[a-z3]{3,4}.ff//'`
	n=${base%_*}

	# this is target mass
	mass=`echo $n | sed -E 's/[A-Za-z]{1,2}//'`
	elem=`echo $n | sed -E 's/[0-9]{2,3}//'`
	tnuclide=$elem$mass
	
	# this is compound mass
	cmass=$mass
	nuclide=$elem$cmass

	# grep neutron separation energy based on the compound nuclide
	# n-separation.dat file has target mass
	energy=`echo ${base#*_} | sed -e 's/MeV//'`
	SN=`cat n-separation.dat | tr -s ' ' | grep $nuclide | cut -d ' ' -f 2 | awk '{printf "%.2f", $0}'`
	

	# create directry with target nuclide name
	mkdir $nuclide
	
	if [[ $energy =~ ^2.53 ]];
	then
	    # consider the SN == almost zero energy == thermal
	    energytemp=`echo $SN | awk '{printf "%2.2e", $1}'`
	    newfilename=${nuclide}_${energytemp}MeV_${mode}.ff
	else
	    energytemp=`echo $energy $SN | awk '{printf "%2.2e", $1 + $2}'`
	    newfilename=${nuclide}_${energytemp}MeV_${mode}.ff
	fi

	echo $base $nuclide $energy "+" $SN "===>" $nuclide/$newfilename
	
	cp $file $nuclide/${newfilename}.tmp
	echo $nuclide/$newfilename.tmp $energytemp $mode | xargs perl formatconv.pl > $nuclide/$newfilename
	## echo $nuclide/$newfilename.tmp $energytemp $mode > $nuclide/$newfilename
	rm $nuclide/*.tmp
    
   done
done




