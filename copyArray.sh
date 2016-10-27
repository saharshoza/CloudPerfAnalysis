# Script to copy data from 1 hadoop cluster to another
# Inputs: FileName, senderNode, receiverNode
fileLoc=$1
senderMaster=$2
recvMaster=$3
currPath=`pwd`
cd $HADOOP_HOME/bin
echo $currPath
hadoop fs -copyToLocal $fileLoc /tmp/
scp cc@$senderMaster:/tmp/$fileLoc cc@$recvMaster:/tmp
ssh -l cc $recvMaster cd $HADOOP_HOME/bin; hadoop fs -copyFromLocal /tmp/$fileLoc /
cd $currPath
