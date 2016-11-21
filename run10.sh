numCores=$1
memoryArray=(2048 4096 6144 8192)
unit=M

echo "Change numCores"

cd $SPARK_HOME/sbin/
./stop-all.sh

cd ~/CloudPerfAnalysis
echo "Begin Modifying spark-env.sh for $numCores"
cp $SPARK_HOME/conf/spark-env.sh ./
sed -i 's/^export SPARK_WORKER_CORES.*$/export SPARK_WORKER_CORES='"$numCores"'/' spark-env.sh
cp spark-env.sh $SPARK_HOME/conf/
scp cc@node-1:$SPARK_HOME/conf/spark-env.sh ./
sed -i 's/^export SPARK_WORKER_CORES.*$/export SPARK_WORKER_CORES='"$numCores"'/' spark-env.sh
scp spark-env.sh cc@node-1:$SPARK_HOME/conf/
scp cc@node-2:$SPARK_HOME/conf/spark-env.sh ./
sed -i 's/^export SPARK_WORKER_CORES.*$/export SPARK_WORKER_CORES='"$numCores"'/' spark-env.sh
scp spark-env.sh cc@node-2:$SPARK_HOME/conf/
scp cc@node-3:$SPARK_HOME/conf/spark-env.sh ./
sed -i 's/^export SPARK_WORKER_CORES.*$/export SPARK_WORKER_CORES='"$numCores"'/' spark-env.sh
scp spark-env.sh cc@node-3:$SPARK_HOME/conf/
echo "End Modifying spark-env.sh"

cd $SPARK_HOME/sbin/
./start-all.sh
cd $EXPERIMENT_HOME

Workerpid=`jps | grep Worker | awk {'print$1'}`
echo "Worker ID is "$Workerpid""

for memoryConfig in ${memoryArray[@]}
do
	echo "Begin Modifying spark-env.sh for $memoryConfig"
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
	for i in {1..10}
	do
		bash $SPARK_BENCH_HOME/Terasort/bin/run.sh
	done

done