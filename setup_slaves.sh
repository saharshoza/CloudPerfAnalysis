FIXEDIP="129.114.108.142 129.114.108.181 129.114.108.186 129.114.108.238" #Use fixed ip not floating
InstanceName="node-4 node-3 node-2 node-1"

fixed_ip_list=($FIXEDIP)
idx=0

for ip_iter in $InstanceName
do
	echo -e "${fixed_ip_list[$idx]}" >> $SPARK_HOME/conf/slaves
	echo -e "\n" >> $SPARK_HOME/conf/slaves
	sudo echo "${fixed_ip_list[$idx]} $ip_iter" >> /etc/hosts
	sudo echo -e "\n" >> /etc/hosts
	idx=$[idx+1]
done

# Goto SPARK_BENCH_HOME/pom.xml and change maven source and target to 1.7
sh $SPARK_BENCH_HOME/bin/build-all.sh
cp $SPARK_BENCH_HOME/conf/env.sh.template $SPARK_BENCH_HOME/conf/env.sh