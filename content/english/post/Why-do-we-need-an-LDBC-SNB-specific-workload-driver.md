---
type: post
title: "Why Do We Need an LDBC SNB-Specific Workload Driver?"
author: Alex Averbuch
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2015-04-21
tags: [snb, Driver]
# please make sure to remove image parameter if unused
# image: "post/why-do-we-need-an-ldbc-snb-specific-workload-driver/featured.png" 
---

In a previous [3-part blog series](/tags/driver) we touched upon the difficulties of executing the LDBC SNB
Interactive (SNB) workload, while achieving good performance and
scalability. What we didn't discuss is why these difficulties were
unique to SNB, and what aspects of the way we perform workload execution
are scientific contributions - novel solutions to previously unsolved
problems. This post will highlight the differences between SNB and more
traditional database benchmark workloads. Additionally, it will motivate
why we chose to develop a new workload driver as part of this work,
rather than using existing tooling that was developed in other database
benchmarking efforts. To briefly recap, the task of the driver is to run
a transactional database benchmark against large synthetic graph
datasets - "graph" is the word that best captures the novelty and
difficulty of this work.

**Workload Execution - Traditional vs Graph**

Transactional graph workloads differ from traditional relational
workloads in several fundamental ways, one of them being the complex
dependencies that exist between queries of a graph workload.

To understand what is meant by "traditional relational workloads", take
the classical TPC-C benchmark as an example. In TPC-C Remote Terminal
Emulators (emulators) are used to issue update transactions in parallel,
where the transactions issued by these emulators do not depend on one
another. Note, "dependency" is used here in the context of scheduling,
i.e., one query is dependent on another if it can not start until the
other completes. For example, a New-Order transaction does not depend on
other orders from this or other users. Naturally, the results of
Stock-Level transactions depend on the items that were previously sold,
but in TPC-C it is not an emulator's responsibility to enforce any such
ordering. The scheduling strategy employed by TPC-C is tailored to the
scenario where transactional updates do not depend on one another. In
reality, one would expect to also have scheduling dependencies between
transactions, e.g., checking the status of the order should only be done
after the order is registered in the system.  TPC-C, however, does not
do this and instead only asks for the status of the last order _for a
given user_. Furthermore, adding such dependencies to TPC-C would make
scheduling only slightly more elaborate. Indeed, the Load Tester (LT)
would need to make sure a New-Order transaction always precedes the read
requests that check its status, but because users (and their orders) are
partitioned across LTs, and orders belong to a particular user, this
scheduling does not require inter-LT communication.

A significantly more difficult scheduling problem arises when we
consider the SNB benchmark that models a real-world social network. Its
domain includes users that form a social friendship graph and which
leave posts/comments/likes on each others walls (forums). The update
transactions are generated (exported as a log) by the data generator,
with assigned timestamps, e.g. user 123 added post 456 to forum 789 at
time T. Suppose we partition this workload by user, such that each
driver gets all the updates (friendship requests, posts, comments and
likes on other user's posts etc) initiated by a given user. Now, if the
benchmark is to resemble a real-world social network, the update
operations represent a highly connected (and dependent) network: a user
should not create comments before she joins the network, a friendship
request can not be sent to a non-existent user, a comment can only be
added to a post that already exists, etc. Given a user partitioning
scheme, most such dependencies would cross the boundaries between driver
threads/processes, because the correct execution of update operations
requires that the social network is in a particular state, and that
state depends on the progress of other threads/processes.

Such scheduling dependencies in the SNB workload essentially replicate
the underlying graph-like shape of its dataset. That is, every time a
user comments on a friend's wall, for example, there is a dependency
between two operations that is captured by an edge of the social
graph. _Partitioning the workload among the LTs therefore becomes
equivalent to graph partitioning, a known hard problem._

 

**Because it's a graph**

In short, unlike previous database benchmarking efforts, the SNB
workload has necessitated a redefining of the state-of-the-art in
workload execution. It is no longer sufficient to rely solely on
workload partitioning to safely capture inter-query dependencies in
complex database benchmark workloads. The graph-centric nature of SNB
introduces new challenges, and novel mechanisms had to be developed to
overcome these challenges. To the best of our knowledge, the LDBC SNB
Interactive benchmark is the first benchmark that requires a non-trivial
partitioning of the workload, among the benchmark drivers. In the
context of workload execution, our contribution is therefore the
principled design of a driver that executes dependent update operations
in a performant and scalable way, across parallel/distributed LTs, while
providing repeatable, vendor-independent execution of the benchmark.
