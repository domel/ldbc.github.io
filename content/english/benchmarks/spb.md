---
title: "LDBC Semantic Publishing Benchmark (LDBC-SPB)"
aliases: [
    "/benchmark-spb/",
    "/developer/spb"
]
---

The Semantic Publishing Benchmark (SPB) is an LDBC benchmark for testing the performance of RDF engines inspired by the Media/Publishing industry. In particular, LDBC worked with British Broadcasting Corporation [BBC](http://www.bbc.co.uk/blogs/internet/posts/Linked-Data-Connecting-together-the-BBCs-Online-Content) to define this benchmark, for which BBC donated workloads, [ontologies](https://github.com/ldbc/ldbc_spb_bm_2.0/tree/master/datasets_and_queries/ontologies) and data. The publishing industry is an area where significant adoption of RDF is taking place.

There have been many academic benchmarks for RDF but none of these are
truly industrial-grade. The SPB  combines a set of complex queries under
inference with continuous updates and special failover tests for systems
implementing replication.

SPB performance is measured by producing a workload of CRUD (Create,
Read, Update, Delete) operations which are executed simultaneously. The
benchmark offers a data generator that uses real reference data to
produce datasets of various sizes and tests the scalability aspect
of RDF systems. The benchmark workload consists of (a) editorial
operations that add new data, alter or delete existing (b) aggregation
operations that retrieve content according to various criteria. The
benchmark also tests conformance for various rules inside
the OWL2-RL rule-set.

The [SPB specification](https://github.com/ldbc/ldbc_spb_bm_2.0/blob/master/doc/LDBC_SPB_v2.0.docx?raw=true) contains the description of the benchmark and the data generator and all information about its software components can be found on the [SPB developer page](http://ldbcouncil.org/developer/spb).

#### Semantic Publishing Benchmark (SPB) Audited Results for Scale Factors SF1 - 64M, SF3 - 256M and SF5 - 1G triples are shown below. 

| **Scale Factor** |**Interactive (Q/s)** |**Updates (ops/sec)** | **Analytical** | **Cost** | **Software** | **Hardware** | **Test Sponsor** | **Date** | **Full Disclosure Report**
|--|--|--|--|--|--|--|--|--|--
| 1 | 100.85 | 10.19  |	n.a. |	€37,504 |GraphDB EE6.2 | Xeon1650v3 6-core 3.5Ghz 96GB RAM | [ONTOTEXT AD](http://www.ontotext.com/) | 2015/04/26 | [Full Disclosure Report](LDBC_SPB20_20150426_SF1_GraphDB-EE-6.2b.pdf)
| 1 | 142.7588 |10.6725 |n.a |€35,323  |GraphDB SE 6.3 alpha |CPU Intel Xeon E5-1650 v3 3.5Ghz,15MB L3 cache, s2011 |[ONTOTEXT AD](http://www.ontotext.com/) |2015/06/10  | [Full Disclosure Report](LDBC-SPB-64M-GraphDB-10062015.pdf)
| 3 | 29.90 | 9.50 | n.a. | €37,504 | GraphDB EE6.2 | Xeon1650v3 6-core 3.5Ghz 96GB RAM | [ONTOTEXT AD](http://www.ontotext.com/) | 2015/04/26 | [Full Disclosure Report](LDBC_SPB20_20150426_SF3_GraphDB-EE-6.2b.pdf)
| 3 | 54.6364 | 9.4967 | n.a | €35,323 |GraphDB SE 6.3 alpha |CPU Intel Xeon E5-1650 v3 3.5Ghz,15MB L3 cache, s2011 |[ONTOTEXT AD](http://www.ontotext.com/) |2015/06/10  | [Full Disclosure Report](LDBC-SPB-256M-GraphDB-10062015.pdf)
|1 |149.0385 |156.8325 |n.a. |$20,213 (€17,801 rate of 21/06/2015) |Virtuoso Opensource Version 7.50.3213 |Intel Xeon E5-2630, 6x 2.30GHz, Sockel 2011, boxed, 192 GB RAM |[OpenLink Software](http://www.openlinksw.com/) |2015/06/09 | [Full Disclosure Report](LDBC-SPB-64M-Virtuoso-09062015.pdf) 
|3 | 80.6158 | 92.7072 | n.a. | $20,213 (€17,801 rate of 21/06/2015) |Virtuoso Opensource Version 7.50.3213 |Intel Xeon E5-2630, 6x 2.30GHz, Sockel 2011, boxed, 192 GB RAM |[OpenLink Software](http://www.openlinksw.com/) |2015/06/09 | [Full Disclosure Report](LDBC-SPB-256M-Virtuoso-09062015.pdf)
|3 | 115.3838 | 109.8517 | n.a. | $24,528 (€21,601 rate 21/06/2015) |Virtuoso Opensource Version 7.50.3213 |Amazon EC2, r3.8xlarge |[OpenLink Software](http://www.openlinksw.com/) |2015/06/09 | [Full Disclosure Report](LDBC-SPB-256M-Virtuoso-EC2-09062015.pdf)
|5 |32.2789 |72.7192 |n.a.  |$20,213 (€17,801 rate 21/06/2015) |Virtuoso Opensource Version 7.50.3213 |Intel Xeon E5-2630, 6x 2.30GHz, Sockel 2011, boxed, 192 GB RAM | [OpenLink Software](http://www.openlinksw.com/) | 2015/06/09 | [Full Disclosure Report](LDBC-SPB-1G-Virtuoso-09062015.pdf)
|5|45.8101 |55.4467 |n.a |$24,528 (€21,601 rate 21/06/2015) | Virtuoso Opensource Version 7.50.3213 |Amazon EC2, r3.8xlarge |[OpenLink Software](http://www.openlinksw.com/) |2015/06/10 | [Full Disclosure Report](LDBC-SPB-1G-Virtuoso-EC2-10062015.pdf)
