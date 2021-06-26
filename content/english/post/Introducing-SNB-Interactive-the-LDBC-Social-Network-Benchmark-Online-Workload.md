---
type: post
title: "Introducing SNB Interactive, the LDBC Social Network Benchmark Online Workload"
author: Orri Erling
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-10-09
tags: [snb, Interactive Workload]
# please make sure to remove image parameter if unused
# image: "post/introducing-snb-interactive-the-ldbc-social-network-benchmark-online-workload/featured.png" 
---

The LDBC Social Network Benchmark (SNB) is composed of three distinct workloads, interactive, business intelligence and graph analytics. This post introduces the interactive workload.

The benchmark measures the speed of queries of medium complexity against a social network being constantly updated. The queries are scoped to a user's social environment and potentially access data associated with the friends or a user and their friends.

This is representative of an operational application. This goes beyond OLTP (On Line Transaction Processing) by having substantially more complex queries touching much more data than the point lookups and short reports in TPC-C or E. The emphasis is presenting a rich and timely view of a constantly changing environment.

SNB Interactive gives end users and application developers a reference workload for comparing the relative merits of different technologies for graph data management. These range from dedicated graph databases to RDF stores and relational databases. There are graph serving benchmarks such as the Facebook Linkbench but SMB Interactive goes well beyond this in richness of schema and queries.

The challenge to implementors is handling the user facing logic of a social network in a single system as the scale increases. The present practice in large social networks is massive sharding and use of different SQL and key value stores for different aspects of the service. The SNB workload is not intended to replicate this situation but to look for ways forward, so that one system can keep up with transactions and offer user rich and varied insight into their environment. The present practice relies on massive precomputation but SNB interactive seeks more agility and adhoc capability also on the operational side.

The dataset is scaled in buckets, with distinct scales for 10, 30, 100, 300GB and so forth. A 100GB dataset has approximately 500,000 simulated users with their connections and online history. This is a convenient low-end single server size while 500 million users is 100TB, which is a data center scale requiring significant scale-out.

The metric is operations per minute at scale. Online benchmarks typically have a fixed ratio between throughput and dataset size. Here we depart from this, thus one can report arbitrarily high throughputs at any scale. This makes main memory approaches feasible, which corresponds to present online practices.  The benchmark makes transactions and queries on a simulated timeline of social interactions. The challenge for the systm is to run this as fast as possible at the  selected  scale while providing fast and predictable response times. Throughput can be increased at the cost of latency but here the system must satisfy response time criteria while running at the reported throughput.

Different technologies can be used for implementing SNB interactive. The workload is defined in natural language with sample implementations in SPARQL and Cypher. Other possibilities include SQL and graph database API's.

SNB Interactive is an example of LDBC's choke point driven design methodology, where we draw on the combined knowledge and experience of several database system architects for defining realistic, yet ambitious challenges whose solution will advance the state of the art  

The benchmark specification and associated tools are now offered for public feedback. The LDBC partners working on SNB nteractive will provide sample implementations of the workload on their systems, including Virtuoso, Neo4J and Sparsity. Specifics of availability and coverage may vary.

Subsequent posts will address the workload in more detail.

