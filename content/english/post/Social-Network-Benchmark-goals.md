---
type: post
title: "Social Network Benchmark Goals"
author: Josep Larriba Pey
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-10-14
tags: [social network benchmark, snb, data generator, big data]
# please make sure to remove image parameter if unused
# image: "post/social-network-benchmark-goals/featured.png" 
---

Social Network interaction is amongst the most natural and widely spread activities in the internet society, and it has turned out to be a very useful way for people to socialise at different levels (friendship, professional, hobby, etc.). As such, Social Networks are well understood from the point of view of the data involved and the interaction required by their actors. Thus, the concepts of friends of friends, or retweet are well established for the data attributes they represent, and queries such as “find the friend of a specified person who has long worked in a company in a specified country” are natural for the users and easy to understand from a functional point of view.

From a totally different perspective, Social Networks are challenging technologically, being part of the Big Data arena, and require the execution of queries that involve complex relationship search and data traversal computations that turn out to be choke points for the data management solutions in the market. 

With the objective of shaping a benchmark which is up to date as a use case, well understood by everybody and poses significant technological challenges, the LDBC consortium decided to create the Social Network Benchmark, [SNB](/benchmarks/snb), which is eventually going to include three workloads: the Interactive, the Business Intelligence and the Analytical. Those workloads are going to share a unique synthetic data generation tool that will mimic the data managed by real Social Networks.

The SNB data generator created by LDBC is an evolution of the S3G2 data generator and can be found at the [LDBC Github repository](https://github.com/ldbc/ldbc_socialnet_bm/tree/master/ldbc_socialnet_dbgen). The data generator is unique because it generates data that contains realistic distributions and correlations among variables that were not taken into consideration before. It also allows generating large datasets because it uses a Hadoop based implementation to compute the complex data generated. The SNB data generator has already been used in different situations like the [ACM SIGMOD programming contest 2014](http://www.cs.albany.edu/~sigmod14contest/). 

The SNB presents the Interactive workload as first of a breed with the objective to resemble the queries that users may place to a Social Network portal. Those are a combination of read and write small queries that express the needs of a user who is interacting with her friends and connections through the Social Network. Queries like that explained above (Q12 in the workload) are examples that set up choke points like pattern recognition or full traversals.

More details will be given in blogs to follow both for the data generator as well as for the specific characteristics of the workloads allowing the users to obtain a first contact with the benchmarks.
