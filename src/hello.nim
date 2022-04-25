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
template last(a:untyped): untyped = a[a.len - 1]
func head(a:openarray[int]):Option[int] =
  if(a.len > 0):a[0].some else:int.none
func head(a:openarray[float]):Option[float] =
  if(a.len > 0):a[0].some else:float.none
func head(a:openarray[string]):Option[string] =
  if(a.len > 0):a[0].some else:string.none
template `tail` (a:typed):untyped = a[1..len(a)-1]
template `init` (a:typed):untyped = a[0..len(a)-2]
template `&&`(a,b:untyped):untyped = 
  if(a==true and b==true):true else: false
template `||`(a,b:untyped):untyped = 
  if(a==true or b==true):true else: false
func chmax[T](n: var T, m: T) {.inline.} = n = max(n, m)
func chmin[T](n: var T, m: T) {.inline.} = n = min(n, m)
func plus[T](a,b:T):T=return a+b
func product[T](a,b:T):T=return a*b
func subtract[T](a,b:T):T=return a-b
func zipwith[T1,T2,T3](f: proc(a:T1,b:T2):T3, xs:openarray[T1],ys:openarray[T2]): seq[T1] =
    newSeq(result, xs.len)
    for i in low(xs)..high(xs): result[i] = f(xs[i],ys[i])
func search[T](x:seq[T],y:T) : bool = 
  for i in x:
    if i == y : return true
  return false
func `++`[T](a:T):T = a+1
func `--`[T](a:T):T = a-1
func Qsort[T](x:seq[T]):seq[T] =
  if(x.len<=1):return x
  else:
    var 
      pivot = x[0]
      left:seq[T] = @[]
      right:seq[T] = @[]
    for i in 1..<x.len:
      if(x[i]<pivot):add(left,x[i])
      else:add(right,x[i])
    return Qsort(left) & @[pivot] & Qsort(right)
func partialSort[T](List:seq[T],left:T,right:T):seq[T] = 
  var sortedZone:seq[T] = List[left - 1..right - 1].Qsort()
  return List[0..left - 2] & sortedZone & List[right  .. List.len - 1]    
proc rotR(a:char):char = 
  var b=ord a
  if(b==122):return chr(97)
  else:return chr(++b)
proc rotL(a:char):char = 
  var b=ord a
  if(b==97):return chr(122)
  else:return chr(--b)
proc msi():seq[int]=newSeq[int]()
func transepose[T](arr:seq[seq[T]]):seq[seq[T]] = 
  var
    hight=arr.len
    width=arr.mapIt(it.len)[0]
  result=newSeq[seq[T]]()
  for i in 0..<width:
    var tmpArr=msi()
    for j in 0..<hight:
      tmpArr.add(arr[j][i])
    result.add(tmpArr)
proc toInt(c:char): int = return int(c) - int('0')
# 配列埋め----------------------------------------------------------

func makeSeqNums[T](height:int,width:int,fille:T):seq[seq[T]] =
  var result = newSeqWith(height, newSeq[T](width))
  for i in 0..<height:
    for j in 0..<width:
      result[i][j]=fille
  return result

func makeSeqStr(height:int,fille:string):seq[string] =
  var result = newSeq[string](height)
  for i in 0..<height:
      result[i]=fille
  return result

func makeSeqNum[T](n:int,m:T):seq[T] = 
  var sequence : seq[T] = @[]
  for i in 0..<n:
    add(sequence, m)
  return sequence

proc makeUndirectGraph(arr:seq[seq[int]],n:int,m:int):seq[seq[int]] = 
  var sequence = newSeq[seq[int]]()
  var a,b:int
  for i in 0..<n:
    add(sequence, @[])
  for i in arr:
    (a,b)=(i[0],i[1])
    add(sequence[a-1],b-1)
    add(sequence[b-1],a-1)
  return  sequence
proc makeDirectGraph(arr:seq[seq[int]],n:int,m:int):seq[seq[int]] = 
  var sequence = newSeq[seq[int]]()
  var a,b:int
  for i in 0..n:
    add(sequence, @[])
  for i in arr:
    (a,b)=(i[0],i[1])
    add(sequence[a-1],b-1)
  return  sequence
func path(arr:seq[seq[int]],n:int):seq[seq[bool]] = 
  result=newSeq[seq[bool]]()
  for i in 0..<n:result.add(makeSeqNum(n,false))
  for i in arr:
    result[i[0]-1][i[1]-1]=true
    result[i[1]-1][i[0]-1]=true
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
func cumsum[T](m:seq[T],n:int):seq[T] = 
  var
    zero:T = 0 
    arr : seq[T] = makeSeqNum(n+1,zero)
  for i in 0..<n:
    arr[i+1]=arr[i]+m[i]
  return arr
# 約数列挙
func divisors(num:int):seq[int] =
    var divisors:seq[int] = @[]
    for i in countup(1,toInt(pow(toFloat(num),0.5))):
        if num mod i != 0:continue
        add(divisors,i)
        if((num div i) != i):add(divisors,(num div i))
    divisors.sort()
    return divisors
#素数判定
func isPrime(num:int):bool = 
  if(num <= 1): return false
  else:
    for i in countup(2,toInt(pow(toFloat(num),0.5))):
      if(num mod i == 0):
        return false
    return true
#素数列挙
func primeRekkyo(n:int):seq[int] = 
  var list:seq[int] = @[]
  for i in 0..n:
    if(isPrime(i)):
      add(list,i)
  return list
# 素因数分解
func primeFactorization(n:var int):seq[int]=
  var res:seq[int]
  var i:int=2
  while i<=int sqrt(float n):
    if n.mod(i)!=0:i+=1
    else:
      n=n.div(i)
      res.add(i)
  if n!=1:res.add(n)
  return res
#エラトスネテスの篩
func Eratosthenes(N:int):seq[int] =
    var isprime = makeSeqNum(N+1,true)
    isprime[0] = false
    isprime[1] = false
    for p in 2..<N+1:
        if not isprime[p]:continue
        var q = p * 2
        while q <= N:
            isprime[q] = false
            q += p
    return(zip((tail isprime),(1..N).toSeq)).filterIt(it[0]==true).mapIt(it[1])
 
#順列全探索用  quoted from "https://forum.nim-lang.org/t/2812"
proc perm[T](a: openarray[T], n: int, use: var seq[bool]): seq[seq[T]] =
  result = newSeq[seq[T]]()
  if n <= 0: return
  for i in 0 .. a.high:
    if not use[i]:
      if n == 1:result.add(@[a[i]])
      else:
        use[i] = true
        for j in perm(a, n - 1, use):result.add(a[i] & j)
        use[i] = false
proc permutations[T](a: openarray[T], n: int = a.len): seq[seq[T]] =
  var use = newSeq[bool](a.len)
  perm(a, n, use)
  
#幅優先探索
func bfs(G:seq[seq[int]],n:int):seq[int] = 
  var
    dist = makeSeqNum(n,-1)
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

proc products(n:int):seq[seq[int]]=
  var res = newSeq[seq[int]]()
  for bit in 0..<(1 shl n):
    var sub: seq[int]
    for i in 0..<n:
        if bit.testBit(i):
            sub.add(i)
    res.add(sub)
  return res.tail
proc productArray(n:int,arr:seq[string],k:seq[seq[int]]=products(n)):seq[seq[string]]=
  var res=newSeq[seq[string]]()
  for i in k:
    var tmp=newSeq[string]()
    for j in i:
      tmp.add(arr[j])
    res.add(tmp)
  return res
proc productArray(n:int,arr:seq[int],k:seq[seq[int]]=products(n)):seq[seq[int]]=
  var res=newSeq[seq[int]]()
  for i in k:
    var tmp=newSeq[int]()
    for j in i:
      tmp.add(arr[j])
    res.add(tmp)
  return res

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

# var dist = makeSeqNums(R,C,-1)

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


