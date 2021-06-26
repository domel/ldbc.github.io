---
type: post
title: "Making Semantic Publishing Execution Rules"
author: Orri Erling
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-11-18
tags: [SPB, semantic publishing benchmark, ldbc, test run]
# please make sure to remove image parameter if unused
# image: "post/making-semantic-publishing-execution-rules/featured.png" 
---


[LDBC](http://ldbcouncil.org/) [SPB (Semantic Publishing Benchmark)](/benchmarks/spb) is based on the BBC linked data
platform use case. Thus the data modelling and transaction mix reflects
the BBC's actual utilization of RDF. But a benchmark is not only a
condensation of current best practices. The BBC linked data platform is
an [Ontotext Graph DB](http://www.ontotext.com/products/ontotext-graphdb-owlim/) deployment. Graph DB was formerly known as Owlim.

So, in SPB we wanted to address substantially more complex queries than
the lookups that the BBC linked data platform primarily serves. Diverse
dataset summaries, timelines and faceted search qualified by keywords
and/or geography are examples of online user experience that SPB needs
to cover.

SPB is not per se an analytical workload but we still find that the
queries fall broadly in two categories:

* Some queries are centred on a particular search or entity. The data
touched by the query size does not grow at the same rate as the dataset.
* Some queries cover whole cross sections of the dataset, e.g. find the
most popular tags across the whole database.

These different classes of questions need to be separated in a metric,
otherwise the short lookup dominates at small scales and the large query
at large scales.

Another guiding factor of SPB was the BBC's and others' express wish to
cover operational aspects such as online backups, replication and
fail-over in a benchmark. True, most online installations have to deal
with these things, which are yet as good as absent from present
benchmark practice. We will look at these aspects in a different
article, for now, I will just discuss the matter of workload mix and
metric.

Normally the lookup and analytics workloads are divided into different
benchmarks. Here we will try something different. There are three things
the benchmark does:

* Updates - These sometimes insert a graph, sometimes delete and
re-insert the same graph, sometimes just delete a graph. These are
logarithmic to data size.
* Short queries - These are lookups that most often touch on recent data
and can drive page impressions. These are roughly logarithmic to data
scale.
* Analytics - These cover a large fraction of the dataset and are
roughly linear to data size.

 
A test sponsor can decide on the query mix within certain bounds. A
qualifying run must sustain a minimum, scale-dependent update throughput
and must execute a scale-dependent number of analytical query mixes or
run for a scale-dependent duration. The minimum update rate, the minimum
number of analytics mixes and the minimum duration all grow
logarithmically to data size. Within these limits, the test sponsor can
decide how to mix the workloads. Publishing several results, emphasizing
different aspects is also possible. A given system may be specially good
at one aspect, leading the test sponsor to accentuate this.

The benchmark has been developed and tested at small scales, between 50
and 150M triples. Next we need to see how it actually scales. There we
expect to see how the two query sets behave differently. One effect that
we see right away when loading data is that creating the full text index
on the literals is in fact the longest running part. For a SF 32 ( 1.6
billion triples) SPB database we have the following space consumption
figures:

* 46886 MB of RDF literal text
* 23924 MB of full text index for RDF literals
* 23598 MB of URI strings
* 21981 MB of quads, stored column-wise with default index scheme

Clearly, applying column-wise compression to the strings is the best
move for increasing scalability. The literals are individually short, so
literal per literal compression will do little or nothing but applying
this by the column is known to get a 2x size reduction with Google
Snappy. The full text index does not get much from column store
techniques, as it already consists of words followed by space efficient
lists of word positions. The above numbers are measured with Virtuoso
column store, with quads column wise and the rest row-wise. Each number
includes the table(s) and any extra indices associated to them.

Let's now look at a full run at unit scale, i.e. 50M triples.

The run rules stipulate a minimum of 7 updates per second. The updates
are comparatively fast, so we set the update rate to 70 updates per
second. This is seen not to take too much CPU. We run 2 threads of
updates, 20 of short queries and 2 of long queries. The minimum run time
for the unit scale is 10 minutes, so we do 10 analytical mixes, as this
is expected to take 10 a little over 10 minutes. The run stops by itself
when the last of the analytical mixes finishes.


The interactive driver reports:

```
Seconds run : 2144
    Editorial:
        2 agents

        68164 inserts (avg : 46      ms, min : 5       ms, max : 3002    ms)
        8440  updates (avg : 72      ms, min : 15      ms, max : 2471    ms)
        8539  deletes (avg : 37      ms, min : 4       ms, max : 2531    ms)

        85143 operations (68164 CW Inserts (98 errors), 8440 CW Updates (0 errors), 8539 CW Deletions (0 errors))
        39.7122 average operations per second

    Aggregation:
        20 agents

        4120  Q1   queries (avg : 789     ms, min : 197     ms, max : 6767    ms, 0 errors)
        4121  Q2   queries (avg : 85      ms, min : 26      ms, max : 3058    ms, 0 errors)
        4124  Q3   queries (avg : 67      ms, min : 5       ms, max : 3031    ms, 0 errors)
        4118  Q5   queries (avg : 354     ms, min : 3       ms, max : 8172    ms, 0 errors)
        4117  Q8   queries (avg : 975     ms, min : 25      ms, max : 7368    ms, 0 errors)
        4119  Q11  queries (avg : 221     ms, min : 75      ms, max : 3129    ms, 0 errors)
        4122  Q12  queries (avg : 131     ms, min : 45      ms, max : 1130    ms, 0 errors)
        4115  Q17  queries (avg : 5321    ms, min : 35      ms, max : 13144   ms, 0 errors)
        4119  Q18  queries (avg : 987     ms, min : 138     ms, max : 6738    ms, 0 errors)
        4121  Q24  queries (avg : 917     ms, min : 33      ms, max : 3653    ms, 0 errors)
        4122  Q25  queries (avg : 451     ms, min : 70      ms, max : 3695    ms, 0 errors)

        22.5239 average queries per second. Pool 0, queries [ Q1 Q2 Q3 Q5 Q8 Q11 Q12 Q17 Q18 Q24 Q25 ]

        45318 total retrieval queries (0 timed-out)
        22.5239 average queries per second
```

The analytical driver reports:

```
Aggregation:
        2 agents

        14    Q4   queries (avg : 9984    ms, min : 4832    ms, max : 17957   ms, 0 errors)
        12    Q6   queries (avg : 4173    ms, min : 46      ms, max : 7843    ms, 0 errors)
        13    Q7   queries (avg : 1855    ms, min : 1295    ms, max : 2415    ms, 0 errors)
        13    Q9   queries (avg : 561     ms, min : 446     ms, max : 662     ms, 0 errors)
        14    Q10  queries (avg : 2641    ms, min : 1652    ms, max : 4238    ms, 0 errors)
        12    Q13  queries (avg : 595     ms, min : 373     ms, max : 1167    ms, 0 errors)
        12    Q14  queries (avg : 65362   ms, min : 6127    ms, max : 136346  ms, 2 errors)
        13    Q15  queries (avg : 45737   ms, min : 12698   ms, max : 59935   ms, 0 errors)
        13    Q16  queries (avg : 30939   ms, min : 10224   ms, max : 38161   ms, 0 errors)
        13    Q19  queries (avg : 310     ms, min : 26      ms, max : 1733    ms, 0 errors)
        12    Q20  queries (avg : 13821   ms, min : 11092   ms, max : 15435   ms, 0 errors)
        13    Q21  queries (avg : 36611   ms, min : 14164   ms, max : 70954   ms, 0 errors)
        13    Q22  queries (avg : 42048   ms, min : 7106    ms, max : 74296   ms, 0 errors)
        13    Q23  queries (avg : 48474   ms, min : 18574   ms, max : 93656   ms, 0 errors)
        0.0862 average queries per second. Pool 0, queries [ Q4 Q6 Q7 Q9 Q10 Q13 Q14 Q15 Q16 Q19 Q20 Q21 Q22 Q23 ]

        180 total retrieval queries (2 timed-out)
        0.0862 average queries per second
```


The metric would be 22.52 qi/s, 310 qa/h, 39.7 u/s @ 50Mt (SF 1)

 
The SUT is dual Xeon E5-2630, all in memory. The platform utilization is
steadily above 2000% CPU (over 20/24 hardware threads busy on the DBMS).
The DBMS is Virtuoso open source,
([v7fasttrack at github.com](https://github.com/v7fasttrack/virtuoso-opensource/),
[feature/analytics](https://github.com/v7fasttrack/virtuoso-opensource/tree/feature/analytics)).

The minimum update rate of 7/s was sustained but fell short of the
target of 70./s. In this run, most demand was put on the interactive
queries. Different thread allocations would give different ratios of the
metric components. The analytics mix is for example about 3x faster
without other concurrent activity.

Is this good or bad? I would say that this is possible but better can
certainly be accomplished.

The initial observation is that Q17 is the worst of the interactive lot.
3x better is easily accomplished by avoiding a basic stupidity. The
query does the evil deed of checking for a substring in a URI. This is
done in the wrong place and accounts for most of the time. The query is
meant to test geo retrieval but ends up doing something quite different.
Optimizing this right would almost double the interactive score. There
are some timeouts in the analytical run, which as such disqualifies the
run. This is not a fully compliant result but is close enough to give an
idea of the dynamics. So we see that the experiment is definitely
feasible, is reasonably defined and that the dynamics seen make sense.

As an initial comment of the workload mix, I'd say that interactive
should have a few more very short point lookups to stress compilation
times and give a higher absolute score of queries per second.

Adjustments to the mix will depend on what we find out about scaling. As
with SNB, it is likely that the workload will shift a little, so this
result might not be comparable with future ones.

In the next SPB article, we will look closer at performance dynamics and
choke points and will have an initial impression on scaling the
workload.
