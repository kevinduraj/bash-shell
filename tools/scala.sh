#!/bin/sh
exec scala "$0" "$@"
!#

import sys.process._

var set = scala.collection.mutable.Set[Int]()
set += 1
set += 2
set += 3
set += 4
set += 5
set += 3
set.foreach(println)

