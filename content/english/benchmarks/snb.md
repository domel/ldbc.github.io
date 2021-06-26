---
title: "LDBC Social Network Benchmark (LDBC-SNB)"
aliases: [
    "/benchmark-snb/",
    "/developer/snb"
]
---

The Social Network Benchmark consists in fact of three distinct
benchmarks on a common dataset, since there
are **three different workloads**.
Each workload produces a single metric for performance at the given
scale and a price/performance metric at the scale.  The full
disclosure further breaks down the composition of the metric into its
constituent parts, e.g. single query execution
times.

- **The Social Network Benchmark\'s Interactive workload**, a
    benchmark focusing on transactional graph processing with complex
    read queries that access the neighbourhood of a given node in the
    graph and update operations that continuously insert new data in the
    graph.
- **The Social Network Benchmark\'s Business Intelligence workload**,
    a benchmark that focuses on aggregation- and join-heavy complex
    queries touching a large portion of the graph with microbatches of
    insert/delete update operations. This workload is not yet
    finalized.

#### Social Network Benchmark Interactive ([version 0.3.2](https://arxiv.org/pdf/2001.02299.pdf)) audited results

##### TuGraph

TuGraph was audited in July 2020. TuGraph is owned by [Ant
Group](https://www.antgroup.com/en) now.


| **SF** | **Throughput (ops/sec)** | **Cost** | **Software** | **Hardware** | **Test Sponsor** | **Date** | **Full Disclosure Report** |
|--------|--------------------------|----------|--------------|--------------|------------------|----------|---------------------------|
|30 |	5,436.47 |	$280,650 |	[TuGraph 1.10](https://fma-ai.cn/) |	AWS r5d.12xlarge instance, 48\*Intel Xeon Platinum 8175M @ 2.5GHz, 374GB RAM | [FMA](https://fma-ai.cn/) |	2020/07/26 |	 [Full Disclosure Report](LDBC_SNB_I_20200726_SF30-100-300_tugraph.pdf) 
|100 |	5,010.77 |	$280,650 |	[TuGraph 1.10](https://fma-ai.cn/) |	AWS r5d.12xlarge instance, 48\*Intel Xeon Platinum 8175M @ 2.5GHz, 374GB RAM | [FMA](https://fma-ai.cn/) |	2020/07/26 |	 [Full Disclosure Report](LDBC_SNB_I_20200726_SF30-100-300_tugraph.pdf) 
|300 |	4,855.52 |	$280,650 |	[TuGraph 1.10](https://fma-ai.cn/) |	AWS r5d.12xlarge instance, 48\*Intel Xeon Platinum 8175M @ 2.5GHz, 374GB RAM | [FMA](https://fma-ai.cn/) |	2020/07/26 |	 [Full Disclosure Report](LDBC_SNB_I_20200726_SF30-100-300_tugraph.pdf) 

Supplementary material for the TuGraph audits:

-  [Executive summary](LDBC_SNB_I_20200726_SF30-100-300_tugraph-executive_summary.pdf)
-  [Signatures](LDBC_SNB_I_20200726_SF30-100-300_tugraph-signatures.pdf)
-  [Attachments](https://drive.google.com/file/d/198UrkL7_vduOm5MTneVniiYBG8U2a8x9/view?usp=sharing)


#### Social Network Benchmark Interactive ([version 0.2.2](https://github.com/ldbc/ldbc_snb_docs/blob/8d325657069b444dd79fe21c770ecc9d88cc2c53/LDBC_SNB_v0.2.2.pdf)) audited results 

| **SF** | **Throughput (ops/sec)** | **Cost** | **Software** | **Hardware** | **Test Sponsor** | **Date** | **Full Disclosure Report** |
|--------|--------------------------|----------|--------------|--------------|------------------|----------|---------------------------|
| 10 | 101.20 | €30,427 | Sparksee 5.1.1 | 2\*Xeon 2630v3 8-core 2.4GHz, 256GB RAM |[Sparsity Technologies SA](http://www.sparsity-technologies.com) |2015/04/27 | [Full Disclosure Report](LDBC_SNB_I_20150427_SF10_sparksee.pdf)
| 30 | 1287.17 | €20,212 | Virtuoso 07.50.3213 [v7fasttrack](https://github.com/v7fasttrack/virtuoso-opensource) | 2*Xeon2630 6-core 2.4GHz, 192GB RAM | [OpenLink Software](http://www.openlinksw.com) | 2015/04/27 | [Full Disclosure Report](LDBC_SNB_I_20150427_SF30_virtuoso.pdf)
| 30 | 86.50 | €30,427 | Sparksee 5.1.1 | 2\*Xeon 2630v3 8-core 2.4GHz, 256GB RAM |[Sparsity Technologies SA](http://www.sparsity-technologies.com) |2015/04/27 | [Full Disclosure Report](LDBC_SNB_I_20150427_SF30_sparksee.pdf)
| 100 | 1200.00 | €20,212 | Virtuoso 07.50.3213 [v7fasttrack](https://github.com/v7fasttrack/virtuoso-opensource) | 2*Xeon2630 6-core 2.4GHz, 192GB RAM | [OpenLink Software](http://www.openlinksw.com) | 2015/04/27 | [Full Disclosure Report](LDBC_SNB_I_20150427_SF100_virtuoso.pdf)
| 100 | 81.70 | €37,927 | Sparksee 5.1.1 | 2\*Xeon 2630v3 8-core 2.4GHz, 256GB RAM |[Sparsity Technologies SA](http://www.sparsity-technologies.com) |2015/04/27 | [Full Disclosure Report](LDBC_SNB_I_20150427_SF100_sparksee.pdf)
| 300 | 635 | €20,212 | Virtuoso 07.50.3213 [v7fasttrack](https://github.com/v7fasttrack/virtuoso-opensource) | 2*Xeon2630 6-core 2.4GHz, 192GB RAM | [OpenLink Software](http://www.openlinksw.com) | 2015/04/27 | [Full Disclosure Report](LDBC_SNB_I_20150427_SF300_virtuoso.pdf)

