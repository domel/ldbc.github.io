---
title: "LDBC Social Network Benchmark (LDBC-SNB)"
aliases: [
    "/benchmark-snb/",
    "/developer/snb"
]
type: generic
---

The Social Network Benchmark suite defines graph workloads targeting database management systems.
The benchmark suite consists of two distinct benchmarks on a common dataset, since there are **two different workloads**.
Each workload produces a single metric for performance at the given
scale and a price/performance metric at the scale.  The full
disclosure further breaks down the composition of the metric into its
constituent parts, e.g. single query execution
times.

- **The Social Network Benchmark\'s Interactive workload** is focusing on transactional graph processing with complex read queries that access the neighbourhood of a given node in the graph and update operations that continuously insert new data in the graph.
- **The Social Network Benchmark\'s Business Intelligence workload** is focusing on aggregation- and join-heavy complex queries touching a large portion of the graph with microbatches of insert/delete operations. This workload is not yet finalized.

#### Social Network Benchmark Interactive audited results

##### TuGraph

TuGraph was audited in July 2020. TuGraph is owned by the [Ant Group](https://www.antgroup.com/en) now.


| **SF** | **Throughput (ops/sec)** | **Cost** | **Software** | **Hardware** | **Test Sponsor** | **Date** | **SNB version** | **Full Disclosure Report** |
|--------|--------------------------|----------|--------------|--------------|------------------|----------|-----------------|----------------------------|
|30 | 5,436.47 |  $280,650 | [TuGraph 1.10](https://fma-ai.cn/) | AWS r5d.12xlarge instance, 48\*Intel Xeon Platinum 8175M @ 2.5GHz, 374GB RAM | [FMA](https://fma-ai.cn/) | 2020/07/26 | [v0.3.2](https://arxiv.org/pdf/2001.02299v1.pdf) | [Full Disclosure Report](LDBC_SNB_I_20200726_SF30-100-300_tugraph.pdf)
|100 | 5,010.77 | $280,650 | [TuGraph 1.10](https://fma-ai.cn/) | AWS r5d.12xlarge instance, 48\*Intel Xeon Platinum 8175M @ 2.5GHz, 374GB RAM | [FMA](https://fma-ai.cn/) | 2020/07/26 | [v0.3.2](https://arxiv.org/pdf/2001.02299v1.pdf) | [Full Disclosure Report](LDBC_SNB_I_20200726_SF30-100-300_tugraph.pdf)
|300 | 4,855.52 | $280,650 | [TuGraph 1.10](https://fma-ai.cn/) | AWS r5d.12xlarge instance, 48\*Intel Xeon Platinum 8175M @ 2.5GHz, 374GB RAM | [FMA](https://fma-ai.cn/) | 2020/07/26 | [v0.3.2](https://arxiv.org/pdf/2001.02299v1.pdf) | [Full Disclosure Report](LDBC_SNB_I_20200726_SF30-100-300_tugraph.pdf)

Supplementary material for the TuGraph audits:

-  [Executive summary](LDBC_SNB_I_20200726_SF30-100-300_tugraph-executive_summary.pdf)
-  [Signatures](LDBC_SNB_I_20200726_SF30-100-300_tugraph-signatures.pdf)
-  [Attachments](https://drive.google.com/file/d/198UrkL7_vduOm5MTneVniiYBG8U2a8x9/view?usp=sharing)

#### Legacy audited results

[Social Network Benchmark Interactive, version 0.2.2](/benchmarks/snb/audited-results-v0.2.2)
