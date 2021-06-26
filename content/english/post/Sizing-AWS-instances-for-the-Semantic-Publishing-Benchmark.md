---
type: post
title: "Sizing AWS Instances for the Semantic Publishing Benchmark"
author: Iliya Enchev. Venelin Kotsev
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-12-17
tags: [semantic publishing benchmark, amazon, EC2, AWS, rdf]
# please make sure to remove image parameter if unused
# image: "post/sizing-aws-instances-for-the-semantic-publishing-benchmark/featured.png" 
---


LDBC's [Semantic Publishing Benchmark](http://ldbcouncil.org/developer/spb) (SPB) measures the performance of an RDF database in a load
typical for metadata-based content publishing, such as the famous
[BBC Dynamic Semantic Publishing](http://www.bbc.co.uk/blogs/legacy/bbcinternet/2010/07/bbc_world_cup_2010_dynamic_sem.html) scenario. Such load combines tens of
updates per second (e.g. adding metadata about new articles) with even
higher volume of read requests (SPARQL queries collecting recent content
and data to generate web page on a specific subject, e.g. Frank
Lampard). As we
http://ldbcouncil.org/blog/using-ldbc-spb-find-owlim-performance-issues[wrote
earlier], SPB was already successfully used to help developers to
identify performance issues and to introduce optimizations in SPARQL
engines such as GraphDB and Virtuoso. Now we are at the point to
experiment with different sizes of the benchmark and different hardware
configurations.

Lately we tested different Amazon Web Services
[AWS](http://aws.amazon.com/)) instance types for running SPB basic
interactive query mix in parallel with the standard editorial updates –
precisely the type of workload that
[GraphDB](ttp://www.ontotext.com/products/ontotext-graphdb/) experiences
in the backend of BBC Sport website. We discovered and report below a
number of practical guidelines about the optimal instance types and
configurations. We have proven that SPB 50M workloads can be executed
efficiently on a mid-sized AWS instance – c3.2xlarge machine executes 16
read queries and 15 update operations per second. For $1 paid to Amazon
for such instance GraphDB executes 140 000 queries and 120 000 updates.
The most interesting discovery in this experiment is that if BBC were
hosting the triplestore behind their Dynamic Semantic Publishing
architecture at AWS, the total cost of the server infrastructure behind
their Worldcup 2010 website would have been about $80/day.

### The Experiment

For our tests we use:

* GraphDB Standard v 6.1
* LDBC-SPB test driver (version 0.1.dc9a626 from 10.Nov.2014) configured
as follows:
** 8 aggregation agents (read threads) and 2 editorial agents (write
threads); for some configurations we experimented with different numbers
of agents also
** 50M dataset (SF1)
** 40 minutes of benchmark run time (60 seconds of warm up)
* 5 different Amazon EC2 instances and one local server

Each test run is cold, i.e. data is newly loaded for each run. We set a
5 GByte cache configuration, which is sufficient for the size of the
generated dataset. We use the same query substitution parameters (the
same randomization seed) for every run, so that we are sure that all
test runs are identical.

We use two types of instances – M3 and C3 instances. They both provide
SSD storage for fast I/O performance. The M3 instances are with
E5-2670v2, 2.50GHz CPU and provide good all-round performance, while the
C3 instances are compute optimized with stronger CPU – E5-2680v2,
2.80GHz, but have half as much memory as the M3.

We also use a local physical server with dual-CPU – E5-2650v2, 2.60Ghz;
256GB of RAM and RAID-0 array of SSD in order to provide ground for
interpretation of the performance for the virtualized AWS instances. The
CPU capacity of the AWS instances is measured in vCPUs (virtual CPU). A
vCPU is a logical core – one hyper-thread of one physical core of the
corresponding Intel Xeon processor used by Amazon. This means that a
vCPU represents roughly half a physical core, even though the
performance of a hyper-threaded core is not directly comparable with two
non-hyper-threaded cores. We should keep this in mind comparing AWS
instances to physical machines, i.e. our local server with two CPUs with
8 physical cores each has 32 logical cores, which is more than
c3.4xlarge instance with 16 vCPUs.

### The Results

For the tests we measured:

* *queries/s* for the read threads, where queries include SELECT and
CONSTRUCT
* *updates/s* for the write threads, where an update operation is INSERT
or DELETE
* *queries/$* and *updates/$* – respectively queries or updates per
dollar is calculated for each AWS instance type based on price and
update throughput
* *update/vCPU* – modification operations per vCPU per second

Results (Table 1.) provide strong evidence that performance depends mostly on
processor power. This applies to both queries and updates - which in the
current AWS setup go on par with one another. Comparing M3 and C3
instances with equal vCPUs we can see that performance is only slightly
higher for the M3 machines and even lower for selects with 8 vCPUs.
Taking into account the lower price of C3 because of their lower memory,
it is clear that C3 machines are better suited for this type of workload
and the sweet spot between price and performance is c3.2xlarge machine.

The improvement in performance between the c3.xlarge and c3.2xlarge is
more than twofold where the improvement between c3.2xlarge and
c3.4xlarge is considerably lower. We also observe slower growth between
c3.4xlarge and the local server machine. This is an indication that for
SPB at this scale the difference between 7.5GB and 15GB of RAM is
substantial, but RAM above this amount cannot be utilized efficiently by
GraphDB.

Table 1. SPB Measurement Results on AWS and Local Servers

| Server Type | vCPUs | R/W Agents | RAM (GB) | "Storage (GB, SSD)" | Price USD/h | Queries/ sec. | Updates/ sec. | Queries/ USD | Updates/ USD | Updates/ vCPU | 
|-------------|-------|------------|----------|---------------------|-------------|---------------|---------------|--------------|--------------|---------------| 
| m3.xlarge   | 4     | 8/2        | 15       | 2x 40               | 0.28        | 8.39          | 8.23          | 107 882      | 105 873      | 2.06          | 
| m3.2xlarge  | 8     | 8/2        | 30       | 2x 80               | 0.56        | 15.44         | 15.67         | 99 282       | 100 752      | 1.96          | 
| c3.xlarge   | 4     | 8/2        | 7.5      | 2x 40               | 0.21        | 7.17          | 6.78          | 122 890      | 116 292      | 1.7           | 
| **c3.2xlarge**  | **8**    | **8/2**        |**15**       | **2x 80**               | **0.42**        | **16.46**         | **14.56**         | **141 107**      | **124 839**      | **1.82**          | 
| **c3.4xlarge**  | **16**    | **8/2**        | **30**       | **2x 160**              | **0.84**        | **23.23**         | **21.17**         | **99 578**       | **90 736**       | **1.32**          | 
| c3.4xlarge  | 16    | 8/3        | 30       | 2x 160              | 0.84        | 22.89         | 20.39         | 98 100       | 87 386       | 1.27          | 
| c3.4xlarge  | 16    | 10/2       | 30       | 2x 160              | 0.84        | 26.6          | 19.11         | 114 000      | 81 900       | 1.19          | 
| c3.4xlarge  | 16    | 10/3       | 30       | 2x 160              | 0.84        | 26.19         | 19.18         | 112 243      | 82 200       | 1.2           | 
| **c3.4xlarge**  | **16**    | **14/2**       | **30**       | **2x 160**              | **0.84**        | **30.84**         | **16.88**         | **132 171**      | **72 343**       | **1.06**          | 
| c3.4xlarge  | 16    | 14/3       | 30       | 2x 160              | 0.84        | 29.67         | 17.8          | 127 157      | 76 286       | 1.11          | 
| Local       | 32    | 8/2        | 256      | 8x 256              | 0.85        | 37.11         | 32.04         | 156 712      | 135 302      | 1             | 
| Local       | 32    | 8/3        | 256      | 8x 256              | 0.85        | 37.31         | 32.07         | 157 557      | 135 429      | 1             | 
| **Local**       | **32**    | **10/2**       | **256**      | **8x 256**              | **0.85**        | **40**            | **31.01**         | **168 916**      | **130 952**      | **0.97**          | 
| Local       | 32    | 14/2       | 256      | 8x 256              | 0.85        | 36.39         | 26.42         | 153 672      | 111 569      | 0.83          | 
| Local       | 32    | 14/3       | 256      | 8x 256              | 0.85        | 36.22         | 26.39         | 152 954      | 111 443      | 0.82          | 
| Local       | 32    | 20/2       | 256      | 8x 256              | 0.85        | 34.59         | 23.86         | 146 070      | 100 759      | 0.75          | 
### The Optimal Number of Test Agents

Experimenting with different number of aggregation (read) and editorial
(write) agents at c3.4xlarge and the local server, we made some
interesting observations:

* There is almost no benefit to use more than 2 write agents. This can
be explained by the fact that certain aspects of handling writes in
GraphDB are serialized, i.e. they cannot be executed in parallel across
multiple write threads;
* Using more read agents can have negative impact on update performance.
This is proven by the c3.4xlarge results with 8/2 and with 14/2 agents -
while in the later case GraphDB handles a bit higher amount of queries
(31 vs. 23) we see a drop in the updates rates (from 21 to 17);
* Overall, the configuration with 8 read agents and 2 write agents
delivers good balanced results across various hardware configurations;
* For machines with more than 16 cores, a configuration like 10/2 or
14/2, would maximize the number of selects, still with good update
rates. This way one can get 30 queries/sec. on c3.4xlarge and 40
queries/sec. on a local server;
* Launching more than 14 read agents does not help even on local server
with 32 logical cores. This indicates that at this point we are reaching
some constraints such as memory bandwidth or IO throughput and degree of
parallelization.
* There is some overhead when handling bigger number of agents as the
results for the local server tests with 14/3 and 20/2 show the worst
results for both queries and updates.

### Efficiency and Cost

AWS instance type c3.2xlarge provides the best price/performance ratio
for applications where 15 updates/sec. are sufficient even at peak
times. More intensive applications should use type c3.4xlarge, which
guarantees more than 20 updates/sec.

Cloud infrastructure providers like Amazon, allow one to have a very
clear account of the full cost for the server infrastructure, including
hardware, hosting, electricity, network, etc.

$1 spent on c3.2xlarge ($0.41/hour) allows for handling 140 000 queries,
along with more than 120 000 update operations!

The full cost of the server infrastructure is harder to compute in the
case of purchasing a server and hosting it in a proprietary data center.
Still, one can estimate the upper limits - for machine, like the local
server used in this benchmark, this price is way lower than $1/hour. One
should consider that this machine is with 256GB of RAM, which is an
overkill for Semantic Publishing Benchmark ran at 50M scale. Under all
these assumptions we see that using local server is cheaper than the
most cost-efficient AWS instance. This is expected - owning a car is
always cheaper than renting it for 3 years in a row. Actually, the fact
that the difference of the prices/query in this case are low indicates
that using AWS services comes at very low extra cost.

To put these figures in the context of a known real world application,
let us model the case of a GraphDB Enterprise replication cluster with 2
master nodes and 6 worker nodes - the size of cluster that BBC used for
their FIFA Worldcup 2010 project. Given c3.2xlarge instance type, the
math works as follows:

* **100 queries/sec.** handled by the cluster. This means about 360 000
queries per hour or more than 4 million queries per day. This is at
least 2 times more than the actual loads of GraphDB at BBC during the
peak times of big sports events.
* **10 updates/sec.** - the speed of updates in GraphDB Enterprise
cluster is lower than the speed of each worker node in separation. There
are relatively few content management applications that need more than
36 000 updates per hour.
* **$81/day** is the full cost for the server infrastructure. This
indicates an annual operational cost for cluster of this type in the
range of $30 000, even without any effort to release some of the worker
nodes in non-peak times.
