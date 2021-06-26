---
type: post
title: "SNB Data Generator - Getting Started"
author: Arnau Prat
# optional link to homepage of autor
# author_url: 
# short comment shon below author/date
# short_comment:
date: 2014-10-09
tags: [datagen, snb, social network benchmark, social network]
# please make sure to remove image parameter if unused
# image: "post/snb-data-generator-getting-started/featured.png" 
---

In previous posts ([this](../datagen-data-generation-for-the-social-network-benchmark) and [this](../getting-started-with-snb)) we briefly introduced the design goals and philosophy behind DATAGEN, the data generator used in LDBC-SNB. In this post, I will explain how to use DATAGEN to generate the necessary datatsets to run LDBC-SNB. Of course, as DATAGEN is continuously under development,  the instructions given in this tutorial might change in the future.

### Getting and Configuring Hadoop

DATAGEN runs on top of hadoop 1.2.1  to be scale. You can download it from here. Open a console and type the following commands to decompress hadoop into /home/user folder:

```bash
$ cd /home/user
$ tar xvfz hadoop-1.2.1.tar.gz
```

For simplicity, in this tutorial we will run DATAGEN in standalone mode, that is, only one machine will be used, using only one thread at a time to run the mappers and reducers. This is the default configuration, and therefore anything else needs to be done for configuring it. For other configurations, such as Pseudo-Distributed (multiple threads on a single node) or Distributed (a cluster machine), visit the [LDBC DATAGEN wiki](https://github.com/ldbc/ldbc_snb_datagen_hadoop/wiki/Configuration).

### Getting and configuring DATAGEN

Before downloading DATAGEN, be sure to fulfill the following requirements:

 * Linux based machine
 * java 1.6 or greater
 * python 2.7.X
 * maven 3

After configuring hadoop, now is the time to get DATAGEN from the LDBC-SNB official repositories. Always download the latest release, which at this time is v0.1.2. Releases page is be found [here](https://github.com/ldbc/ldbc_snb_datagen_hadoop/releases). Again, decompress the downloaded file with the following commands:

```bash
$ cd /home/user
$ tar xvfz ldbc_snb_datagen-0.1.2.tar.gz
```


This will create a folder called “ldbc_snb_datagen-0.1.2”.

DATAGEN provides a *run.sh* is a script to automate the compilation and execution of DATAGEN. It needs to be configured for your environment, so open it and set the two variables at the top of the script to the corresponding paths.

```
HADOOP_HOME=/home/user/hadoop-1.2.1
LDBC_SNB_DATAGEN_HOME=/home/user/ldbc_snb_datagen
```

HADOOP_HOME points to the path where hadoop-1.2.1 is installed, while LDBC_SNB_DATAGEN_HOME points to where DATAGEN is installed. Change these variables to the appropriate values. Now, we can execute *run.sh* script to compile and execute DATAGEN using default parameters. Type the following commands:

```bash
$ cd /home/user/ldbc_snb_datagen-0.1.2
$ ./run.sh
```


This will run DATAGEN, and two folders will be created at the same directory: *social_network* containing the scale factor 1 dataset with csv uncompressed files, and *substitution_parameters* containing the substituion parameters needed by the driver to execute the benchmark.

### Changing the generated dataset

The characteristics of the dataset to be generated are specified in the *params.ini* file. By default, this file has the following content:

```
scaleFactor:1
compressed:false
serializer:csv
numThreads:1
```

The following is the list of options and their default values supported by DATAGEN:

| Option        | Default value | Description                                                                                                                            | 
|---------------|---------------|----------------------------------------------------------------------------------------------------------------------------------------| 
| scaleFactor   | 1             | "The scale factor of the data to generate. Possible values are: 1, 3, 10, 30, 100, 300 and 1000"                                       | 
| serializer    | csv           | "The format of the output data. Options are: csv, csv_merge_foreign, ttl"                                                              | 
| compressed    | FALSE         | Specifies to compress the output data in gzip.                                                                                         | 
| outputDir     | ./            | Specifies the folder to output the data.                                                                                               | 
| updateStreams | FALSE         | "Specifies to generate the update streams of the network. If set to false, then the update portion of the network is output as static" | 
| numThreads    | 1             | Sets the number of threads to use. Only works for pseudo-distributed mode                                                              | 


For instance, a possible *params.ini* file could be the following:

```
scaleFactor:30
serializer:ttl
compressed:true
updateStreams:false
outputDir:/home/user/output
numThreads:4
```

For those not interested on generating a dataset for a given predefined scale factor, but for other applications, the following parameters can be specified (they need to be specified all together):

| Option     | Default value | Description                       | 
|------------|---------------|-----------------------------------| 
| numPersons | -             | The number of persons to generate | 
| numYears   | -             | The amount of years of activity   | 
| startYear  | -             | The start year of simulation.     | 

The following is an example of another possible *params.ini* file

```
numPersons:100000
numYears:3
startYear:2010
serializer:csv_merge_foreign
compressed:false
updateStreams:true
outputDir:/home/user/output
numThreads:4
```

For more information about the schema of the generated data, the different scale factors and serializers, please visit the wiki page of DATAGEN at [GitHub](https://github.com/ldbc/ldbc_snb_datagen_hadoop/)!
