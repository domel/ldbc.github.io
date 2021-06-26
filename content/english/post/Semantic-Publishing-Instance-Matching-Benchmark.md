---
type: post
title: "Semantic Publishing Instance Matching Benchmark"
author: Irini Fundulaki
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-12-30
tags: [instance matching, benchmark]
# please make sure to remove image parameter if unused
# image: "post/semantic-publishing-instance-matching-benchmark/featured.png" 
---

The Semantic Publishing Instance Matching Benchmark (SPIMBench) is a novel benchmark for the assessment of instance matching techniques for RDF data with an associated schema. SPIMBench extends the state-of-the art instance matching benchmarks for RDF data in three main aspects: it allows for systematic scalability testing, supports a wider range of test cases including semantics-aware ones, and provides an enriched gold standard.

The SPIMBench test cases provide a systematic way for testing the performance of instance matching systems in different settings. SPIMBench supports the types of test cases already adopted by existing instance matching benchmarks:

* value-based test cases based on applying value transformations (e.g., blank character addition and deletion, change of date format, abbreviations, synonyms) on triples relating to given input entity
* structure-based test cases characterized by a structural transformation (e.g., different nesting levels for properties, property splitting, aggregation)

The novelty of SPIMBench lies in the support for the following semantics-aware test cases defined on the basis of OWL constructs:

* instance (in)equality (owl:sameAs, owl:differentFrom)
* class and property equivalence (owl:equivalentClass, owl:equivalentProperty)
* class and property disjointness (owl:disjointWith, owl:AllDisjointClasses, owl:propertyDisjointWith, owl:AllDisjointProperties)
* class and property hierarchies (rdfs:subClassOf, rdfs:subPropertyOf)
* property constraints (owl:FunctionalProperty, owl:InverseFunctionalProperty)
* complex class definitions (owl:unionOf, owl:intersectionOf)

SPIMBench uses and extends the ontologies of LDBC's Semantic Publishing Benchmark (SPB) to tackle the more complex schema constructs expressed in terms of OWL. It also extends SPB's data generator to first generate a synthetic source dataset that does not contain any matches, and then to generate matches and non-matches to entities of the source dataset to address the supported transformations and OWL constructs. The data generation process allows the creation of arbitrary large datasets, thus supporting the evaluation of both the scalability and the matching quality of an instance matching system.

Value and structure-based test cases are implemented using the SWING framework [[1]](#references) on data and object type properties respectively. These are produced by applying the appropriate transformation(s) on a source instance to obtain a target instance. Semantics-based test cases are produced in the same way as with the value and structure-based test cases with the difference that appropriate triples are constructed and added in the target dataset to consider the respective OWL constructs.

SPIMBench, in addition to the semantics-based test cases that differentiate it from existing instance matching benchmarks, also offers a weighted gold standard used to judge the quality of answers of instance matching systems. It contains generated matches (a pair consisting of an entity of the source dataset and an entity of the target dataset) the type of test case it represents, the property on which a transformation was applied (in the case of value-based and structure-based test cases), and a weight that quantifies how easy it is to detect this match automatically. SPIMBench adopts an information-theoretical approach by applying multi-relational learning to compute the weight of the pair of matched instances by measuring the information loss that results from applying transformations to the source data to generate the target data. This detailed information, which is not provided by state of the art benchmarks, allows users of SPIMBench (e.g., developers of IM systems) to more easily identify the reasons underlying the performance results obtained using SPIMBench and thereby supports the debugging of instance matching systems.

SPIMBench can be downloaded from [our repository](https://github.com/jsaveta/SPIMBench) and a more thorough description thereof can be found on http://www.ics.forth.gr/isl/spimbench/.

#### References 

[1] A. Ferrara, S. Montanelli, J. Noessner, and H. Stuckenschmidt. Benchmarking Matching Applications on the Semantic Web. In ESWC, 2011.
