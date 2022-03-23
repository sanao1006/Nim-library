import strformat, macros, std/algorithm, tables, sets, lists,
    intsets, critbits, sequtils, strutils, std/math, times,
    sugar, options, bitops, heapqueue, future,std/deques

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
template gStrN(n:int): seq[untyped] = 
  var sequence:seq[string] = @[]
  for i in 0..n-1:
    var input = g()
    add(sequence, input)
  sequence
# ----------------------------------------------------------------
template `head`(a:typed):untyped = a[0]
template `last`(a:typed): untyped = a[len(a)-1]
template `init` (a:typed):untyped = a[1..len(a)-1]
template `tail` (a:typed):untyped = a[0..len(a)-2]
# 配列埋め----------------------------------------------------------
proc makeSeqInt(n:int,m:int):seq[int] = 
  var sequence : seq[int] = @[]
  for i in 0..<n:
    add(sequence, m)
  sequence

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
#debugマクロ
macro debug(args:varargs[untyped]): typed = 
  result = newNimNode(nnkStmtList,args)
  for arg in args:
    let name = toStrLit(arg)
    result.add quote do:
      stdout.write `name`
      stdout.write ": "
      stdout.writeLine `arg`
# 累積和
proc cumsum(m:seq[int],n:int):seq[int] = 
  var arr : seq[int] = makeSeqInt(n+1,0)
  for i in 0..<n:
    arr[i+1]=arr[i]+m[i]
  return arr
# 約数列挙
proc divisors(num:int):seq[int] =
    var divisors:seq[int] = @[]
    for i in countup(1,toInt(pow(toFloat(num),0.5))):
        if num mod i != 0:continue
        add(divisors,i)
        if((num div i) != i):add(divisors,(num div i))
    divisors.sort()
    return divisors
#素数判定
proc isPrime(num:int):bool = 
  if(num <= 1): return false
  else:
    for i in countup(2,toInt(pow(toFloat(num),0.5))):
      if(num mod i == 0):
        return false
    return true
#素数列挙
proc primeRekkyo(n:int):seq[int] = 
  var list:seq[int] = @[]
  for i in 0..n:
    if(isPrime(i)):
      add(list,i)
  return list

proc `//`(a:int,b:int):int = 
  toInt(floor(toFloat(a) / toFloat(b)))
#proc primes(n:int):seq[int] = 
#    var lis=newSeq[int]()
#    var m:int = n
#    for i in countup(2,toInt(pow(toFloat(m),0.5))):
#        while true:
#            if m mod i == 0:
#                add(lis,i) 
#                n = n div i
#            else:
#                break
#    if (n > toInt(pow(toFloat(n),0.5))):
#        add(lis,n)
#    return lis

# newSeq[seq[int]]()
# main処理----------------------------------------------------------
