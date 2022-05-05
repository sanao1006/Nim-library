# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

include lib_in,lib_graph,module


suite "graph":
  setup:
    var 
      arr:Edge = @[@[1,2],@[2,3]]
      n:int = 3
      m:int = 2
    var k = Graph(edges:newSeqWith(n,newSeqWith(2,0)))
  test "initUG":
    k.edges =  @[ @[1], @[0,2], @[1] ] 
    check(arr.initUG(n,m).edges == k.edges)