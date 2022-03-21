import strformat, macros, std/algorithm, tables, sets, lists,
    intsets, critbits, sequtils, strutils, std/math, times,
    sugar, options, deques, bitops, heapqueue, future,std/deques

# 入力テンプレ-------------------------------------------------
proc g(): string = stdin.readLine
proc gin(): int = g().parseInt
template gInts(): seq[untyped] = g().split.map(parseInt)
template gIntsN(n:int): seq[untyped] = 
  var sequence:seq[int] = @[]
  for i in 0..n-1:
    var input = gin()
    add(sequence, input)
  sequence
template gIntsNs(n:int): untyped =
  var sequence:seq[seq[int]] = @[]
  for i in 0..n-1:
    var input = gInts()
    add(sequence, input)
  sequence
template inpuTupple(n:int):seq[(untyped,untyped)] =
  var sequence:seq[(string,int)] =  @[]
  for i in 0..<n:
    var input = split(g())
    let tupple:(string,int) = (input[0],input[1].parseInt)
    add(sequence,tupple)
  sequence
# ----------------------------------------------------------------

# 配列埋め----------------------------------------------------------
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
# ------------------------------------------------------------------

# 累積和
proc cumsum(m:seq[int],n:int):seq[int] = 
  var arr : seq[int] = makeSeqInt(n+1,0)
  for i in 0..<n:
    arr[i+1]=arr[i]+m[i]
  return arr

# newSeq[seq[int]]()
# main処理----------------------------------------------------------
