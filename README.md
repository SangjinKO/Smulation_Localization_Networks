# Smulation_Localization_Networks

# Information
Implement 2D simulation of a node based localization with mobile devices under ad-hoc networks consisting of only mobile devices. 
  
Matlab is used to simulate randomly distributed nodes having specific ranges of signal transmission, to calculate distances and positions and to localize nodes.   

There are assumptions as below 
- Fixed nodes are randomly distributed in a square room 
- An ad-hoc network can create a matrix of RSS (Received Signal Strength) of nodes 
- There is no pre-installed equipment such as access points or beacons
- At least 3 nodes in an ad-hoc network can receive GPS signals and they have overlapped area of transmit ranges 

# Instruction

Environment Instalation: Install Matlab 2017.1 from downloads.it.mtu.edu (other versions should also work)

Code Execution:	Open code file in matlab

Enter Parameters:
- pointct: Range of number of nodes to simulate
- senselen: The range that a node can transmit and be received.In an ideal situation, perfect localization inside of senselen, no localization outside of senselen
- runs: number of times to run the experiment. Results are averaged among all runs
	(only in experiment 2) knowns: Number of known nodes with it as a value of 3, 6, 9, or 12
	(only in experiment 3) noisestd: Set to indicate value of error located in function mobiletest

Execution of code:Press the green "Play" icon in matlab, wait for completion

Viewing results: On the right hand side of the screen is the variable window which contains the variable results. Double clicking on the result variable will open the data in the variable. This data can then be correlated to the senselen and pointct input ranges. Data can be graphed in external programs such as Microsoft excel. Experiment 2 has additional code that will automatically generate graphs

Reference: Matlab array format:  initial:step:max

![Image of Result](https://github.com/SangjinKO/Smulation_Localization_Networks/images/Figure1.png)
![Image of Result](https://github.com/SangjinKO/Smulation_Localization_Networks/images/Figure2.png)
![Alt text](/images/Figure1.png)
