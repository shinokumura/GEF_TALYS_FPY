#!/bin/bash
##################################################################
###
### Convert SPY FF files to the temporary GEF format filename
### 11 Oct. 2021
###
##################################################################

TALYS=/Users/okumuras/Documents/codes/talys/source/talys
DATADIR=/Users/okumuras/Documents/calculations/talys/fpy-gef-nsep


cd $DATADIR
#rm -rf $DATADIR/*
ARRAY=()
############ (1) glob ff files
# STRDIR=/Users/okumuras/Documents/codes/talys/structure/fission/ff/gef-original/*
# for file in $STRDIR
# do
#     base=`basename $file | sed -e 's/_gef.ff//'`
#     nuclide=${base%_*}
#     #echo $base $nuclide
#     ARRAY+=($nuclide)
# done


# ### remove duplicate
# nuclides=`echo "${ARRAY[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '`
# #echo $nuclides


############## (2) Run Talys calculation to obtain n-separation energy
#### how to run: ls /Users/okumuras/Downloads/gef-conv | xargs -L1 -P4 ./nsepcalc.sh


#for n in $nuclides
#do

n=$1
    mass=`echo $n | sed -E 's/[A-Za-z]{1,2}//'`
    tmass=$(( $mass ))
    elem=`echo $n | sed -E 's/[0-9]{2,3}//'`
    echo $n $mass $elem $tmass
    mkdir ./$n
    cd ./$n

cat > input.dat << EOF
Projectile g
Element $elem
Mass $tmass
Energy 0.1
Spherical y
Outbasic y
EOF

$TALYS <  input.dat > output.dat 2>&1
cd $DATADIR

#done


############ (3) get n-separation energies from Talys output
grep -A4 Separation */output.dat | grep neutron | sed -e 's/\/output.dat- neutron//' > n-separation.dat

