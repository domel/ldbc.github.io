---
type: post
title: "DATAGEN: Data Generation for the Social Network Benchmark"
author: Arnau Prat
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-10-09
tags: [datagen, social network benchmark, social network]
# please make sure to remove image parameter if unused
# image: "post/datagen-data-generation-for-the-social-network-benchmark/featured.png" 
---

As explained in a previous post, the LDBC Social Network Benchmark (LDBC-SNB) has the objective to provide a realistic yet challenging workload, consisting of a social network and a set of queries. Both have to be realistic, easy to understand and easy to generate. This post has the objective to discuss the main features of DATAGEN, the social network data generator provided by LDBC-SNB, which is an evolution of S3G2 [[1]](#references).

One of the most important components of a benchmark is the dataset. However, directly using real data in a benchmark is not always possible. On the one hand, it is difficult to find data with all the scaling characteristics the benchmark requires. On the other hand, collecting real data can be expensive or simply not possible due to privacy concerns.

For these reasons, LDBC-SNB provides DATAGEN which is the synthetic data generator responsible for generating the datasets for the three LDBC-SNB workloads: the Interactive, the Business Intelligence and the Analytical. DATAGEN has been carefully designed with the following goals in mind:

 * **Realism.** The data generated by DATAGEN has to mimic the features of those found in a real social network. In DATAGEN, output attributes, cardinalities, correlations and distributions have been finely tuned to reproduce a real social network in each of its aspects. DATAGEN is aware of the data and link distributions found in a real social network such as Facebook [[2]](#references). Also, it uses real data from DBPedia, such as property dictionaries, which ensure that the content is realistic and correlated.
 * **Scalability.** Since LDBC-SNB is targeting systems of different scales and budgets, DBGEN must be capable of generating datasets of different sizes, from a few Gigabytes to Terabytes. DATAGEN is implemented following the MapReduce paradigm, allowing for the generation of large datasets on commodity clusters.
 * **Determinism.** DATAGEN is deterministic regardless of the number of cores/machines used to produce the data. This important feature guarantees that all Test Sponsors will face the same dataset, thus, making the comparisons between different systems fair and the benchmarks’ results reproducible.
 * **Usability.** LDBC-SNB has been designed to have an affordable entry point. As such, DATAGEN has been severely influenced by this philosophy, and therefore it has been designed to be as easy to use as possible.

Finally, the area of action of DATAGEN is not only limited to the scope of LDBC-SNB. Several researchers and practitioners are already using DATAGEN in a wide variety of situations. If you are interested on the internals and possibilities of DATAGEN, please visit its official repository (https://github.com/ldbc/ldbc_snb_datagen).


#### References

[1] Pham, Minh-Duc, Peter Boncz, and Orri Erling. "S3g2: A scalable structure-correlated social graph generator." Selected Topics in Performance Evaluation and Benchmarking. Springer Berlin Heidelberg, 2013. 156-172.

[2] Prat-Pérez, Arnau, and David Dominguez-Sal. "How community-like is the structure of synthetically generated graphs?." Proceedings of Workshop on GRAph Data management Experiences and Systems. ACM, 2014.