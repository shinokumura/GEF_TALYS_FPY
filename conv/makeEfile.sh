mode="gef"
dir="/Users/okumuras/Downloads/gef-conv/*"
for nucl in $dir
do
    if [ -d "$nucl" ]; then
	
	base=`basename $nucl`
	echo $base
    ENARRAY=()
    
    for file in $nucl/*.ff
    do
	process=`basename $file | sed -E 's/_[a-z3]{3,4}.ff//'`
	energy=`echo ${process#*_} | sed -e 's/MeV//'`
	
	echo "nu:" $nucl "file:" $file "process:" $process "en:" $energy

	ENARRAY+=($energy)
    done
    
    efile=$nucl/${base}_${mode}.E
    printf '%s\n' "${ENARRAY[@]}"| sort -g > $efile

    fi
done
