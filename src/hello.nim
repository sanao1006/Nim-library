{.passc: "-std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -L/opt/boost/gcc/lib -I/opt/ac-library".}
{.optimization:speed,warnings: off,hints: off.}
import strformat, macros, std/algorithm, tables, sets, lists,intsets, critbits, sequtils, strutils, std/math, times,sugar, options, bitops, heapqueue,std/deques,os
const MOD = 1000000007;const MOD_ANOTHER = 998244353

proc powMod*(a, b, c: int): int {.importcpp: "atcoder::pow_mod(#, @)", header: "<atcoder/all>".}
 
# 入力テンプレ-------------------------------------------------
proc g(): string = stdin.readLine
proc gin(): int = g().parseInt
proc gInts(): seq[int] = g().split.map(parseInt)
proc gss():seq[int]=g().insertSep(sep=' ',1).split.map(parseInt)
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
func product[T](a:openArray[T]):T=
  result=1
  for i in a:result = result * i 
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

template isemptyQ(a:typed):untyped = 
  if(a.len==0):true
  else:false

proc toInt(c:char): int = return int(c) - int('0')

#------------------------------------------------------------------
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
  if(uf.rank[a]>uf.rank[b]):swap(a,b)
  if(uf.rank[a]==uf.rank[b]):uf.rank[b] += 1
  uf.parent[a]=b

proc sameUf(uf:UnionFind,x,y:int):bool =
  return if(uf.rootUf(x) == uf.rootUf(y)):true else: false

proc groupUf(uf:UnionFind):int=
  result = 0
  for i in uf.parent:
    if i < 0:result += 1

#binary indexed tree
type Bit = ref object 
  size:int
  tree:seq[int]
proc initBit(n:int):Bit =
  result = Bit(size:n,tree:newSeqWith(n+1,0))
proc sumBit(bit:Bit,i:int):int = 
  result=0
  var k = i
  k -= 1
  while(k>=0):
    result += bit.tree[k]
    k = (k and (k+1)) - 1
proc addBit(bit:Bit,i:int,x:int):void =
  var k = i
  while(k < bit.size):
    bit.tree[k] += x
    k = (k or (k+1))
proc rangeBit(bit:Bit,l:int,r:int):int =
  if(l==0):return bit.sumBit(r)
  return bit.sumBit(r) - bit.sumBit(l)
proc buildBit(bit:Bit,arr:seq[int]):Bit=
  for ix,i in arr:bit.addBit(ix,i)
  return bit
proc makeBit(arr:seq[int],n:int):Bit =
  return initBit(n).buildBit(arr)

#グラフ関連----------------------------------------------------------
type 
  Edge = tuple
    to:int
    c:int
  GraphWithCost = ref object
    edgesWithCost:seq[seq[Edge]]
  ShortestPath = tuple 
    dist:seq[int]
    prev:seq[int]

# init Undirected Graph 0-indexed
proc initUG(arr:seq[seq[int]],n:int):seq[seq[int]] = 
  result=newSeq[seq[int]](n)
  var a,b:int
  for i in arr:
    (a,b)=(i[0]-1,i[1]-1)
    result[a].add(b)
    result[b].add(a)

# init Directed Graph 0-indexed
proc initDG(arr:seq[seq[int]],n:int):seq[seq[int]] = 
  result=newSeq[seq[int]](n)
  var a,b:int
  for i in arr:
    (a,b)=(i[0]-1,i[1]-1)
    result[a].add(b)

func path(arr:seq[seq[int]],n:int):seq[seq[bool]] = 
  result=newSeq[seq[bool]]()
  for i in 0..<n:result.add(newSeqWith(n,false))
  for i in arr:
    result[i[0]-1][i[1]-1]=true
    result[i[1]-1][i[0]-1]=true

# init Directed Graph 0-indexed
func initDGwithC(arr:seq[seq[int]],n:int):GraphWithCost = 
  result=GraphWithCost(edgesWithCost:newSeq[seq[(int,int)]](n))
  for inp in arr:
    var (`from`, edge) = (inp[0], Edge((to:inp[1], c:inp[2])))
    result.edgesWithCost[`from`-1].add((edge.to-1,edge.c))

# init Undirected Graph 0-indexed
func initUGwithC(arr:seq[seq[int]],n:int):GraphWithCost = 
  result=GraphWithCost(edgesWithCost:newSeq[seq[(int,int)]](n))
  for inp in arr:
    var (`from`, edge) = (inp[0], Edge((to:inp[1], c:inp[2])))
    result.edgesWithCost[`from`-1].add((edge.to-1,edge.c))
    swap(`from`,edge.to)
    result.edgesWithCost[`from`-1].add((edge.to-1,edge.c))
 
#dijkstra
func dijkstra(arr:GraphWithCost,start:int,n:int):seq[int] =
  var 
    heap = initHeapQueue[(int,int)]()
    cost=newSeqWith(n,int.high)
  heap.push((0,start))
  cost[start] = 0
  while(not(heap.isemptyQ)):
    var(c,pos)=heap.pop()
    if(cost[pos]<c):continue
    for (i,d) in arr.edgesWithCost[pos]:
      if (cost[i] > c + d):
        cost[i] = c+d
        heap.push((c+d,i))
  return cost
#breath-first search
func bfs(G:seq[seq[int]],start:int,n:int):ShortestPath = 
  result=ShortestPath((dist:newSeqWith(n,-1),prev:newSeqWith(n,-1)))
  var
    que = initDeque[int]()
  result.dist[start] = 0
  que.addLast(start)
  while(not(que.isemptyQ)):
    var v = que.popFirst()
    for nv in G[v]:
      if(result.dist[nv] != -1):continue
      result.dist[nv] = result.dist[v] + 1
      result.prev[nv] = v
      que.addLast(nv)

# maze search by BFS
proc mazeBFS(R,C,sy,sx:int,field:seq[string],wall:char):seq[seq[int]]=
  var 
    dist=newSeqWith(R,newSeqWith(C,-1))
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
  return dist

proc kruskal(G:GraphWithCost,n:int):int =
  var aa = newSeq[tuple[u:int,v:int,co:int]](n)
  for ix,i in G.edgesWithCost:
    for j in i:
      aa.add((ix,j.to,j.c))
  result = 0
  var
    nn = aa.sortedByIt((it.co))
    uf = makeUf(n)
  for i in nn:
    var(u,v,c)=(i[0],i[1],i[2])
    if(uf.sameUf(u,v)):continue
    uf.uniteUf(u,v)
    result += c

#----------------------------------------------------------
#累積和
func cumsum[int](m:seq[int],n:int):seq[int] =
  result : seq[int] = newSeqWith(n+1,0)
  for i in 0..<n:result[i+1]=result[i]+m[i]
func cumsum[float](m:seq[float],n:int):seq[float] =
  result : seq[float] = newSeqWith(n+1,0)
  for i in 0..<n:result[i+1]=result[i]+m[i]

# 約数列挙
func divisors(num:int):seq[int] =
    result=newSeq[int]()
    for i in countup(1,toInt(pow(toFloat(num),0.5))):
        if num mod i != 0:continue
        result.add(i)
        if((num div i) != i):result.add((num div i))
    result.sort()
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
  for i in 0..n:
    if(isPrime(i)):result.add(i)
# 素因数分解
func primeFactorization(n:var int):seq[int]=
  var i:int=2
  while i<=int sqrt(float n):
    if n.mod(i)!=0:i+=1
    else:
      n=n.div(i)
      result.add(i)
  if n!=1:result.add(n)
#エラトスネテスの篩
func erato(N:int):seq[int] =
    var isprime = newSeqWith(N+1,true)
    isprime[0] = false
    isprime[1] = false
    for p in 2..<N+1:
        if not isprime[p]:continue
        var q = p * 2
        while q <= N:
            isprime[q] = false
            q += p
    return(zip((tail isprime),(1..N).toSeq)).filterIt(it[0]==true).mapIt(it[1])

iterator permutations[T](s: openArray[T]): seq[T] =
  var x = @s
  x.sort(cmp)
  yield x
  while x.nextPermutation():
    yield x
 
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
        if i < 0:break outer


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
#itertools end--------------------------------------------

proc group[T](s:seq[T]):seq[seq[T]] =
  var res = newSeq[seq[T]]()
  for (k,v) in groupC(s):res.add(v)
  return res
# compress
func compress[T](arr:seq[T]):seq[T]=
  var 
    c:seq[T] = arr.toHashSet().toSeq().sorted()
    zero:T = 0
    res = newSeqWith(arr.len,zero)
  for i in 0..<arr.len:
    res[i]= c.lowerBound(arr[i],system.cmp[int])
  return res  
#tuple sort
proc sortFst[T, U](arr:seq[tuple[fst:T,snd:U]]):seq[(T,U)] = arr.sortedByIt(it.fst).mapIt((it.fst,it.snd))

proc sortSnd[T, U](arr:seq[tuple[fst:T,snd:U]]):seq[(T,U)] = arr.sortedByIt(it.snd).mapIt((it.fst,it.snd))



# main処理----------------------------------------------------------

proc main()=
  var s = gss()
  echo s[1]

when isMainModule:
  main()
