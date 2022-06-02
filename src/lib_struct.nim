include module

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
#----------------------------------------------------------
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

#--------------------------------------------------------------
# heapdict(like multiset)

type HeapDict[T] = ref object
  h:HeapQueue[T]
  d:Table[T,int]
proc initHD(type_name:typedesc):HeapDict[type_name]=
  HeapDict[type_name](h:initHeapQueue[type_name](),d:initTable[type_name,int]())
proc insertHD[T](hd:HeapDict,x:T):void=
  hd.h.push(x)
  if(not(hd.d.contains(x))):hd.d[x] = 1
  else: hd.d[x] += 1
proc getminHD(hd:HeapDict):int=
  result = hd.h[0]
proc is_existHD[T](hd:HeapDict,x:T):bool=
  if(hd.d.contains(x) and hd.d[x] != 0):
    return true
  else: return false
proc eraseHD[T](hd:HeapDict,x:T):void=
  if(not(hd.d.contains(x)) or hd.d[x]==0):
    quit("naiyo")
  else:
    hd.d[x] -= 1
  while(hd.h.len>0):
    if(hd.d[hd.h[0]]==0):
      discard hd.h.pop()
    else:
      break
 
