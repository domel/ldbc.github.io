---
type: post
title: "Getting Started With the Semantic Publishing Benchmark"
author: Irini Fundulaki
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-11-09
tags: [spb, sparql]
# please make sure to remove image parameter if unused
# image: "post/getting-started-with-the-semantic-publishing-benchmark/featured.png" 
---


The Semantic Publishing Benchmark (SPB), developed in the context of
LDBC, aims at measuring the read and write operations that can be
performed in the context of a media organisation. It simulates the
management and consumption of RDF metadata describing media assets and
creative works. The scenario is based around a media organisation that
maintains RDF descriptions of its catalogue of creative works. These
descriptions use a set of ontologies proposed by BBC that define
numerous properties for content; they contain asll RDFS schema
constructs and certain OWL ones.

The benchmark proposes a data generator that uses the ontologies
provided by BBC and reference datasets (again provided by BBC) to
produce a set of valid instances; it works with a predefined set of
distributions derived from the reference datasets. In addition to these
distributions, the data generator also models:

* clustering of creative works around certain entities from the
reference datasets (e.g. the association of an entity with creative
works would decay exponentially in time)
* correlations between entities -  there will be creative works about
two entities for a certain period in time, that way a history of
interactions is also modelled (e.g. J. Biden and B. Obama are tagged in
creative works for a continuous period in time)

The driver proposed by the benchmark measures the performance of CRUD
operations of a SPARQL endpoint by starting a number of concurrently
running editorial and aggregation agents. The former executes a series
of insert, update and delete operations, whereas the latter a set of
construct, describe, and select queries on a SPARQL endpoint. The
benchmark can access all SPARQL endpoints that support the SPARQL 1.1
protocol. Tests have been run on OWLIM and Virtuoso. Attempts were also
made for Stardog.

Currently, the benchmark offers two workloads: a base version that
consists of a mix of nine queries of different complexity that consider
nearly all the features of SPARQL 1.1 query language including sorting,
subqueries, limit,  regular expressions and grouping. The queries aim at
checking different choke points relevant to query optimisation such as:

* join ordering based on cardinality constraints - expressed by the
different kinds of properties defined in the schema
* subselects that aggregate the query results that
the optimiser should recognise and evaluate first
* optional and nested optional clauses where the optimiser is called to
produce a plan where the execution of the optional triple patterns
is performed last
* reasoning along the RDFS constructs (subclass, subproperty
hierarchies, functional, object and transitive properties etc.)
* unions to be executed in parallel
* optionals that contain filter expressions that should be executed
as early as possible in order to eliminate intermediate results
* ordering where the optimiser could consider the possibility to choose
query plan(s) that facilitate the ordering of results
* handling of geo-spatial predicates
* full-text search optimisation
* asynchronous execution of the aggregate sub-queries
* use of distinct to choose the optimal query plan



We give below Query 1 of the Semantic Publishing Benchmark.

```
PREFIX bbcevent:<http://www.bbc.co.uk/ontologies/event/>
PREFIX geo-pos:<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX bbc:<http://www.bbc.co.uk/ontologies/bbc/>
PREFIX time:<http://www.w3.org/2006/time#>
PREFIX event:<http://purl.org/NET/c4dm/event.owl#>
PREFIX music-ont:<http://purl.org/ontology/mo/>
PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf:<http://xmlns.com/foaf/0.1/>
PREFIX provenance:<http://www.bbc.co.uk/ontologies/provenance/>
PREFIX owl:<http://www.w3.org/2002/07/owl#>
PREFIX cms:<http://www.bbc.co.uk/ontologies/cms/>
PREFIX news:<http://www.bbc.co.uk/ontologies/news/>
PREFIX cnews:<http://www.bbc.co.uk/ontologies/news/cnews/>
PREFIX cconcepts:<http://www.bbc.co.uk/ontologies/coreconcepts/>
PREFIX dbp-prop:<http://dbpedia.org/property/>
PREFIX geonames:<http://sws.geonames.org/>
PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
PREFIX domain:<http://www.bbc.co.uk/ontologies/domain/>
PREFIX dbpedia:<http://dbpedia.org/resource/>
PREFIX geo-ont:<http://www.geonames.org/ontology#>
PREFIX bbc-pont:<http://purl.org/ontology/po/>
PREFIX tagging:<http://www.bbc.co.uk/ontologies/tagging/>
PREFIX sport:<http://www.bbc.co.uk/ontologies/sport/>
PREFIX skosCore:<http://www.w3.org/2004/02/skos/core#>
PREFIX dbp-ont:<http://dbpedia.org/ontology/>
PREFIX xsd:<http://www.w3.org/2001/XMLSchema#>
PREFIX core:<http://www.bbc.co.uk/ontologies/coreconcepts/>
PREFIX curric:<http://www.bbc.co.uk/ontologies/curriculum/>
PREFIX skos:<http://www.w3.org/2004/02/skos/core#>
PREFIX cwork:<http://www.bbc.co.uk/ontologies/creativework/>
PREFIX fb:<http://rdf.freebase.com/ns/>

# Query Name : query1
# Query Description :
# Retrieve creative works about thing t (or that mention t)
# reasoning: rdfs:subClassOf, rdf:type
# join ordering: cwork:dateModified rdf:type owl:FunctionalProperty
# join ordering: cwork:dateCreated rdf:type owl:FunctionalProperty
# Choke Points :
# - join ordering based on cardinality of functional proerties cwork:dateCreated, cwork:dateModified
# Optimizer should use an efficient cost evaluation method for choosing the optimal join tree
# - A sub-select which aggregates results. Optimizer should recognize it and execute it first
# - OPTIONAL and nested OPTIONAL clauses (treated by query optimizer as nested sub-queries)
# Optimizer should decide to put optional triples on top of the join tree
# (i.e. delay their execution to the last possible moment) because OPTIONALs are treated as a left join
# - qiery optimizer has the chance to recognize the triple pattern : ?cWork a ?type . ?type rdfs:subClassOf cwork:CreativeWork
# and eliminate first triple (?cwork a ?type .) since ?cwork is a cwork:CreativeWork​

CONSTRUCT {
  ?creativeWork a cwork:CreativeWork ;
   a ?type ;
   cwork:title ?title ;
   cwork:shortTitle ?shortTitle ;
   cwork:about ?about ;
   cwork:mentions ?mentions ;
   cwork:dateCreated ?created ;
   cwork:dateModified ?modified ;
   cwork:description ?description ;
   cwork:primaryFormat ?primaryFormat ;
   bbc:primaryContentOf ?webDocument .
  ?webDocument bbc:webDocumentType ?webDocType .
  ?about rdfs:label ?aboutLabel ;
   bbc:shortLabel ?aboutShortLabel ;
   bbc:preferredLabel ?aboutPreferredLabel .
  ?mentions rdfs:label ?mentionsLabel ;
   bbc:shortLabel ?mentionsShortLabel ;
   bbc:preferredLabel ?mentionsPreferredLabel .
  ?creativeWork cwork:thumbnail ?thumbnail .
  ?thumbnail a cwork:Thumbnail ;
   cwork:altText ?thumbnailAltText ;
   cwork:thumbnailType ?thumbnailType .
}
WHERE {
  {
   SELECT ?creativeWork
    WHERE {
        ?creativeWork {{{cwAboutOrMentions}}} {{{cwAboutOrMentionsUri}}} .
        ?creativeWork a cwork:CreativeWork ;
        cwork:dateModified ?modified .
     }
    ORDER BY DESC(?modified)
    LIMIT 10
  }
  ?creativeWork a cwork:CreativeWork ;
         a ?type ;
         cwork:title ?title ;
         cwork:dateModified ?modified .
  OPTIONAL { ?creativeWork cwork:shortTitle ?shortTitle . }
  OPTIONAL { ?creativeWork cwork:description ?description . }
  OPTIONAL { ?creativeWork cwork:about ?about .
        OPTIONAL { ?about rdfs:label ?aboutLabel . }
        OPTIONAL { ?about bbc:shortLabel ?aboutShortLabel . }
        OPTIONAL { ?about bbc:preferredLabel ?aboutPreferredLabel . }
     }
  OPTIONAL {
         ?creativeWork cwork:mentions ?mentions .
         OPTIONAL { ?mentions rdfs:label ?mentionsLabel . }
         OPTIONAL { ?mentions bbc:shortLabel ?mentionsShortLabel . }
         OPTIONAL { ?mentions bbc:preferredLabel ?mentionsPreferredLabel . }
     }
   OPTIONAL { ?creativeWork cwork:dateCreated ?created . }
   OPTIONAL { ?creativeWork cwork:primaryFormat ?primaryFormat . }
   OPTIONAL { ?webDocument bbc:primaryContent ?creativeWork .
        OPTIONAL { ?webDocument bbc:webDocumentType ?webDocType . }
  }
  OPTIONAL { ?creativeWork bbc:primaryContentOf ?webDocument .
        OPTIONAL { ?webDocument bbc:webDocumentType ?webDocType . }
  }
  OPTIONAL { ?creativeWork cwork:thumbnail ?thumbnail .
        OPTIONAL { ?thumbnail cwork:altText ?thumbnailAltText . }
        OPTIONAL { ?thumbnail cwork:thumbnailType ?thumbnailType . }
  }
}


```

Listing 1. Semantic Publishing Benchmark: Query 1


The benchmark test driver is distributed as a jar file, but can also be built using an ant script. It is distributed with the BBC ontologies and reference datasets, the queries and update workloads discussed earlier and the configuration parameters for running the benchmark and for generating the data. It is organised in the following different phases: ontology loading and reference dataset loading, dataset generation and loading, warm up (where a series of aggregation queries are run for a predefined amount of time), benchmark where all queries (aggregation and editorial) are run, conformance checking (that allows one to check whether the employed RDF engine implements OWL reasoning) and finally cleanup that removes all the data from the repository. The benchmark provides a certain degree of freedom where each phase can run independently of the others.

The data generator uses an RDF repository to load ontologies and reference datasets; actually, any system that will be benchmarked should have those ontologies loaded.  Any repository that will be used for the data generation should be set up with context indexing, and finally geo-spatial indexing, if available, to serve the spatial queries. The current version of the benchmark has been tested with Virtuoso and OWLIM.

The generator uses configuration files that must be configured appropriately to set the values regarding the dataset size to produce, the number of aggregation and editorial agents, the query time out etc. The distributions used by the data generator could also be edited. The benchmark is very simple to run (once the RDF repository used to store the ontologies and the reference datasets is set up, and the configuration files updated appropriately) using the command: java -jar semantic_publishing_benchmark-*.jar test.properties. The benchmark produces three kinds of files that contain (a) brief information about each executed query, the size of the returned result, and the execution time (semantic_publishing_benchmark_queries_brief.log), (b) the detailed log of each executed query and its result (semantic_publishing_benchmark_queries_detailed.log) (c)  the benchmark results (semantic_publishing_benchmark_results.log ).

Below we give an example of a run of the benchmark for OWLIM-SE. The benchmark reports the number of edit operations (inserts, updates, and writes) and queries executed at the Nth second of a benchmark run. It also reports that total number of retrieval queries as well as the average number of queries executed per second.


```
Seconds run : 600
        Editorial:
                0 agents

                0 operations (0 CW Inserts, 0 CW Updates, 0 CW Deletions)
                0.0000 average operations per second

        Aggregation:
                8 agents

                298   Q1   queries
                267   Q2   queries
                243   Q3   queries
                291   Q4   queries
                320   Q5   queries
                286   Q6   queries
                255   Q7   queries
                274   Q8   queries
                271   Q9   queries

                2505 total retrieval queries
                4.1750 average queries per second
```

Listing 2. A snippet of semantic_publishing_benchmark_results.log

We run the benchmark under the following configuration: we used 8 aggregation agents for query execution and 4 data generator workers all running in parallel. The warm up period is 120 seconds during which a number of aggregation agents is executed to prepare the tested systems for query execution. Aggregation agents run for a period of 600 seconds, and queries timeout after 90 seconds. We used 10 sets of substitution parameters for each query. For data generation, ontologies and reference datasets are loaded in the OWLIM-SE repository. We used OWLIM-SE,  Version 5.4.6287 with Sesame Version 2.6 and Tomcat Version 6. The results we obtained for the 10M, 100M and 1B triple datasets are given in the table below:


| #triples | Q1  | Q2  | Q3  | Q4  | Q5  | Q6  | Q7  | Q8  | Q9  | #queries | avg. #q. per sec. | 
|----------|-----|-----|-----|-----|-----|-----|-----|-----|-----|----------|--------------------------| 
| 10M      | 298 | 267 | 243 | 291 | 320 | 286 | 255 | 274 | 271 | 2505     | 41,750                 | 
| 100M     | 53  | 62  | 51  | 52  | 44  | 62  | 25  | 55  | 45  | 449      | 7,483                  | 
| 1B       | 34  | 29  | 22  | 24  | 25  | 29  | 0   | 29  | 28  | 220      | 3,667                  | 
