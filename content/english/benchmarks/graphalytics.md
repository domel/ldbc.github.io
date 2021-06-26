---
title: "LDBC Graphalytics Benchmark (LDBC-Graphalytics)"
aliases: [
    "/benchmark-graphalytics/",
    "/ldbc-graphalytics-0"
]
---

The Graphalytics benchmark is an industrial-grade benchmark for **graph
analysis platforms** such as Giraph. It consists of six core
algorithms, standard datasets, synthetic dataset generators,
and reference outputs, enabling the objective comparison of graph
analysis platforms. 

The design of the benchmark process takes into account that
graph-processing is impeded by three dimensions of
diversity: **platform**,  **algorithms** and **dataset**. 

The benchmark harness consists of a core component, which is extendable
by a driver for each different platform implementation. The choice of
the six algorithms:

1.  breadth-first search,
2.  PageRank,
3.  weakly connected components,
4.  community detection using label propagation,
5.  local clustering coefficient, and
6.  single-source shortest paths

was carefully motivated, using the LDBC TUC and extensive literature
surveys to ensure good coverage of scenarios. The standard datasets
include both real and synthetic datasets, which are classified into
intuitive “T-shirt” sizes (e.g., **S, M, L, XL**).

Each experiment set in Graphalytics consists of **multiple platform
runs** (a platform executes an algorithm on a dataset), and diverse set
of experiments are carried out to evaluate different performance
characteristics of a system-under-test.

All completed benchmarks must go through a strict **validation process**
to ensure the integrity of the performance results.

The Graphalytics benchmarking process is made future-proof, through a
**renewal process** that takes place regularly to ensure that the
benchmark process meets the state-of-the-art development in the field of
graph analytics.

To enhance the depth of the benchmark process, Graphalytics also
facilitates a plugin-architecture, which allows external **software
tools** to be added to the benchmark harness. For instance, it is
possible to also use SNB **Datagen** (the data generator of the LDBC
Social Network Benchmark), an advanced synthetic dataset generator to
create synthetic graphs for custom test scenarios, or to use
**Granula**, a fine-grained performance evaluation tool to obtain
enriched performance results.

The development of Graphalytics is supported by many active vendors in
the field of large-scale graph analytics. Currently, Graphalytics
already facilitates benchmark for a large number of graph analytics
platforms, such as Giraph, GraphX, GraphMat, OpenG, and PGXD, allowing
comparison of the state-of-the-art system performance of both
community-driven and industrial-driven platforms. To get started, the
details of the Graphalyics documentation and its software components are
described below.
