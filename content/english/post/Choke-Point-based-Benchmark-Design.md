---
type: post
title: "Choke Point Based Benchmark Design"
author: Peter Boncz
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-10-14
tags: [database, benchmark, design]
# please make sure to remove image parameter if unused
# image: "post/choke-point-based-benchmark-design/featured.png" 
---


The *Linked Data Benchmark Council* (LDBC) mission is to design and
maintain benchmarks for graph data management systems, and establish and
enforce standards in running these benchmarks, and publish and arbitrate
around the official benchmark results. The council and its
https://ldbcouncil.org website just launched, and in its
first 1.5 year of existence, most effort at LDBC has gone into
investigating the needs of the field through interaction with the LDBC
Technical User Community
([next TUC meeting](/event/fifth-tuc-meeting) will be on October 5 in Athens) and indeed in *designing
benchmarks*.

So, what makes a good benchmark design? Many talented people have paved
our way in addressing this question and for relational database systems
specifically the benchmarks produced by [TPC](http://www.tpc.org/) have
been very helpful in maturing relational database technology, and making
it successful. Good benchmarks
are _relevant_ and _representative _(address important challenges
encountered in practice), _understandable_ , _economical_ (implementable
on simple hardware), _fair_ (such as not to favor a particular product
or approach), __scalable, accepted __by the
community  and _public _(e.g. all of its software is available in open
source). This list stems from Jim
Gray's [Benchmark Handbook](http://research.microsoft.com/en-us/um/people/gray/BenchmarkHandbook/TOC.htm). In this blogpost, I will share some thoughts on each of these aspects of good benchmark design.

A very important aspect of benchmark development is making sure that the
community *accepts* a certain benchmark, and starts using it. A
benchmark without published results and therefore opportunity to compare
results, remains irrelevant. A European FP7 project is a good place to
start gathering a critical mass of support (and consensus, in the
process) for a new benchmark from the core group of benchmark designers
in the joint work performed by the consortium. Since in LDBC multiple
commercial graph and RDF vendors are on the table (Neo Technologies,
Openlink, Ontotext and Sparsity) a minimal consensus on **fairness **had
to be established immediately. The Linked Data Benchmark Council itself
is a noncommercial, neutral, entity which releases all its benchmark
specifications, software, as well as many materials created during the
design, to the **public **in open source (GPL3).  LDBC has spent a lot
of time engaging interested parties (mainly through
its [Technical User Community gatherings](http://ldbcouncil.org/tags/tuc-meeting/)) as well as lining up additional organizations as
members of the Linked Data Benchmark Council. There is, in other words,
a strong non-technical, human factor in getting benchmarks accepted.

The need for *understandability* for me means that a database benchmark
should consist of a limited number of queries and result metrics. Hence
I find TPC-H with its 22 queries more understandable than TPC-DS with
its 99, because after (quite some) study and experience it is possible
to understand the underlying challnges of all queries in TPC-H. It may
also be possible for TPC-DS but the amount of effort is just much
larger. Understandable also means for me that a particular query should
behave similarly, regardless of the query parameters. Often, a
particular query needs to be executed many times, and in order not to
play into the hands of simple query caching and also enlarge the access
footprint of the workload, different query parameters should be used.
However, parameters can strongly change the nature of a query but this
is not desirable for the understandability of the workload. For
instance, we know that TPC-H Q01 tests raw computation power, as its
selection predicate eliminates almost nothing from the main fact table
(LINEITEM), that it scans and aggregates into a small 4-tuple result.
Using a selection parameter that would select only 0.1% of the data
instead, would seriously change the nature of Q01, e.g. making it
amendable to indexing. This stability of parameter bindings is an
interesting challenge for the [Social Network Benchmark](benchmarks/snb) (SNB) of LDBC which is not as uniform and
uncorrelated as TPC-H. Addressing the challenge of obtaining parameter
bindings that have similar execution characteristics will be the topic
of a future blog post.

The *economical* aspect of benchmarking means that while rewarding
high-end benchmark runs with higher scores, it is valuable if a
meaningful run can also be done with small hardware. For this reason, it
is good practice to use a performance-per-EURO (or $) metric, so small
installations despite a lower absolute score can still do well on that
metric. The economical aspect is right now hurting the (still) leading
relational OLTP benchmark TPC-C. Its implementation rules are such that
for higher reported rates of throughput, a higher number of warehouses
(i.e. larger data size) is needed. In the current day and age of
JIT-compiled machinecode SQL procedures and CPU-cache optimized main
memory databases, the OLTP throughput numbers now obtainable on modern
transactional systems like Hyper on even a single server (it reaches
more than 100.000 transactions per second) are so high that they lead to
petabyte storage requirements. Not only does this make TPC-C very
expensive to run, just by the sheer amount of hardware needed according
to the rules, but it also undermines it representativity, since OLTP
data sizes encountered in the field are much smaller than OLAP data
sizes and do not run in the petabytes.

*Representative* benchmarks can be designed by studying or even directly
using real workload information, e.g. query logs. A rigorous example of
this is the [DBpedia benchmark](http://aksw.org/Projects/DBPSB.html) whose
workload is based on the query logs of dbpedia.org. However, this SPARQL
endpoint is a single public Virtuoso instance that has been configured
to interrupt all long running queries, such as to ensure the service
remains responsive to as many users as possible. As a result, it is only
practical to run small lookup queries on this database service, so the
query log only contained solely such light queries. As a consequence,
the DBpedia benchmark only tests small SPARQL queries that stress simple
B-tree lookups only (and not joins, aggregations, path expressions or
inference) and poses almost no technical challenges for either query
optimization or execution. The lesson, thus, is to balance
representativity with relevance (see later..).

The fact that a benchmark can be *scaled* in size favors the use of
synthetic data (i.e. created by a data generator) because data
generators can produce any desired quantity of data. I hereby note that
in this day and age,  data generators should be parallel.
Single-threaded single-machine data generation just becomes unbearable
even at terabyte scales. A criticism of synthetic data is that it may
not be representative of real data, which e.g. tends to contain highly
correlated data with skewed distributions. This may be addressed to a
certain extent by injecting specific skew and correlations into
synthetic data as well (but: which skew and which correlations?). An
alternative is to use real data and somehow blow up or contract the
data. This is the approach in the mentioned DBpedia benchmark, though
such scaling will distort the original distributions and correlations.
Scaling a benchmark is very useful to investigate the effect of data
size on the metric, on individual queries, or even in micro-benchmark
tests that are not part of the official query set. Typically OLTP
database benchmarks have queries whose complexity is O(log(N)) of the
data size N, whereas OLAP benchmarks have queries which are linear, O(N)
or at most O(N.log(N))  -- otherwise executing the benchmark on large
instances is infeasible. OLTP queries thus typically touch little data,
in the order of log(N) tuples. In order not to measure fully cold query
performance, OLTP benchmarks for that reason need a warmup phase with
O(N/log(N)) queries in order to get the system into a representative
state.

Now, what makes a benchmark *relevant*? In LDBC we think that benchmarks
should be designed such that crucial areas of functionality are
highlighted, and in turn system architects are stimulated to innovate.
Either to catch up with competitors and bring the performance and
functionality in line with the state-of-the-art but even to innovate and
address technical challenges for which until now no good solutions
exist, but which can give a decisive performance advantage in the
benchmark. Inversely stated, benchmark design can thus be a powerful
tool to influence the industry, as a benchmark design may set the
agendas for multiple commercial design teams and database architects
around the globe. To structure this design process, LDBC introduces the
notion of *"choke points"*: by which we mean problems that challenge
current technology. These choke points are collected and described early
in the LDBC design process, and the workloads developed later are scored
in terms of their coverage of relevant choke points. In case of graph
data querying, one of the choke points that is unique to the area is
recursive Top-N query handling (e.g. shortest path queries). Another
choke point that arises is the impact of correlations between attribute
value of graph nodes (e.g. both employed by TUM) and the connectivity
degree between nodes (the probability to be friends). The notion
observed in practice is that people who are direct colleagues, often are
in each others friend network. A query that selects people in a social
graph that work for the same company, and then does a friendship
traversal, may get a bad intermediate result size estimates and
therefore suboptimal query plan, if optimizers remain unaware of
value/structure correlations. So this is an area of functionality that
the Social Network Benchmark (SNB) by LDBC will test.

To illustrate what choke points are in more depth, we wrote
a [paper in the TPCTC](http://oai.cwi.nl/oai/asset/21424/21424B.pdf) 2013
conference that performs a post-mortem analysis of TPC-H and identified
28 such choke points.
*[This table](chokepoints.png)* lists them all, grouped into six Choke Point (CP) areas (CP1
Agregation, CP2 Join, CP3 Locality, CP4 Calculations, CP5 Subqueries and
CP6 Parallelism). The classification also shows CP coverage over each of
the 22 TPC-H queries (black is high impact, white is no impact):

I would recommend reading this paper to anyone who is interested in
improving the TPC-H score of a relational database system, since this
paper contains the collected experience of three database architects who
have worked with TPC-H at length: Orri Erling (of Virtuoso), Thomas
Neumann (Hyper,RDF-3X), and me (MonetDB,Vectorwise).  Recently Orri
Erling showed that this paper is not complete as he discovered one more
choke-point area for TPC-H:  Top-N pushdown. In a detailed blog entry,
Orri shows how this technique
can [trivialize Q18](http://www.openlinksw.com/weblog/oerling/?id=1779);
and this optimization can single handedly improve the overall TPC-score
by 10-15%. This is also a lesson for LDBC: even though we design
benchmarks with choke points in mind, the queries themselves may bring
to light unforeseen opportunities and choke-points that may give rise to
yet unknown innovations. 

LDBC has just published two benchmarks as Public Drafts, which
essentially means that you are cordially invited to download and try out
the RDF-focused Semantic Publishing Benchmark
([SPB) ](http://ldbcouncil.org/developer/spb)and the more graph-focused
Social Network Benchmark ([SNB](http://ldbcouncil.org/developer/snb)), 
and [tell us what you think](https://groups.google.com/forum/#!forum/ldbcouncil). Stay tuned for the coming detailed blog posts about these
benchmarks, which will explain the graph and RDF processing choke-points
that they test.

_(for more posts from Peter Boncz, see
also [Database Architects](http://databasearchitects.blogspot.com), a blog
about data management challenges and techniques written by people who
design and implement database systems)_
