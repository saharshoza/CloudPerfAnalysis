# Master and Local IP
MASTERIP=10.40.0.230
LOCALIP=10.40.0.230

source ~/.bashrc

sudo apt-get update

# Install hadoop
wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
tar xvf hadoop-2.7.2.tar.gz  
sudo mv hadoop-2.7.2/ /usr/local/hadoop

# Install Spark
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.6.tgz
tar xvf spark-1.6.0-bin-hadoop2.6.tgz
sudo mv spark-1.6.0-bin-hadoop2.6/ /usr/local/spark

# Install Scala
apt-get remove scala-library scala
wget www.scala-lang.org/files/archive/scala-2.10.4.deb
sudo dpkg -i scala-2.11.5.deb
sudo apt-get update
sudo apt-get install scala

# SBT?
wget http://apt.typesafe.com/repo-deb-build-0002.deb 
sudo dpkg -i repo-deb-build-0002.deb 
sudo apt-get update 
sudo apt-get install sbt 

# Install OpenJDK
sudo apt-get install default-jre
sudo apt-get install default-jdk

# Install KVM+QEMU
apt-get install qemu-kvm libvirt-bin bridge-utils virt-manager
adduser cc libvirtd

#sudo wget http://releases.ubuntu.com/14.04/ubuntu-14.04.5-server-amd64.iso

# Get Spark Bench
sudo apt-get install git
git clone https://github.com/SparkTC/spark-bench.git

# Spark Bench dependencies
git clone https://github.com/synhershko/wikixmlj.git
cd wikixmlj
sudo apt install maven
mvn package install

# Configure Hadoop
# Edit core-site.xml
cd $HADOOP_HOME/etc/hadoop
python /home/cc/edit_files.py core-site.xml $MASTERIP
python /home/cc/edit_files.py hdfs-site.xml
echo 'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre' >> hadoop-env.sh

# Uncomment if this is master node
# echo <FIXED IP> >> slaves

# Configure Spark
cd $SPARK_HOME/conf/
cp spark-env.sh.template spark-env.sh
echo "export SPARK_MASTER_IP=$MASTERIP" >> spark-env.sh
echo "export SPARK_LOCAL_IP=$LOCALIP" >> spark-env.sh
cp spark-defaults.conf.template spark-defaults.conf
echo 'spark.eventLog.enabled           true' >> spark-defaults.conf
echo 'spark.history.fs.logDirectory    /tmp/spark-events' >> spark-defaults.conf
echo 'spark.shuffle.compress           false' >> spark-defaults.conf

# Setup ssh
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Make Spark Bench

# Public ssh key via local
