include module

template `tail` (a:typed):untyped = a[1..len(a)-1]
#累積和
func cumsum[T](m:seq[T],n:int):seq[T] = 
  var zero:T = 0 
  result : seq[T] = newSeqWith(n+1,zero)
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
func Eratosthenes(N:int):seq[int] =
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

# ランレングス圧縮
proc rle[T](arr:seq[T]):seq[(T,int)]=
  iterator groupBy[T](s: openArray[T]): tuple[k: T, v: seq[T]] =
    var t = initTable[T, seq[T]]()
    for x in s:t.mGetOrPut(x, @[]).add(x)
    for x in t.pairs:yield x
  for (i,j) in arr.groupBy():result.add((i, j.len))
  result.sorted()

