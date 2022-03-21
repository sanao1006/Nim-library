import strformat, macros, std/algorithm, tables, sets, lists,
    intsets, critbits, sequtils, strutils, std/math, times,
    sugar, options, deques, bitops, heapqueue, future

proc g(): string = stdin.readLine
proc gin(): int = g().parseInt
proc gints(): seq[int] = g().split.map(parseInt)
proc gintsn(n:int): seq[int] = 
  var sequence:seq[int] = @[]
  for i in 0..n-1:
    var input = gin()
    add(sequence, input)
  return sequence


proc makeSeqInt(n:int,m:int):seq[int] = 
  var sequence : seq[int] = @[]
  for i in 0..<n:
    add(sequence, m)
  return sequence

proc makeSeqStr(n:int,m:string):seq[string] = 
  var sequence : seq[string] = @[]
  for i in 0..<n:
    add(sequence, m)
  return sequence

proc makeSeqBool(n:int,m:bool):seq[bool] = 
  var sequence : seq[bool] = @[]
  for i in 0..<n:
    add(sequence, m)
  return sequence

proc si(s: int): int =
  result = 0
  for i in s.intToStr:
    result += parseInt($i)
 
# newSeq[seq[int]]()
# main処理
var 
  n=gin()
  query = newSeq[seq[int]]()
  judge:bool = true
add(query,@[0,0,0])
for i in 0..<n:
  var input = gints()
  add(query, input)

for i in 0..<n:
  var
     dis = abs(query[i+1][1] - query[i][1])+abs(query[i+1][2] - query[i][2])
     dt = query[i+1][0]-query[i][0]
  if dis > dt:judge = false
  if(dis mod 2 != dt mod 2):judge = false

if (judge):
  echo("Yes")
else:
  echo("No")
