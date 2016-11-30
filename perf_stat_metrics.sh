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

grepList=(instructions:uk cycles:uk branches:uk branch-misses:uk L1-dcache-load-misses L1-dcache-loads L1-dcache-stores L1-dcache-store-misses dTLB-loads dTLB-load-misses dTLB-stores dTLB-store-misses LLC-loads LLC-stores)
fileList=(cpi.out cpi.out branch.out branch.out l1dcache_loads.out l1dcache_loads.out l1dcache_stores.out l1dcache_stores.out dtlb_loads.out dtlb_loads.out llc.out llc.out)
lenList=${#fileList[@]}
for i in {1..12}
do
	echo ${grepList[i]}
	grep -i ${grepList[i]} ${fileList[i]} | awk '{print $1}' > ${grepList[i]}.out
done