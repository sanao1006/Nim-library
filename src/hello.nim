{.passc: "-std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -L/opt/boost/gcc/lib -I/opt/ac-library".}
import strformat, macros, std/algorithm, tables, sets, lists,
    intsets, critbits, sequtils, strutils, std/math, times,
    sugar, options, bitops, heapqueue, future, std/deques

proc powMod*(a, b, c: int): int {.importcpp: "atcoder::pow_mod(#, @)", header: "<atcoder/all>".}
 
const MOD = 1000000007 
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
template `tail` (a:typed):untyped = a[1..len(a)-1]
template `init` (a:typed):untyped = a[0..len(a)-2]
template `&&`(a,b:untyped):untyped = 
  if(a==true and b==true):true else: false
template `||`(a,b:untyped):untyped = 
  if(a==true or b==true):true else: false
proc chmax[T](n: var T, m: T) {.inline.} = n = max(n, m)
proc chmin[T](n: var T, m: T) {.inline.} = n = min(n, m)
proc plus(a,b:int):int=return a+b
proc product(a,b:int):int=return a*b
proc subtract(a,b:int):int=return a-b
proc zipwith[T1,T2,T3](f: proc(a:T1,b:T2):T3, xs:openarray[T1],ys:openarray[T2]): seq[T1] =
    newSeq(result, xs.len)
    for i in low(xs)..high(xs): result[i] = f(xs[i],ys[i])
# 配列埋め----------------------------------------------------------
proc makeSeqInt(n:int,m:int):seq[int] = 
  var sequence : seq[int] = @[]
  for i in 0..<n:
    add(sequence, m)
  return sequence

proc makeSeqInts(h:int,w:int,fill:int):seq[seq[int]] = 
  var 
    result = newSeq[seq[int]]()
    se1 = makeSeqInt(w,fill)
  for h in 0..<h:
    result.add(se1)
  return result

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
proc makeUndirectGraph(n:int,m:int):seq[seq[int]] = 
  var sequence = newSeq[seq[int]]()
  var a,b:int
  for i in 0..<n:
    add(sequence, @[])
  for i in 0..<m:
    (a,b)=gInts()
    add(sequence[a-1],b)
    add(sequence[b-1],a)
  return  sequence
proc makeDirectGraph(n:int,m:int):seq[seq[int]] = 
  var sequence = newSeq[seq[int]]()
  var a,b:int
  for i in 0..n:
    add(sequence, @[])
  for i in 0..<m:
    (a,b)=gInts()
    add(sequence[a],b)
  return  sequence

template isemptyQ(a:typed):untyped = 
  if(a.len==0):true
  else:false
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
# 素因数分解
proc primeFactorization(n:var int):seq[int]=
  var res:seq[int]
  var i:int=2
  while i<=int sqrt(float n):
    if n.mod(i)!=0:i+=1
    else:
      n=n.div(i)
      res.add(i)
  if n!=1:res.add(n)
  return res
#幅優先探索
proc bfs(G:seq[seq[int]],n:int):seq[int] = 
  var
    dist = makeSeqInt(n,-1)
    que = initDeque[int]()
  dist[0] = 0
  que.addLast(0)
  while(not(que.isemptyQ)):
    var v = que.popFirst()
    for nv in G[v]:
      if(dist[nv] != -1):continue
      dist[nv] = dist[v] + 1
      que.addLast(nv)
  return  dist


proc nCr(n:int,r:int):int = 
  if(r==0 or r==n):return 1
  else:
    return nCr(n-1,r-1) + nCr(n-1,r)

# var 
#   dy = @[-1,0,0,1]
#   dx = @[0,-1,1,0]
# var field = makeSeqStr(R,"")
# for i in 0..<R:
#   field[i] = g()
# var sx,sy,gx,gy:int
# for R in 0..<R:
#   for C in 0..<C:
#     if(field[R][C]=='s'):
#       sy = R
#       sx = C
#     if(field[R][C]=='g'):
#       gy = R
#       gx = C

# var dist = makeSeqInts(R,C,-1)

# dist[sy][sx] = 0

# var que = initDeque[(int,int)]()
# que.addLast((sy,sx))

# while(not(que.isemptyQ)):
#   var
#     currentpos = que.popFirst()
#     (y,x) = currentpos
#   for direction in 0..<4:
#     var
#       next_x = dx[direction] + x
#       next_y = dy[direction] + y
#     if(y==gy and x==gx): break
#     if(0 <= next_y and next_y < R and 0 <= next_x and next_x < C and field[next_y][next_x] != '#' and dist[next_y][next_x] == -1):
#       dist[next_y][next_x] = dist[y][x] + 1
#       que.addLast((next_y,next_x))

# main処理----------------------------------------------------------
var a,b:int
(a,b)=gInts()
echo powMod(a,b,MOD)