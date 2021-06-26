---
type: post
title: "SNB Driver - Part 1"
author: Alex Averbuch
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-11-27
tags: [snb, Driver, TPC-C, SUT]
# please make sure to remove image parameter if unused
# image: "post/snb-driver-part-1/featured.png" 
---

In this multi-part blog we consider the challenge of running the LDBC
Social Network Interactive Benchmark (LDBC SNB) workload in
parallel, i.e. the design of the workload driver that will issue the
queries against the System Under Test (SUT). We go through design
principles that were implemented for the LDBC SNB workload
generator/load tester (simply referred to as driver). Software and
documentation for this driver is available here:
https://github.com/ldbc/ldbc_driver/.
Multiple
reference implementations by two vendors are available here:
https://github.com/ldbc/ldbc_snb_implementations, and
discussion of the schema, data properties, and related content is
available here:
https://github.com/ldbc/ldbc_snb_docs.

The following will concentrate on key decisions and techniques that were
developed to support scalable, repeatable, distributed workload
execution.

 

### Problem Description 

 

The driver generates a stream of operations (e.g. create user, create
post, create comment, retrieve person's posts etc.) and then executes
them using the provided database connector. To be capable of generating
heavier loads, it executes the operations from this stream in parallel.
If there were no dependencies between operations (e.g., reads that
depend on the completion of writes) this would be trivial. This is the
case, for example, for the classical TPC-C benchmark, where splitting
transaction stream into parallel clients (terminals) is
trivial. However, for LDBC SNB Interactive Workload this is not the
case: some operations within the stream do depend on others, others are
depended on, some both depend on others and are depended on, and some
neither depend on others nor are they depended on.

Consider, for example, a Social Network Benchmark scenario, where the
data generator outputs a sequence of events such as User A posted a
picture, User B left a comment to the picture of User A, etc. The
second event depends on the first one in a sense that there is a causal
ordering between them: User B can only leave a comment on the picture
once it has been posted. The generated events are already ordered by
their time stamp, so in case of the single-threaded execution this
ordering is observed by default: the driver issues a request
to the SUT with the first event (i.e., User A posts a picture), after
its completion it issues the second event (create a comment). However,
if events are executed in parallel, these two events may end up in
different parallel sequences of events. Therefore, a driver needs a
mechanism to ensure the dependency is observed even when the dependent
events are in different parallel update streams.

The next blog entries in this series will discuss the approaches used in
the driver to deal with these challenges.
