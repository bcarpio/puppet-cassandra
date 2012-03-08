# Cassandra #

This module was created to assist with the installation and configuration of a cassandra cluster. Simply edit the params.pp

# Configuration #

* A tar.gz file needs to be placed into ~/modules/cassandra/files. 
* Once downloaded the params.pp file needs to be updated with the version downloaded. 
* The params.pp also requires the java module I have already published. That or the $java_home variable needs to be properly updated.
* The hostnames of the nodes in the cluster need to be defined in params.pp, by default this module creates a 4 node cluster. 
* If you change the number of nodes from 4 you need to run the following python script:

<code>
# Number of nodes in the cluster
num_node = 4

for n in range(num_node):
	    print int(2**127 / num_node * n)
</code>

# Author #

* Brian Carpio
* http://www.thetek.net
* http://www.linkedin.com/in/briancarpio
