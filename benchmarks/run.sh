#!/bin/bash

ROOT_DIR=$(pwd)
cd benchmarks

# Get problem families
if [[ "$1" == "2010" ]]
then
    ./download_and_unpack2010.sh
    instances="problems2010"
    TIMEOUT_SOLVER=1800
    MEMOUT_SOLVER=512
else
    #./download_and_unpack2021.sh
    instances="problems2021"
    TIMEOUT_SOLVER=3600
    MEMOUT_SOLVER=32768
fi

# unarchive
for filename in $(ls "$instances")
do 
    gunzip ./"$instances"/"$filename"
done

# solve
TIMEOUT_SOLVER_PL=$TIMEOUT_SOLVER
TIMEOUT_VERIPB=$(echo 10*$TIMEOUT_SOLVER / 1 | bc)
MEMOUT_SOLVER_PL=$MEMOUT_SOLVER
MEMOUT_VERIPB=$(echo 1.25*$MEMOUT_SOLVER / 1 | bc)
TMPDIR=/tmp

for filename in $(ls "$instances")
do
    extension="${filename##*.}"
    filename="${filename%.*}"

    res_runtime_without_prooflogging="NA"
    res_mem_without_prooflogging="NA"
    res_runtime_with_prooflogging="NA"
    res_mem_with_prooflogging="NA"
    res_runtime_verification="NA"
    res_mem_verification="NA"
    res_verification_succeeded="NA"
    res_time_genCardinals_without_PL="NA"
    res_time_genCardinals="NA"
    res_time_genCardinalDefinitions="NA"
    res_proofsize="NA"

    ## VANILLA

    # run
    $ROOT_DIR/tools/runlim -r $TIMEOUT_SOLVER -s $MEMOUT_SOLVER -o $TMPDIR/${filename}.txt $ROOT_DIR/tools/qmaxsat $instances/${filename}.${extension}
    
    # extract time
    res_runtime_without_prooflogging=$(cat $TMPDIR/${filename}.txt | grep 'real:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?');

    # extract space
    res_mem_without_prooflogging=$(cat $TMPDIR/${filename}.txt | grep 'space:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?');

    # status
    status=$(cat $TMPDIR/${filename}.txt | grep 'status:' | awk '{print $3}');

    echo "$filename without prooflogging:"
    echo "runtime: $res_runtime_without_prooflogging "
    echo "mem: $res_mem_without_prooflogging"

    if [[ "$status" == "ok" ]]
    then

        ## PROOFLOGGED

        # run
        $ROOT_DIR/tools/runlim -r $TIMEOUT_SOLVER_PL -s $MEMOUT_SOLVER_PL -o $TMPDIR/${filename}.txt $ROOT_DIR/tools/qmaxsat_prooflogging -proof-file=${filename}_proof.pbp $instances/${filename}.${extension} 

        # extract time
        res_runtime_with_prooflogging=$(cat $TMPDIR/${filename}.txt | grep 'real:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?');

        # extract space
        res_mem_with_prooflogging=$(cat $TMPDIR/${filename}.txt | grep 'space:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?');

        # extract proof size
        res_proofsize=$(stat --printf="%s" ${filename}_proof.pbp)

        if [[ "$res_proofsize" == "" ]]
        then
            res_proofsize="NA"
        fi

        # status
        status=$(cat $TMPDIR/${filename}.txt | grep 'status:' | awk '{print $3}');

        echo "$filename with prooflogging:"
        echo "runtime: $res_runtime_with_prooflogging "
        echo "mem: $res_mem_with_prooflogging"
        echo "proofsize: $res_proofsize"
    
        if [[ "$status" == "ok" ]]
        then	

            ## VERIFICATION

            # run
            $ROOT_DIR/tools/runlim -r $TIMEOUT_VERIPB -s "$MEMOUT_VERIPB" -o $TMPDIR/${filename}.txt veripb --wcnf $instances/${filename}.${extension} ${filename}_proof.pbp > $TMPDIR/${filename}_verification.txt

            # extract time
            res_runtime_verification=$(cat $TMPDIR/${filename}.txt | grep 'real:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?');

            # extract space
            res_mem_verification=$(cat $TMPDIR/${filename}.txt | grep 'space:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?');

      	    echo "$filename verification:"
    	    echo "runtime: $res_runtime_verification "
        	echo "mem: $res_mem_verification"

         	if grep -q "succeeded" $TMPDIR/${filename}_verification.txt; then
          		res_verification_succeeded=1
          	else
           		res_verification_succeeded=0	
        	fi
        fi
        rm ${filename}_proof.pbp
    fi
    echo "$filename, $res_runtime_without_prooflogging, $res_mem_without_prooflogging, $res_runtime_with_prooflogging, $res_proofsize, $res_mem_with_prooflogging, $res_runtime_verification, $res_mem_verification, $res_verification_succeeded" >> ${instances}_results.csv
done