#!/bi/sh


ls -1 *.ff |cut -f1 -d'_' | xargs mkdir

for cn in *.ff
do
    dir=`ls $cn | cut -f1 -d'_'`
    mv $cn $dir/
    
done
