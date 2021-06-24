---
title: "LDBC Graphalytics Benchmark (LDBC-Graphalytics)"
aliases: [
    "/benchmark-graphalytics/",
    "/ldbc-graphalytics-0"
]
---

The Graphalytics benchmark is an industrial-grade benchmark for **graph
analysis platforms** such as Giraph. It consists of six core
algorithms, standard datasets, synthetic dataset generators,
and reference outputs, enabling the objective comparison of graph
analysis platforms. 

The design of the benchmark process takes into account that
graph-processing is impeded by three dimensions of
diversity: **platform**,  **algorithms** and **dataset**. 

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

The Graphalytics benchmarking process is made future-proof, through a
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

#### For Developers

The main Graphalytics components can be found at:

-   [​](github.com/ldbc/ldbc_graphalytics_docs)[https://github.com/](https://github.com/tudelft-atlarge/graphalytics_docs)[ldbc](https://github.com/ldbc/ldbc_graphalytics_docs)[/](https://github.com/ldbc/ldbc_graphalytics_docs)[ldbc\_graphalytics\_docs](https://github.com/ldbc/ldbc_graphalytics_docs) Graphalytics
    documents
-   <https://github.com/ldbc/ldbc_graphalytics> Graphalytics
    implementation

##### **Documentation**

The Graphalytics project leads to several academic publications,
including a recent article at VLDB 2016 (available soon). The first
draft of the Graphalytics specification document
(<https://github.com/ldbc/ldbc_graphalytics_docs>) is available, which
explains in details the benchmark specifications of Graphalytics.

To start using Graphalytics, a complete guide on how to install and run
LDBC Graphalytics (<https://github.com/ldbc/ldbc_graphalytics>) can be
found in our repositories, and there are also instructions for creating
a new platform driver for Graphalytics
(<https://github.com/ldbc/ldbc_graphalytics/wiki/>).

##### **Implementation**

Our repository is currently hosted
at <https://github.com/atlarge-research>, which may soon be relocated to
the main LDBC repository. Graphalytics consists of a core implementation
(<https://github.com/ldbc/ldbc_graphalytics>), which is extendable by a
driver implementation for each platform. Currently, Graphalytics also
already support driver implementation of several state-of-the-art graph
analysis platforms
(https://github.com/atlarge-research/​graphalytics-platforms-\*), some
of which are vendor-optimized.

##### **Standard datasets and Reference outputs**

Graphalytics also provides standard datasets and their reference outputs
(validated outputs for each algorithm), which can be used in the
benchmark process. These datasets will be made available soon.

##### **Recommended Tools**

To enhance the depth and comprehensiveness of the benchmark process, the
following software tools are integrated into Graphalytics. Usage of
these tools is optional, but highly recommended.

1.  Datagen (<https://github.com/ldbc/ldbc_snb_datagen>): Graphalytics
    relies not only on real-world graphs but also on synthetically
    generated graphs, which provide a means of testing data
    configurations not always available in the form of real datasets.
    Datagen, for example, is an advanced synthetic graph generator which
    not only preserves many realistic graph features, but also supports
    graphs with tunable degree distributions and structural
    characteristics.
2.  Granula (<https://github.com/atlarge-research/granula>): To extend
    Graphalytics with fine-grained performance evaluation, we developed
    Granula, a performance evaluation system for graph analysis
    platform, Granula consists of four main modules: the modeller, the
    monitor, the archiver, and the visualizer. By using Granula,
    enriched performance results can be obtained for each benchmark run,
    which helps in facilitating in-depth performance a
