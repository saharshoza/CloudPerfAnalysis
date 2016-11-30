perfType=$1
Workerpid=$2
while true;
do
	if [ $perfType = 0 ]
		then perf stat -e cycles:uk,instructions:uk -p $Workerpid sleep 1 &>>cpi.out
	fi
	if [ $perfType = 1 ]
		then perf stat -e branches:uk,branch-misses:uk -p $Workerpid sleep 1 &>>branch.out
	fi
	if [ $perfType = 2 ]
		then perf stat -e L1-dcache-loads:uk,L1-dcache-load-misses:uk -p $Workerpid sleep 1 &>>l1dcache_loads.out
	fi
	if [ $perfType = 3 ]
		then perf stat -e L1-dcache-stores:uk,L1-dcache-store-misses:uk -p $Workerpid sleep 1 &>>l1dcache_stores.out
	fi
	if [ $perfType = 4 ]
		then perf stat -e dTLB-loads:uk,dTLB-load-misses:uk -p $Workerpid sleep 1 &>>dtlb_loads.out
	fi
	if [ $perfType = 5 ]
		then perf stat -e dTLB-stores:uk,dTLB-store-misses:uk -p $Workerpid sleep 1 &>>dtlb_stores.out
	fi
	if [ $perfType = 6 ]
		then perf stat -e LLC-loads:uk,LLC-stores:uk -p $Workerpid sleep 1 &>>llc.out
	fi

done