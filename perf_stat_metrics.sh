perfMetricArray=(0 1 2 3 4)
Workerpid=`jps | grep Worker | awk {'print$1'}`

for perfMetric in ${perfMetricArray[@]}
do
	(
		bash perf_stat_sub.sh $perfMetric $Workerpid
	)&
	perf_process=`ps aux | grep perf_stat_sub | awk {'print$2'} | head -1`
	bash $SPARK_BENCH_HOME/Terasort/bin/run.sh
	kill $perf_process
done