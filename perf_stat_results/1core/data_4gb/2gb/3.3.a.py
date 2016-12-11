import numpy as np
import matplotlib.pyplot as plt

statList = ['CPI', 'L1LoadMissRate', 'L1StoreMissRate', 'BranchMissRate', 'dTlbLoadMissRate', 'dTlbStoreMissRate', 'LLC Loads and Stores']
fileList = ['instructions:uk', 'cycles:uk','L1-dcache-loads', 'L1-dcache-load-misses', 'L1-dcache-stores', 'L1-dcache-store-misses' , 'branches:uk', 'branch-misses:uk', 'dTLB-loads', 'dTLB-load-misses', 'dTLB-stores', 'dTLB-store-misses', 'LLC-loads', 'LLC-stores']

toNum = lambda x: float(x.replace(',','').replace('%',''))
matDef = 0

for fIter in range(0,len(fileList)):
	f = open(fileList[fIter]+'.out')
	numList = f.read().split('\n')
	numList = numList[:len(numList)-1]
	print fileList[fIter]
	print numList
	if matDef == 0:
		numArr = np.zeros((len(numList),len(fileList)))
		matDef = 1
	tmpArr = np.array(map(toNum,numList))
	if tmpArr.shape[0] < numArr.shape[0]:
		zeroPadLen = numArr.shape[0] - tmpArr.shape[0]
		zeroPad = np.zeros((zeroPadLen,))
		print zeroPad.shape
		print tmpArr.shape
		tmpArr = np.concatenate((tmpArr,zeroPad))
	numArr[:,fIter] = tmpArr[:numArr.shape[0]]
	#print numArr

numArr[:,10][numArr[:,10] == 0] = 1

print numArr

plt.figure(1)

plt.subplot(221)
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,1]/numArr[:,0])
plt.xlabel('Time')
plt.ylabel('CPI')

plt.subplot(222)
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,3]/numArr[:,2])
plt.xlabel('Time')
plt.ylabel('L1 Load Miss Rate')

plt.subplot(223)
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,5]/numArr[:,4])
plt.xlabel('Time')
plt.ylabel('L1 Store Miss Rate')

plt.subplot(224)
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,7]/numArr[:,6])
plt.xlabel('Time')
plt.ylabel('Branch Miss Rate')

plt.figure(2)

plt.subplot(221)
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,9]/numArr[:,8])
plt.xlabel('Time')
plt.ylabel('dTLB Load Miss Rate')

plt.subplot(222)
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,11]/numArr[:,10])
plt.xlabel('Time')
plt.ylabel('dTLB Store Miss Rate')

plt.subplot(223)
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,12])
plt.plot(np.array(range(0,numArr.shape[0])),numArr[:,13])
plt.xlabel('Time')
plt.ylabel('LLC Load Stores')

plt.show()