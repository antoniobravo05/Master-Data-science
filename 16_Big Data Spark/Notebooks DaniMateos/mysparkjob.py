from __future__ import print_function
from pyspark import SparkContext
import sys

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: mysparkjob arg1 arg2 ", file=sys.stderr)
        exit(-1)
    sc = SparkContext(appName="MyTestJob")
    dataTextAll = sc.textFile(sys.argv[1])
    dataRDD = dataTextAll.filter(lambda line: line.startswith('79065'))
    dataRDD.saveAsTextFile(sys.argv[2])
    sc.stop()
