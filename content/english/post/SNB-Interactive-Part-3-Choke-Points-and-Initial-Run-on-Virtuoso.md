---
type: post
title: "SNB Interactive Part 3: Choke Points and Initial Run on Virtuoso"
author: Orri Erling
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
short_comment: "Note: this post is a continuation of \"SNB Interactive, Part 2: Modeling Choices\" post by Orri Erling."
date: 2015-06-10
tags: [snb, interactive]
---

In this post we will look at running the [LDBC SNB](/developer/snb) on [Virtuoso](https://virtuoso.openlinksw.com/).

First, let's recap what the benchmark is about:

1. fairly frequent short updates, with no update contention worth
mentioning
1. short random lookups
1. medium complex queries centered around a person's social environment

The updates exist so as to invalidate strategies that rely too heavily
on precomputation. The short lookups exist for the sake of realism;
after all, an online social application does lookups for the most part.
The medium complex queries are to challenge the DBMS.

The DBMS challenges have to do firstly with query optimization, and
secondly with execution with a lot of non-local random access patterns.
Query optimization is not a requirement, _per se,_ since imperative
implementations are allowed, but we will see that these are no more free
of the laws of nature than the declarative ones.

The workload is arbitrarily parallel, so intra-query parallelization is
not particularly useful, if also not harmful. There are latency
constraints on operations which strongly encourage implementations to
stay within a predictable time envelope regardless of specific query
parameters. The parameters are a combination of person and date range,
and sometimes tags or countries. The hardest queries have the potential
to access all content created by people within 2 steps of a central
person, so possibly thousands of people, times 2000 posts per person,
times up to 4 tags per post. We are talking in the millions of key
lookups, aiming for sub-second single-threaded execution.

The test system is the same as used in
the [TPC-H series](http://www.openlinksw.com/weblog/oerling/?id=1739):
dual Xeon E5-2630, 2x6 cores x 2 threads, 2.3GHz, 192 GB RAM. The
software is the [feature/analytics branch](https://github.com/v7fasttrack/virtuoso-opensource/tree/feature/analytics) of [v7fasttrack, available from www.github.com](https://github.com/v7fasttrack/virtuoso-opensource/).

The dataset is the SNB 300G set, with:

| 1,136,127     | persons                     | 
|-----------------|-----------------------------| 
| 125,249,604   | knows edges                 | 
| 847,886,644   | posts, including replies | 
| 1,145,893,841 | tags of posts or replies    | 
| 1,140,226,235 | likes of posts or replies   | 

As an initial step, we run the benchmark as fast as it will go. We use
32 threads on the driver side for 24 hardware threads.

Below are the numerical quantities for a 400K operation run after 150K
operations worth of warmup.

**Duration:** 10:41.251 \
**Throughput:** 623.71 (op/s)

The statistics that matter are detailed below, with operations ranked in
order of descending client-side wait-time. All times are in
milliseconds.

| % of total | total_wait  | name                          | count    | mean       | min     | max      | 
|------------|-------------|-------------------------------|----------|------------|---------|----------| 
| 20 %       | "4,231,130" | LdbcQuery5                    | 656      | "6,449.89" | 245     | "10,311" | 
| 11 %       | "2,272,954" | LdbcQuery8                    | "18,354" | 123.84     | 14      | "2,240"  | 
| 10 %       | "2,200,718" | LdbcQuery3                    | 388      | "5,671.95" | 468     | "17,368" | 
| 7.3 %      | "1,561,382" | LdbcQuery14                   | "1,124"  | "1,389.13" | 4       | "5,724"  | 
| 6.7 %      | "1,441,575" | LdbcQuery12                   | "1,252"  | "1,151.42" | 15      | "3,273"  | 
| 6.5 %      | "1,396,932" | LdbcQuery10                   | "1,252"  | "1,115.76" | 13      | "4,743"  | 
| 5 %        | "1,064,457" | LdbcShortQuery3PersonFriends  | "46,285" | 22.9979    | 0       | "2,287"  | 
| 4.9 %      | "1,047,536" | LdbcShortQuery2PersonPosts    | "46,285" | 22.6323    | 0       | "2,156"  | 
| 4.1 %      | "885,102"   | LdbcQuery6                    | "1,721"  | 514.295    | 8       | "5,227"  | 
| 3.3 %      | "707,901"   | LdbcQuery1                    | "2,117"  | 334.389    | 28      | "3,467"  | 
| 2.4 %      | "521,738"   | LdbcQuery4                    | "1,530"  | 341.005    | 49      | "2,774"  | 
| 2.1 %      | "440,197"   | LdbcShortQuery4MessageContent | "46,302" | 9.50708    | 0       | "2,015"  | 
| 1.9 %      | "407,450"   | LdbcUpdate5AddForumMembership | "14,338" | 28.4175    | 0       | "2,008"  | 
| 1.9 %      | "405,243"   | LdbcShortQuery7MessageReplies | "46,302" | 8.75217    | 0       | "2,112"  | 
| 1.9 %      | "404,002"   | LdbcShortQuery6MessageForum   | "46,302" | 8.72537    | 0       | "1,968"  | 
| 1.8 %      | "387,044"   | LdbcUpdate3AddCommentLike     | "12,659" | 30.5746    | 0       | "2,060"  | 
| 1.7 %      | "361,290"   | LdbcShortQuery1PersonProfile  | "46,285" | 7.80577    | 0       | "2,015"  | 
| 1.6 %      | "334,409"   | LdbcShortQuery5MessageCreator | "46,302" | 7.22234    | 0       | "2,055"  | 
| 1 %        | "220,740"   | LdbcQuery2                    | "1,488"  | 148.347    | 2       | "2,504"  | 
| 0.96 %     | "205,910"   | LdbcQuery7                    | "1,721"  | 119.646    | 11      | "2,295"  | 
| 0.93 %     | "198,971"   | LdbcUpdate2AddPostLike        | "5,974"  | 33.3062    | 0       | "1,987"  | 
| 0.88 %     | "189,871"   | LdbcQuery11                   | "2,294"  | 82.7685    | 4       | "2,219"  | 
| 0.85 %     | "182,964"   | LdbcQuery13                   | "2,898"  | 63.1346    | 1       | "2,201"  | 
| 0.74 %     | "158,188"   | LdbcQuery9                    | 78       | "2,028.05" | "1,108" | "4,183"  | 
| 0.67 %     | "143,457"   | LdbcUpdate7AddComment         | "3,986"  | 35.9902    | 1       | "1,912"  | 
| 0.26 %     | "54,947"    | LdbcUpdate8AddFriendship      | 571      | 96.2294    | 1       | 988      | 
| 0.2 %      | "43,451"    | LdbcUpdate6AddPost            | "1,386"  | 31.3499    | 1       | "2,060"  | 
| 0.01%      | "1,848"     | LdbcUpdate4AddForum           | 103      | 17.9417    | 1       | 65       | 
| 0.00%      | 44          | LdbcUpdate1AddPerson          | 2        | 22         | 10      | 34       | 

At this point we have in-depth knowledge of the choke points the
benchmark stresses, and we can give a first assessment of whether the
design meets its objectives for setting an agenda for the coming years
of graph database development.

The implementation is well optimized in general but still has maybe 30%
room for improvement. We note that this is based on a compressed column
store. One could think that alternative data representations, like
in-memory graphs of structs and pointers between them, are better for
the task. This is not necessarily so; at the least, a compressed column
store is much more space efficient. Space efficiency is the root of cost
efficiency, since as soon as the working set is not in memory, a random
access workload is badly hit.

The set of choke points (technical challenges) actually revealed by the
benchmark is so far as follows:

* *Cardinality estimation under heavy data skew —* Many queries take
a tag or a country as a parameter. The cardinalities associated
with tags vary from 29M posts for the most common to 1 for the least
common. Q6 has a common tag (in top few hundred) half the time and a
random, most often very infrequent, one the rest of the time. A
declarative implementation must recognize the cardinality implications
from the literal and plan accordingly. An imperative one would have to
count. Missing this makes Q6 take about 40% of the time instead of 4.1%
when adapting.
* *Covering indices —* Being able to make multi-column indices that
duplicate some columns from the table often saves an entire table
lookup. For example, an index onpost by author can also contain
the post's creation date.
* *Multi-hop graph traversal —* Most queries access a two-hop
environment starting at a person. Two queries look for shortest paths of
unbounded length. For the two-hop case, it makes almost no difference
whether this is done as a union or a special graph traversal operator.
For shortest paths, this simply must be built into the engine; doing
this client-side incurs prohibitive overheads. A bidirectional shortest
path operation is a requirement for the benchmark.
* *Top _K_ —* Most queries returning posts order results by
descending date. Once there are at least _k_ results, anything older
than the __k__th can be dropped, adding a dateselection as early as
possible in the query. This interacts with vectored execution, so that
starting with a short vector size more rapidly produces an initial
top _k_.
* *Late projection —* Many queries access several columns and touch
millions of rows but only return a few. The columns that are not used in
sorting or selection can be retrieved only for the rows that are
actually returned. This is especially useful with a column store, as
this removes many large columns (e.g., text of a post) from the working
set.
* *Materialization —* Q14 accesses an expensive-to-compute edge weight,
the number of post-reply pairs between two people. Keeping this
precomputed drops Q14 from the top place. Other materialization would be
possible, for example Q2 (top 20 posts by friends), but since Q2 is just
1% of the load, there is no need. One could of course argue that this
should be 20x more frequent, in which case there could be a point to
this.
* *Concurrency control —* Read-write contention is rare, as updates are
randomly spread over the database. However, some pages get read very
frequently, e.g., some middle level index pages in the post table.
Keeping a count of reading threads requires a mutex, and there is
significant contention on this. Since the hot set can be one page,
adding more mutexes does not always help. However, hash partitioning the
index into many independent trees (as in the case of a cluster) helps
for this. There is also contention on a mutex for assigning threads to
client requests, as there are large numbers of short operations.

In subsequent posts, we will look at specific queries, what they in fact
do, and what their theoretical performance limits would be. In this way
we will have a precise understanding of which way SNB can steer the
graph DB community.

### SNB Interactive Series

* [SNB Interactive, Part 1: What is SNB Interactive Really About?](../snb-interactive-part-1-what-is-snb-interactive-really-about)
* [SNB Interactive, Part 2: Modeling Choices](../snb-interactive-part-2-modeling-choices)
* [SNB Interactive, Part 3: Choke Points and Initial Run on Virtuoso](../snb-interactive-part-3-choke-points-and-initial-run-on-virtuoso/)
