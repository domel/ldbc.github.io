---
type: post
title: "SNB Interactive Part 1: What Is SNB Interactive Really About?"
author: Orri Erling
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2015-05-14
tags: [snb, virtuoso, interactive]
# please make sure to remove image parameter if unused
# image: "post/snb-interactive-part-1-what-is-snb-interactive-really-about/featured.png" 
---

This post is the first in a series of blogs analyzing the LDBC Social
Network Benchmark Interactive workload. This is written from the dual
perspective of participating in the benchmark design and of building the
OpenLink Virtuoso implementation of same.    

With two implementations of SNB interactive at four different scales, we
can take a first look at what the benchmark is really about.  The
hallmark of a benchmark implementation is that its
performance characteristics are understood and even if these do not
represent the maximum of the attainable, there are no glaring mistakes
and the implementation represents a reasonable best effort by those who
ought to know, namely the system vendors.

The essence of a benchmark is a set of trick questions or choke points,
as LDBC calls them.  A number of these were planned from the start.  It
is then the role of experience to tell whether addressing these is
really the key to winning the race.  Unforeseen ones will also surface.

So far, we see that SNB confronts the implementor with choices in the
following areas:

* Data model:  Relational, RF, property graph? 
* Physical model, e.g. row-wise vs. column wise storage 
* Materialized data ordering:  Sorted projections, composite keys,
replicating columns in auxxiliary data structures 
* Maintaining precomputed, materialized intermediate results, e.g. use
of materialized views, triggers 
* Query optimization:  join order/type, interesting physical data
orderings, late projection, top k, etc.
* Parameters vs. literals:  Sometimes different parameter values  result
in different optimal query plans
* Predictable, uniform latency:  The measurement rules stipulate the the
SUT must not fall behind the simulated workload 
* Durability - how to make data durable while maintaining steady
throughput?  Logging vs. checkpointing.

In the process of making a benchmark implementation, one
naturally encounters questions about the validity, reasonability and
rationale of the benchmark definition itself.  Additionally, even though
the benchmark might not directly measure certain aspects of a system,
making an implementation will take a system past its usual envelope and
highlight some operational aspects.

* Data generation - Generating a mid-size dataset takes time, e.g. 8
hours for 300G.  In a cloud situation, keeping the dataset in S3 or
similar is necessary, re-generating every time is not an option.
* Query mix - Are the relative frequencies of the operations reasonable?
 What bias does this introduce?
* Uniformity of parameters:  Due to non-uniform data distributions in
the dataset, there is easily a 100x difference between a 'fast' and
'slow' case of a single query template.  How long does one need to run
to balance these fluctuations?
* Working set:  Experience shows that there is a large difference
between almost warm and steady state of working set. This can be a
factor of 1.5 in throughput.  
* Are the latency constraints reasonable?  In the present case, a
qualifying run must have  under 5% of all query executions starting over
1 second late.  Each execution is scheduled beforehand and done at the
intended time.   If the SUT does not keep up, it will have all available
threads busy and must finish some work before accepting new work, so
some queries will start late.  Is this a good criterion for measuring
consistency of response time?  There are some obvious possibilities of
abuse.
* Is the benchmark easy to implement/run?  Perfection is open-ended and
optimization possibilities infinite, albeit with diminishing returns.
 Still, getting startyed should not be too hard.  Since systems will be
highly diverse, testing that these in fact do the same thing is
important.  The SNB validation suite is good for this and given
 publicly available reference implementations, the effort of getting
started is not unreasonable.
* Since a Qualifying run must meet latency constraints while going as
fast as possible, setting the performance target involves trial and
error.  Does the tooling make this easy?  
* Is the durability rule reasonable?  Right now, one is not required to
do checkpoints but must report the time to roll forward from the last
checkpoint or initial state.  Incenting vendors to build faster recovery
is certainly good, but we are not through with all the implications.  
What about redundant clusters?  

The following posts will look at the above in light of actual
experience.

### SNB Interactive Series

* [SNB Interactive, Part 1: What is SNB Interactive Really About?](../snb-interactive-part-1-what-is-snb-interactive-really-about)
* [SNB Interactive, Part 2: Modeling Choices](../snb-interactive-part-2-modeling-choices)
* [SNB Interactive, Part 3: Choke Points and Initial Run on Virtuoso](../snb-interactive-part-3-choke-points-and-initial-run-on-virtuoso/)
