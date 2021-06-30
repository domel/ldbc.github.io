---
type: post
title: "Further Developments in SNB BI Workload"
author: Orri Erling
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-12-18
tags: [snb, bi]
# please make sure to remove image parameter if unused
# image: "post/further-developments-in-snb-bi-workload/featured.png" 
---

We are presently working on the SNB BI workload. Andrey Gubichev of TU Munchen and myself are going through the queries and are playing with two SQL based implementations, one on Virtuoso and the other on Hyper.

As discussed before, the BI workload has the same choke points as TPC-H as a base but pushes further in terms of graphiness and query complexity.

There are obvious marketing applications for a SNB-like dataset.  There  are also security related applications, ranging from fraud detection to intelligence analysis.  The latter category is significant but harder to approach, as much of the detail of best practice is itself not in the open.  In this post, I will outline some ideas discussed over time that might cristallize into a security related section in the SNB BI workload.  We invite comments from practitioners for making the business questions more relevant while protecting  sensitive details.

Let’s look at what scenarios would fit with the dataset.  We have people, different kinds of connections between people,  organizations, places and messages.  Messages (posts/replies), people and organizations are geo-tagged.   Making a finer level of geo-tagging, with actual GPS coordinates, travel itineraries etc, all referring to real places would make the data even more interesting.  The geo dimension will be explored separately in a forthcoming post.

One of the first things to appear when approaching the question isthat the analysis of behavior patterns over time is not easily captured in purely declarative queries.  For example, temporal sequence of events and the quantity and quality of of interactions between players leads to intractably long queries which are hard to understand and debug.  Therefore, views and intermediate materializations become increasingly necessary.

Another feature of the scene is that information is never complete.  Even if logs are complete for any particular system, there are always possible interactions outside of the system.  Therefore we tend to get match scores more then strictly Boolean conditions.  Since everybody is related to everybody else via a relative short path,  the nature and stremgth of the relationship is key to interpreting its significance.

Since a query consisting of scores and outer joins only is difficult to interpret and optimize, and since the information is seldom complete, some blanks may have to be filled in by guesses.  The database must therefore contain metadata about this.

 

An orthogonal aspect to security applications is the access control of the database itself.  One might assume that if a data warehouse of analyzable information is put together, the analyst would have access to the entirety  of it.  This is however not necessarily the case since the information itself and its provenance may fall under different compartments. 

So, let’s see how some of these aspects could be captured in the SNB context.

Geography -  We materialize a table of travel events, so that an unbroken sequence of posts from the same location (e.g. country) other than the residence of the poster forms a travel event.   The posts may have a fine grained position (IP, GPS coordinates of photos) that marks an itinerary.  This is already beyond basicSQL, needing a procedure or  window functions.

The communication between people is implicit in reply threads and forum memberships.  A reply is the closest that one comes to a person to person message in the dataset.  Otherwise all content is posted to forumns with more or less participants.  Membership in a high traffic forum with few participants would indicate a strong connection.   Calculating these time varying connection strengths is a lot of work and a lot of text in queries.  Keeping things simple requires materializing a sparse “adjacency cube,”  i.e. a relation of person1, person2, time bucket -> connection strength.    In the SNB case the connection strength may be derived from reciprocal replies, likes, being in the same forums, knowing each other etc.   Selectivity is important, i.e. being in many small forumns together counts for more than being in ones where everybody else also participates.

The behaviors of people in SNB is not identical from person to person but for the same person follows a  preset pattern.  Suppose a question like “ which person with access to secrets has a marked change of online behavior?”   The change would be starting or stopping  communication with a given set of people, for example.  Think that the spy meets the future spymaster in a public occasion, has a series of exchanges, travels to an atypical destination, then stops all open contact with the spymaster or related individuals.  Patterns like this do not occur in the data but can be introduced easily enough.

In John Le Carre’s A Perfect Spy the main character is caught because it comes to light that his travel routes near always corresponded to his controller’s.   This would make a query.  This could be cast in marketing terms as a “(un)common shopping basket.”  

Analytics becomes prediction when one part of a pattern exists without the expected next stage.  Thus the same query template can serve for detecting full or partial instances of a pattern, depending on how the scores are interpreted.

From a database angle, these questions group on an item with internal structure.  For the shopping basket this is a set. For the travel routes this is an ordered sequence of space/time points, with a match tolerance on the spatial and temporal elements.  Another characteristic is that there is a baseline of expectations and the actual behavior.  Both have structure, e.g. the occupation/location/interest/age of one’s social circle.   These need to be condensed into a sort of metric space and then changes and rates of change can be observed.  Again, this calls for a multidimensional cube to be created as a summary, then algorithms to be applied to this.  The declarative BI query a la TPC-H does not easily capture this all.

This leads us to graph analytics in a broader sense.  Some of the questions addressed here will still fit in the materialized summaries+declarative queries pattern but the more complex summarization and clustering moves towards iterative algorithms. 

There is at present a strong interest in developing graph analytics benchmarks in LDBC.  This is an activity that extends beyond the FP7 project duration and beyond the initial partners.  To this effect I have implemented some SQL extensions for BSP style processing, as hinted at on my blog.  These will be covered in more detail in January, when there are actual experiments.
