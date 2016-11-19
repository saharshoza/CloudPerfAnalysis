Workerpid=$1
memoryArray=(2048 4096 6144 8192)
unit=M
mkdir results
echo "mkdir results" | ssh cc@node-1 /bin/bash
echo "mkdir results" | ssh cc@node-2 /bin/bash
echo "mkdir results" | ssh cc@node-3 /bin/bash

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

	echo "Get Worker PID on remote machines"
	node1Worker=`echo "jps | grep Worker" | ssh cc@node-1 /bin/bash | awk {'print$1'}`
	node2Worker=`echo "jps | grep Worker" | ssh cc@node-2 /bin/bash | awk {'print$1'}`
	node3Worker=`echo "jps | grep Worker" | ssh cc@node-3 /bin/bash | awk {'print$1'}`

	echo "Spawn perf on remote machines"
	echo "Node1 spawned"
	ssh cc@node-1 screen -d -m "sudo perf record -e instructions,cycles,branches,branch-misses -p $node1Worker"
	node1pid=`echo "ps aux | grep perf | grep root" | ssh cc@node-1 /bin/bash | awk {'print$2'} | head -1`
	echo "Node2 spawned"
	ssh cc@node-2 screen -d -m "sudo perf record -e instructions,cycles,branches,branch-misses -p $node2Worker"
	node2pid=`echo "ps aux | grep perf | grep root" | ssh cc@node-2 /bin/bash | awk {'print$2'} | head -1`
	echo "Node3 spawned"
	ssh cc@node-3 screen -d -m "sudo perf record -e instructions,cycles,branches,branch-misses -p $node3Worker"
	node3pid=`echo "ps aux | grep perf | grep root" | ssh cc@node-3 /bin/bash | awk {'print$2'} | head -1`

	echo "Gather CPI, Branch miss rate"
	nohup sudo perf record -e instructions,cycles,branches,branch-misses -p $Workerpid >>cpi.out &
	echo $! > run.pid
	perfProcess=`cat run.pid`
	bash $SPARK_BENCH_HOME/Terasort/bin/run.sh
	sudo kill -15 $perfProcess
	sudo mv perf.data results/perf.data.1."$memoryConfig"

	echo "Clean up on remote machines"
	echo "sudo kill -15 $node1pid" | ssh cc@node-1 /bin/bash
	echo "mv perf.data results/perf.data.1."$memoryConfig"" | ssh cc@node-1 /bin/bash
	echo "sudo kill -15 $node2pid" | ssh cc@node-2 /bin/bash
	echo "mv perf.data results/perf.data.1."$memoryConfig"" | ssh cc@node-2 /bin/bash
	echo "sudo kill -15 $node3pid" | ssh cc@node-3 /bin/bash
	echo "mv perf.data results/perf.data.1."$memoryConfig"" | ssh cc@node-3 /bin/bash

	echo "Spawn perf on remote machines"
	echo "Node1 spawned"
	ssh cc@node-1 screen -d -m "sudo perf record -e cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses -p $node1pid"
	node1pid=`echo "ps aux | grep perf | grep root" | ssh cc@node-1 /bin/bash | awk {'print$2'} | head -1`
	echo "Node2 spawned"
	ssh cc@node-2 screen -d -m "sudo perf record -e cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses -p $node2Worker"
	node2pid=`echo "ps aux | grep perf | grep root" | ssh cc@node-2 /bin/bash | awk {'print$2'} | head -1`
	echo "Node3 spawned"
	ssh cc@node-3 screen -d -m "sudo perf record -e cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses -p $node3Worker"
	node3pid=`echo "ps aux | grep perf | grep root" | ssh cc@node-3 /bin/bash | awk {'print$2'} | head -1`

	echo "Gather Cache miss rate, L1D miss rate"
	nohup sudo perf record -e cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses -p $Workerpid >>cache.out &
	echo $! > run.pid
	perfProcess=`cat run.pid`
	bash $SPARK_BENCH_HOME/Terasort/bin/run.sh
	sudo kill -15 $perfProcess	
	sudo mv perf.data results/perf.data.2."$memoryConfig"

	echo "Clean up on remote machines"
	echo "sudo kill -15 $node1pid" | ssh cc@node-1 /bin/bash
	echo "mv perf.data results/perf.data.2."$memoryConfig"" | ssh cc@node-1 /bin/bash
	echo "sudo kill -15 $node2pid" | ssh cc@node-2 /bin/bash
	echo "mv perf.data results/perf.data.2."$memoryConfig"" | ssh cc@node-2 /bin/bash
	echo "sudo kill -15 $node3pid" | ssh cc@node-3 /bin/bash
	echo "mv perf.data results/perf.data.2."$memoryConfig"" | ssh cc@node-3 /bin/bash

done