Workerpid=$1
memoryArray=(2048 4096 6144 8192)
unit=M
mkdir results
for memoryConfig in ${memoryArray[@]}
do
	echo "Begin Modifying spark-env.sh"
	cp $SPARK_HOME/conf/spark-env.sh ./
	sed -i 's/^export SPARK_EXECUTOR_MEMORY.*$/export SPARK_EXECUTOR_MEMORY='"$memoryConfig""$unit"'/' spark-env.sh
	cp spark-env.sh $SPARK_HOME/conf/
	scp cc@node-1:$SPARK_HOME/conf/spark-env.sh ./
	sed -i 's/^export SPARK_EXECUTOR_MEMORY.*$/export SPARK_EXECUTOR_MEMORY='"$memoryConfig""$unit"'/' spark-env.sh
	scp spark-env.sh cc@node-1:$SPARK_HOME/conf/
	scp cc@node-2:$SPARK_HOME/conf/spark-env.sh ./
	sed -i 's/^export SPARK_EXECUTOR_MEMORY.*$/export SPARK_EXECUTOR_MEMORY='"$memoryConfig""$unit"'/' spark-env.sh
	scp spark-env.sh cc@node-2:$SPARK_HOME/conf/
	scp cc@node-3:$SPARK_HOME/conf/spark-env.sh ./
	sed -i 's/^export SPARK_EXECUTOR_MEMORY.*$/export SPARK_EXECUTOR_MEMORY='"$memoryConfig""$unit"'/' spark-env.sh
	scp spark-env.sh cc@node-3:$SPARK_HOME/conf/
	echo "End Modifying spark-env.sh"

	echo "This run is just for execution time"
	bash $SPARK_BENCH_HOME/Terasort/bin/run.sh

	echo "Gather CPI, Branch miss rate"
	nohup sudo perf record -e instructions,cycles,branches,branch-misses -p $Workerpid >>cpi.out &
	echo $! > run.pid
	perfProcess=`cat run.pid`
	bash $SPARK_BENCH_HOME/Terasort/bin/run.sh
	sudo kill -15 $perfProcess
	sudo mv perf.data results/perf.data.1."$memoryConfig"

	echo "Gather Cache miss rate, L1D miss rate"
	nohup sudo perf record -e cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses -p $Workerpid >>cache.out &
	echo $! > run.pid
	perfProcess=`cat run.pid`
	bash $SPARK_BENCH_HOME/Terasort/bin/run.sh
	sudo kill -15 $perfProcess	
	sudo mv perf.data results/perf.data.2."$memoryConfig"
done