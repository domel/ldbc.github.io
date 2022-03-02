---
type: post
title: "The Day of Graph Analytics"
author: Orri Erling
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-10-09
tags: [analytics, snb]
# please make sure to remove image parameter if unused
# image: "post/the-day-of-graph-analytics/featured.png" 
---

_Note: consider this post as a continuation of the
"[Making it interactive](/post/making-it-interactive)" post by Orri Erling._ 
 
I have now completed
the [Virtuoso](https://github.com/openlink/virtuoso-opensource) TPC-H work,
including scale out.  Optimization possibilities extend to infinity but
the present level is good enough. [TPC-H](http://www.tpc.org/tpch/) is the
classic of all analytics benchmarks and is difficult enough, I have
extensive commentary on this on my blog (In Hoc Signo Vinces series),
including experimental results.  This is, as it were, the cornerstone of
the true science.  This is however not the totality of
it.  From the LDBC angle, we might liken this to the last camp before
attempting a mountain peak. 
 
So, we may now seriously turn to graph analytics. The project has enough
left to run in order to get a good BI and graph analytics workload.  In
LDBC in general, as in the following, BI or business intelligence means
complex analytical queries.  Graph analytics means graph algorithms that
are typically done in graph programming frameworks or libraries. 
 
The BI part is like TPC-H, except for adding the following challenges:

* Joins of derived tables with group by,  e.g. comparing popularity of
items on consecutive time periods.

* Transitive dimensions - A geographical or tag hierarchy can be seen as
a dimension table.  To get the star schema plan with the selective hash
join, the count of the transitive traversal of the hierarchy (hash build
side) must be correctly guessed.

* Transitivity in fact table, i.e. average length of reply thread. 
There the cost model must figure that the reply link is much too high
cardinality for hash build side, besides a transitive operation is not a
good candidate for a build in multiple passes, hence the plan will have
to be by index.

* Graph traversal with condition on end point and navigation step.  The
hierarchical dimensions and reply threads are in fact trees, the social
graph is not.  Again  the system must know some properties of
connectedness (in/out degree, count of vertices) to guess a traversal
fanout.  This dictates the join type in the step (hash or index).  An
example is a transitive closure with steps satisfying a condition, e.g.
all connected persons have a specific clearance.

* Running one query with parameters from different buckets, implying
different best plan.

* Data correlations, e.g. high selectivity arising from two interests
seldom occurring together, in places where the correct estimation makes
the difference between a good and a bad plan.

* Large intermediate results stored in tables, as in materializing
complex summaries of data for use in follow up queries.

* More unions and outer joins.

 
 
The idea is to cover the base competences the world has come to expect
and to build in challenges to last another 10-15 years. 
 
For rules and metric, we can use the TPC-H or
[TPC-DS](http://www.tpc.org/tpcds/default.asp) ones as a template.  The
schema may differ from an implementation of the interactive workload, as
these things would normally run on different systems anyway. 
 
As another activity that is not directly LDBC, I will do a merge of SNB
and [Open Street Map](http://www.openstreetmap.org/).  The geolocated
things (persons, posts) will get real coordinates from their  vicinity
and diverse geo analytics will become possible. This is of some
significant interest to Geoknow, another FP7 where OpenLink is
participating. 

Doing the BI mix and even optimizing the interactive part involves some
redoing of the present support for transitivity in Virtuoso.  The
partitioned group by with some custom aggregates is the right tool for
the job, with all parallelization, scale-out, etc ready.  You see, TPC-H
is very useful also in places one does not immediately associate with
it. 
 
As a matter of fact, this becomes a BSP (bulk synchronous processing)
control structure.  Run any number of steps, each item produces
results/effects scattered across partitions.  The output of the previous
is the input of the next.  We might say BSP is an attractor or
"Platonic" control structure to which certain paths inevitably lead.
Last year I did a BSP implementation in SQL, reading and writing tables
and using transactions for serializable update of the border. This is
possible but will not compete with a memory based framework and not
enough of the optimization potential, e.g. message combining, is visible
to the engine in this formulation.  So, now we will get this right, as
suggested.

So, the transitive derived table construct can have pluggable
aggregations, e.g. remembering a path, a minimum length or such),
reduction like a scalar-valued aggregate (min/max), different grouping
sets like in a group by with cube or grouping sets, some group-by like
reduction for message combining and so forth.  If there is a gather
phase that is not just the result of the scatter of the previous step,
this can be expressed as an arbitrary database query, also cross 
partition in a scale-out setting.

 
The distributed/partitioned group by hash table will be a first class
citizen, like a procedure scoped temporary table to facilitate returning
multiple results and passing large data between multiple steps with
different vertex operations, e.g. forward and backward in betweenness
centrality.   
 
 
This brings us to the graph analytics proper, which is often done in BSP
style, e.g.
[Pregel](http://es.slideshare.net/shatteredNirvana/pregel-a-system-for-largescale-graph-processing),
[Giraph](http://giraph.apache.org),
[Signal-Collect](http://uzh.github.io/signal-collect/), some but not all
[Green-Marl](http://ppl.stanford.edu/main/green_marl.html) applications. 
In fact, a Green-Marl back end for Virtuoso is conceivable, whether one
will be made is a different matter. 
 
With BSP in the database engine, a reference implementation of many
standard algorithms is readily feasible and performant enough to do
reasonable sizing for the workload and to have a metric.  This could be
edges or vertices per unit of time, across a mix of algorithms, for
example.  Some experimentation will be needed.  The algorithms
themselves may be had from the Green-Marl sample programs or other
implementations.  Among others, Oracle would presumably agree that this
sort of functionality will in time migrate into core database. We will
here have a go at this and along the way formulate some benchmark tasks
for a graph analytics workload.  Whenever feasible, this will derive
from existing work such as [graphbench.org](http://graphbench.org/) but
will be adapted to the SNB dataset. 
 
The analytics part will be done with more community outreach than the
interactive one.  I will blog about the business questions, queries and
choke points as we go through them.  The interested may pitch in as the
matter comes up.
