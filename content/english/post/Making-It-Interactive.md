---
type: post
title: "Making It Interactive"
author: Orri Erling
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-10-09
tags: [snb, benchmarking, tpc, sparql, interactive]
# please make sure to remove image parameter if unused
# image: "post/making-it-interactive/featured.png" 
---

_Synopsis:_ Now is the time to finalize the interactive part of the Social Network Benchmark (SNB). The benchmark must be both credible in a real social network setting and pose new challenges. There are many hard queries but not enough representation for what online systems in fact do. So, the workload mix must strike a balance between the practice and presenting new challenges.

It is about to be showtime for LDBC. The initial installment of the LDBC Social Network Benchmark (SNB) is the full data generator, test driver, workload and reference implementation for the interactive workload. SNB will further acquire business intelligence and graph analytics workloads but this post is about the interactive workload.

As part of finalizing the interactive workload, we need to determine precise mixes of the component queries and updates. We note that the interactive mix so far consists of very heavy queries. These touch, depending on the scale upwards of a million entities in the database.

Now, rendering a page view in a social network site does not touch millions of entities. The query that needs to be correct and up to date touches tens or hundreds of entities, e.g. posts or social connections for a single page impression. There are also statistical views like the count of people within so many steps or contact recommendations but these are not real time and not recalculated each time they are shown.

So, LDBC SNB has a twofold task:

1. In order to be a credible interactive workload, it must in fact have characteristics of one
2. In order to stimulate progress it must have queries that are harder than those that go in routine page views but are still not database-wide analytics.

Designing a workload presents specific challenges:

1. The workload must be realistic enough for users to identify with it.
2. The workload must pose challenges and drive innovation in a useful direction.
3. The component operations must all play a noticeable role in it.  If the operation's relative performance doe does not affect the score, why is it in the workload?


The interactive mix now has 14 queries that are interesting from a query optimization and execution viewpoint but touch millions of entities. This is not what drives page inpressions in online sites. Many users of GDB and RDF are about online sites, so this aspect must not be ignored.

Very roughly, the choke points (technical challenges) of SNB interactive are as follows:

* Random access - Traversing between people, content makes large numbers of random lookups. These can be variously parallelized and/or vectored.
* Query optmization must produce right plans - The primary point isjoin order and join type.  Index vs. hash based joins have very different performance properties and the right choice depends on corectly guessing the number of rows and of distinct keys on either side of the join.
* When doing updates and lookups, the execution plan is obvious but there the choke point is the scheduling of large numbers of short operations.
* Many queries have aggregation, many have distinct, all have result ordering and and a limit on result count. The diverse interactions of these operators produce optimization opportunities.


Dreaming up a scenario and workload is not enough for a benchmark. There must also be a strong indication that the job is do-able and plausible in the scenario.

In online benchmarks different operations have different frequencies and the operations are repeated large numbers of times. There is a notion of steady state, so that the reported result represents a level of performance a system can sustain indefinitely.

A key part of the workload definition is the workload mix, i.e. the relative frequencies of the operations. This decides in fact what the benchmark measures.

The other aspect is the metric, typically some variation on operations per unit of time.

All these are interrelated. Here we can take clicks per second as a metric, which is easy to understand. We wish to avoid the pitfall of TPC-C which ties the metric to a data size, so that for a high metric one must have a correspondingly larger database. This rule makes memory-only implementations in practice unworkable, while in reality many online systems in fact run from memory. So, here we scale in buckets, like in TPC-H but we still have an online workload. The scenario of the benchmark has its own timeline, here called simulation time. A benchmark run produces events in the simulation time but takes place in real time. This defines an accelration ratio. For example we could say that a system does 1000 operations per second at 300G scale, with an acceleration of 7x, i.e. 7 hours worth of simulation time are done in one hour of real time. A metric of this form is directly understandable for sizing a system, as long as the workload mix is realistic. We note that online sites usually are provisioned so that servers do not run anywhere near their peak throughput at a busy time.

So how to define the actual mix? By measuring. But measuring requires a reference implementation that is generally up to date for the database science of the time and where the individual workload pieces are implemented in a reasonable manner, so no bad query plans or bad schema design. For the reference implementation, we use Virtuoso column store in SQL.

But SQL is not graphy! Why not SPARQL? Because SPARQL has diverse fixed overheads and this is not a RDF-only workload. We do not want SPARQL overheads to bias the metric, we just want an implementation where we know exactly what goes on and how it works, with control of physical data placement so we know there are no obvious stupidities in any of this. SPARQL will come. Anyway, as said elsewhere, we believe that SPARQL will outgrow its overheads, at which point SQL or SPARQL is a matter of esthetic preference.  For now, it is SQL and all we want is transparency into the metal.

Having this, we peg the operation mix to the update stream generated by the data generator. At the 30G scale, there are 3.5M new posts/replies per month of simulation time.  For each such, a query mix will be run, so as to establish a realistic read/write ratio. The query mix will have fractional queries, for example 0.2 friends recommendations per new post, but that is not a problem, since we run large numbers of these and at the end of the run can check that the ratios of counts are as expected.  Next, we run this as fast as it will go on the test system. Then we adjust the ratio of short and long queries to get two objectives:

* Short queries should collectively be about 45% of the CPU load.
* Updates will be under 5%
* Long queries will take up the rest.  For long queries, we further tune the relative frequencies so that each represents a roughly equal slice of the time. Having a query that does not influence the metric is useless, so each gets enough showtime to have an impact but by their nature some are longer than others.

The reason why short queries should have a large slice is the fact that this is so in real interactive systems. The reason why long queries are important is driving innovation.  Like this we get both scheduling (short lookup/update) and optimization choke points covered. As a bonus be make the mix so that we get a high metric, so many clicks per second, since this is what the operator of an online site wants.

There is a further catch: Different scales have different degrees of the friends graph and this will have a different influence on different queries.  To see whether this twists the metric out of shape we must experiment. For example, one must not have ogarithmic and linear complexity queries in the same mix, as BSBM for example has. So this is to be kept in mind as we proceed.

In the next post we will look at the actual mix and execution times on the test system.