---
type: post
title: "Elements of Instance Matching Benchmarks: a Short Overview"
author: Irini Fundulaki
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
#short_comment:
date: 2015-06-16
tags: ["instance", "matching", "benchmarks", "SPB"]
---

The number of datasets published in the Web of Data as part of the
Linked Data Cloud is constantly increasing. The Linked Data paradigm is
based on the unconstrained publication of information by different
publishers, and the interlinking of web resources through “same-as”
links which specify that two URIs correspond to the same real world
object. In the vast number of data sources participating in the Linked
Data Cloud, this information is not explicitly stated but is discovered
using __instance matching__ techniques and tools. Instance matching is
also known as __record linkage__ [[1]], __duplicate detection__
[[2]](#references), __entity resolution__ [[3]](#references) and __object
identification__ [[4]](#references).

For instance, a search in Geonames
(http://www.geonames.org/) for "Athens" would
return a resource (i.e., URI) accompanied with a map of the area and
information about the place; additional information for the city of
Athens can be found in other datasets such as for instance DBpedia
(http://dbpedia.org/) or Open Government Datasets (http://data.gov.gr/).
To exploit all obtain all necessary information about the city of Athens
we need to establish that the retrieved resources refer to the same real
world object.

Web resources are published by "autonomous agents" who choose their
preferred information representation or the one that best fits the
application of interest. Furthermore, different representations of the
same real world entity are due to data acquisition errors or different
acquisition techniques used to process scientific data. Moreover, real
world entities evolve and change over time, and sources need to keep
track of these developments, a task that is very hard and often not
possible. Finally, when integrating data from multiple sources, the
process itself may add new erroneous data. Clearly, these reasons are
not limited to problems that did arise in the era of Web Data, it is
thus not surprising that instance matching systems have been around for
several years [[2]](#references)[[5]](#references).

It is though essential at this point to develop, along with instance and
entity matching systems, _instance matching benchmarks to determine the
weak and strong points of those systems, as well as their overall
quality in order to support users in deciding the system to use for
their needs_. Hence, well defined, and good quality benchmarks are
important for comparing the performance of the available or under
development instance matching systems. Benchmarks are used not only to
inform users of the strengths and weaknesses of systems, but also to
motivate developers, researchers and technology vendors to deal with the
weak points of their systems and to ameliorate their performance and
functionality. They are also useful for identifying the settings in
which each of the systems has optimal performance. Benchmarking aims at
providing an objective basis for such assessments.

An instance matching benchmark for Linked Data consists of a _source_
and _target dataset_ implementing a set of _test-cases_, where each test
case addresses a different kind of requirement regarding instance
matching, a _ground truth_ or _gold standard_ and finally the
_evaluation metrics_ used to _assess the benchmark._

Datasets are the raw material of a benchmark. A benchmark comprises of a
_source_ and _target_ dataset and the objective of an instance matching
system is to discover the matches of the two. Datasets are characterized
by (a) their _nature_ (_real_ or _synthetic_), (b) the
_schemas/ontologies_ they use,  (c) their _domains_,  (d) the
_languages_ they are written in, and (e) the
_variations/heterogeneities_ of the datasets. Real datasets are widely
used in benchmarks since they offer realistic conditions for
heterogeneity problems and they have realistic distributions. _Synthetic
datasets_ are generated using automated data generators and  are useful
because they offer fully controlled test conditions, have accurate gold
standards and allow setting the focus on specific types of heterogeneity
problems in a systematic manner

Datasets (and benchmarks) may contain different _kinds of variations_
that correspond to _different test cases_. According to Ferrara et.al.
[[6]](#references)[[7]](#references), three kinds of variations exist for Linked
Data, namely _data variations_, _structural variations_ and _logical
variations_. The first refers mainly to differences due to typographical
errors, differences in the employed data formats, language etc. The
second refers to the differences in the structure of the employed Linked
Data schemas. Finally, the third  type derives from the use of
semantically rich RDF and OWL constructs that enable one to define
hierarchies and equivalence of classes and properties, (in)equality of
instances, complex class definitions through union and intersection
among others.

The common case in real benchmarks is that the datasets to be matched
contain different kinds (combinations) of variations. On the other hand,
synthetic datasets may be purposefully designed to contain specific
types (or combinations) of variations (e.g., only structural), or may be
more general in an effort to illustrate all the common cases of
discrepancies that appear in reality between individual descriptions.

The _gold standard_ is considered as the “correct answer sheet” of the
benchmark, and is used to judge the completeness and soundness of the
result sets of the benchmarked systems. For instance matching benchmarks
employing synthetic datasets, the gold standard is always automatically
generated, as the errors (variations) that are added into the datasets
are known and systematically created. When it comes to real datasets,
the gold standard can be either manually curated or (semi-)
automatically generated. In the first case, domain experts manually mark
the matches between the datasets, whereas in the second, supervised and
crowdsourcing techniques aid the process of finding the matches, a
process that is often time consuming and error prone.

Last, an instance matching benchmark uses _evaluation metrics_ to
determine and assess the systems’ output quality and performance. For
instance matching tools, performance is not a critical aspect.  On the
other hand, an instance matching tool should return all and only the
correct answers. So, what matters most is returning the relevant
matches, rather than returning them quickly. For this reason, the
evaluation metrics that are dominantly employed for instance matching
benchmarks are the standard _precision_, _recall_ and _f-measure_
metrics.

#### References

[1] Li, C., Jin, L., and Mehrotra, S. (2006) Supporting efficient
record linkage for large data sets using mapping techniques. WWW 2006.

[2] Dragisic, Z., Eckert, K., Euzenat, J., Faria, D., Ferrara, A.,
Granada, R., Ivanova, V.,Jimenez-Ruiz, E., Oskar Kempf, A., Lambrix, P.,
Montanelli, S., Paulheim, H., Ritze, D., Shvaiko, P., Solimando, A.,
Trojahn, C., Zamaza, O., and Cuenca Grau,  B. (2014) Results of the
Ontology Alignment Evaluation Initiative 2014. Proc. 9th ISWC workshop
on ontology matching (OM 2014).

[3] Bhattacharya, I. and Getoor, L. (2006) Entity resolution in
graphs. Mining Graph Data. Wiley and Sons 2006.

[4] Noessner, J., Niepert, M., Meilicke, C., and Stuckenschmidt,
H. (2010) Leveraging Terminological Structure for Object Reconciliation.
In ESWC 2010.

[5] Flouris, G., Manakanatas, D., Kondylakis, H., Plexousakis, D.,
Antoniou, G. Ontology Change: Classification and Survey (2008) Knowledge
Engineering Review (KER 2008), pages 117-152.

[6] Ferrara, A., Lorusso, D., Montanelli, S., and Varese, G.
(2008) Towards a Benchmark for Instance Matching. Proc. 3th ISWC
workshop on ontology matching (OM 2008).

[7] Ferrara, A., Montanelli, S., Noessner, J., and Stuckenschmidt,
H. (2011) Benchmarking Matching Applications on the Semantic Web. In
ESWC, 2011.
