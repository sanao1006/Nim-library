{.passc: "-std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -L/opt/boost/gcc/lib -I/opt/ac-library".}
{.optimization:speed.}
import strformat, macros, std/algorithm, tables, sets, lists,
    intsets, critbits, sequtils, strutils, std/math, times,
    sugar, options, bitops, heapqueue, future, std/deques

proc powMod*(a, b, c: int): int {.importcpp: "atcoder::pow_mod(#, @)", header: "<atcoder/all>".}
 
const MOD = 1000000007 
# 入力テンプレ-------------------------------------------------
proc g(): string = stdin.readLine
proc gin(): int = g().parseInt
proc gInts(): seq[int] = g().split.map(parseInt)
proc gIntsN(n:int): seq[int] = 
  result=newSeq[int](n)
  for i in 0..n-1:result[i]=gin()
proc gIntsNs(n:int): seq[seq[int]] =
  result=newSeq[seq[int]](n)
  for i in 0..n-1:result[i]=gInts()
proc gStrN(n:int): seq[string] = 
  result = newSeq[string](n)
  for i in 0..n-1:result[i]=g()
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
proc zip3[S,T,U](a:seq[S],b:seq[T],c:seq[U]):seq[(S,T,U)]=
  for i in zip(zip(a,b),c):result.add((i[0][0],i[0][1],i[1]))
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
func transepose(arr:seq[seq[int]]):seq[seq[int]] = 
  var
    hight=arr.len
    width=arr.mapIt(it.len)[0]
  result=newSeq[seq[int]]()
  for i in 0..<width:
    var tmpArr=msi()
    for j in 0..<hight:
      tmpArr.add(arr[j][i])
    result.add(tmpArr)
func transepose(arr:seq[string]):seq[string] = 
  var
    hight=arr.len
    width=arr.mapIt(it.len)[0]
  var res=newSeq[seq[char]]()
  for i in 0..<width:
    var tmpArr=newSeq[char]()
    for j in 0..<hight:
      tmpArr.add(arr[j][i])
    res.add(tmpArr)
  return res.mapIt(it.join())
  
proc toInt(c:char): int = return int(c) - int('0')
# 配列埋め----------------------------------------------------------

func makeSeqNums[T](height:int,width:int,fille:T):seq[seq[T]] =
  result = newSeqWith(height, newSeq[T](width))
  for i in 0..<height:
    for j in 0..<width:
      result[i][j]=fille

func makeSeqStr(height:int,fille:string):seq[string] =
  result = newSeq[string](height)
  for i in 0..<height:result[i]=fille

func makeSeqNum[T](n:int,m:T):seq[T] = 
  result=newSeq[T](n)
  for i in 0..<n:result[i]=m

#グラフ関連------------------------------------------------------------
proc makeUndirectGraph(arr:seq[seq[int]],n:int,m:int):seq[seq[int]] = 
  result=newSeq[seq[int]](n)
  var a,b:int
  for i in arr:
    (a,b)=(i[0]-1,i[1]-1)
    result[a].add(b)
    result[b].add(a)

proc makeDirectGraph(arr:seq[seq[int]],n:int,m:int):seq[seq[int]] = 
  result=newSeq[seq[int]](n)
  var a,b:int
  for i in arr:
    (a,b)=(i[0]-1,i[1]-1)
    result[a].add(b)

func path(arr:seq[seq[int]],n:int):seq[seq[bool]] = 
  result=newSeq[seq[bool]]()
  for i in 0..<n:result.add(makeSeqNum(n,false))
  for i in arr:
    result[i[0]-1][i[1]-1]=true
    result[i[1]-1][i[0]-1]=true
    
proc makeDiGraphWithCost(n,m:int):seq[seq[(int,int)]] = 
  result=newSeq[seq[(int,int)]](n)
  for i in 0..<m:
    var inp = gInts()
    result[inp[0]-1].add((inp[1]-1,inp[2]))

proc makeUnGraphWithCost(n,m:int):seq[seq[(int,int)]] = 
  result=newSeq[seq[(int,int)]](n)
  for i in 0..<m:
    var inp = gInts()
    result[inp[0]-1].add((inp[1]-1,inp[2]))
    result[inp[1]-1].add((inp[0]-1,inp[2]))

template isemptyQ(a:typed):untyped = 
  if(a.len==0):true
  else:false

#ダイクストラ
proc dijkstra(arr:seq[seq[(int,int)]],start:int,n:int):seq[int] =
  var
    inf=1000000000
    heap = initHeapQueue[(int,int)]()
    cost=makeSeqNum(n,inf)
  heap.push((0,start))
  cost[start] = 0
  while(not(heap.isemptyQ)):
    var
      (c,pos)=heap.pop()
    if(cost[pos]<c):continue
    for (i,d) in arr[pos]:
      if (cost[i] > c + d):
        cost[i] = c + d
        heap.push((c+d,i))
  return cost

#幅優先探索
func bfs(G:seq[seq[int]],n:int,start:int):seq[int] = 
  var
    dist = makeSeqNum(n,-1)
    que = initDeque[int]()
  dist[start] = 0
  que.addLast(start)
  while(not(que.isemptyQ)):
    var v = que.popFirst()
    for nv in G[v]:
      if(dist[nv] != -1):continue
      dist[nv] = dist[v] + 1
      que.addLast(nv)
  return  dist

#迷路探索
proc maze(R,C,sy,sx,gy,gx:int,field:seq[string],wall:char):int=
  var 
    dist=makeSeqNums(R,C,-1)
    que=initDeque[(int,int)]()
  que.addLast((sy,sx))
  dist[sy][sx]=0
  while(not(que.isemptyQ)):
    var(ny,nx)=que.popFirst()
    for (i2,j2) in ([[ny+1,nx],[ny-1,nx],[ny,nx+1],[ny,nx-1]]):
      if(not((i2>=0 and i2 < R) and (j2 >= 0 and j2 < C))):continue
      if(field[ny][nx]==wall):continue
      if(dist[i2][j2] == -1):
        dist[i2][j2]=dist[ny][nx] + 1
        que.addLast((i2,j2))
  return dist[gy][gx]
# ------------------------------------------------------------------
#union-find
type UnionFind = ref object
  parent:seq[int]
  rank:seq[int]

proc makeUf(n:int):UnionFind =
  result=UnionFind(parent:newSeq[int](n),rank:newSeq[int](n))
  for i in 0..<n:result.parent[i] = -1
  for i in 0..<n:result.rank[i] = 1

proc rootUf(uf:UnionFind; x: int):int =
  if (uf.parent[x] == -1):return x
  uf.parent[x] = uf.rootUf(uf.parent[x])
  return uf.parent[x]

proc uniteUf(uf:UnionFind,x,y:int):void =
  var
    a=rootUf(uf,x)
    b=rootUf(uf,y)
  if(a == b):return
  if(uf.rank[a]>uf.rank[b]):
    var tmp = 0
    tmp = a
    a = b
    b=tmp
  if(uf.rank[a]==uf.rank[b]):uf.rank[b] += 1
  uf.parent[a]=b

proc sameUf(uf:UnionFind,x,y:int):bool =
  return if(uf.rootUf(x) == uf.rootUf(y)):true else: false
#累積和
func cumsum[T](m:seq[T],n:int):seq[T] = 
  var zero:T = 0 
  result : seq[T] = makeSeqNum(n+1,zero)
  for i in 0..<n:result[i+1]=result[i]+m[i]

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


proc nCr(n:int,r:int):int = 
  if(r==0 or r==n):return 1
  else:
    return nCr(n-1,r-1) + nCr(n-1,r)
#itertools quoted from "https://github.com/narimiran/itertools/blob/master/src/itertools.nim"
iterator prod[T](s: openArray[T], repeat: Positive): seq[T] =
  var counters = newSeq[int](repeat)
  block outer:
    while true:
      var result = newSeq[T](repeat)
      for i, cnt in counters:
        result[i] = s[cnt]
      yield result
      var i = repeat - 1
      while true:
        inc counters[i]
        if counters[i] == s.len:
          counters[i] = 0
          dec i
        else: break
        if i < 0:
          break outer

iterator prod[T, U](s1: openArray[T], s2: openArray[U]): tuple[a: T, b: U] =
  for a in s1:
    for b in s2:
      yield (a, b)

iterator prod[T, U, V](s1: openArray[T], s2: openArray[U], s3: openArray[V]):tuple[a: T, b: U, c: V] =
  for a in s1:
    for b in s2:
      for c in s3:
        yield (a, b, c)

iterator prod[T, U, V, W](s1: openArray[T], s2: openArray[U], s3: openArray[V],s4: openArray[W]): tuple[a: T, b: U, c: V, d: W] =
  for a in s1:
    for b in s2:
      for c in s3:
        for d in s4:
          yield (a, b, c, d)
iterator groupC[T](s: openArray[T]): tuple[k: T, v: seq[T]] =
  var
    k = s[0]
    v = @[k]
    i = 1
  while i < s.len:
    if s[i] != k:
      yield (k, v)
      k = s[i]
      v = @[k]
    else:
      v.add k
    inc i
  yield (k, v)

iterator groupC[T, U](s: openArray[T], f: proc(a: T): U): tuple[k: U, v: seq[T]] =
  var 
    k = f(s[0])
    v = @[s[0]]
    i = 1
  while i < s.len:
    let fx = f(s[i])
    if fx != k:
      yield (k, v)
      k = fx
      v = @[s[i]]
    else:
      v.add s[i]
    inc i
  yield (k, v)
# itertools end

proc group[T](s:seq[T]):seq[seq[T]] =
  var res = newSeq[seq[T]]()
  for (k,v) in groupC(s):res.add(v)
  return res
# compress
func compress[T](arr:seq[T]):seq[T]=
  var 
    c:seq[T] = arr.toHashSet().toSeq().sorted()
    zero:T = 0
    res = makeSeqNum(arr.len,zero)
  for i in 0..<arr.len:
    res[i]= c.lowerBound(arr[i],system.cmp[int])
  return res  
#tuple sort
proc sortFst[T, U](arr:seq[tuple[fst:T,snd:U]]):seq[(T,U)] =
  arr.sortedByIt(it.fst).mapIt((it.fst,it.snd))

proc sortSnd[T, U](arr:seq[tuple[fst:T,snd:U]]):seq[(T,U)] =
  return arr.sortedByIt(it.snd).mapIt((it.fst,it.snd))

# main処理----------------------------------------------------------

proc main()=
  echo "Hello, World!"

when isMainModule:
  main()
