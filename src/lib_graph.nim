include module

func makeSeqNums[T](height:int,width:int,fille:T):seq[seq[T]] =
  result = newSeqWith(height, newSeq[T](width))
  for i in 0..<height:
    for j in 0..<width:
      result[i][j]=fille

template isemptyQ(a:typed):untyped = 
  if(a.len==0):true
  else:false

#from here--------------------------------------------------------------------
type 
  Edge = tuple
    to:int
    c:int
  GraphWithCost = ref object
    edgesWithCost:seq[seq[Edge]]
  ShortestPath = tuple 
    dist:seq[int]
    prev:seq[int]

proc initUG(arr:seq[seq[int]],n:int):seq[seq[int]] = 
  result=newSeq[seq[int]](n)
  var a,b:int
  for i in arr:
    (a,b)=(i[0]-1,i[1]-1)
    result[a].add(b)
    result[b].add(a)

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

func initDGwithC(arr:seq[seq[int]],n:int):GraphWithCost = 
  result=GraphWithCost(edgesWithCost:newSeq[seq[(int,int)]](n))
  for inp in arr:
    var (`from`, edge) = (inp[0], Edge((to:inp[1], c:inp[2])))
    result.edgesWithCost[`from`].add((edge.to,edge.c))

func initUGwithC(arr:seq[seq[int]],n:int):GraphWithCost = 
  result=GraphWithCost(edgesWithCost:newSeq[seq[(int,int)]](n))
  for inp in arr:
    var (`from`, edge) = (inp[0], Edge((to:inp[1], c:inp[2])))
    result.edgesWithCost[`from`-1].add((edge.to-1,edge.c))
    swap(`from`,edge.to)
    result.edgesWithCost[`from`-1].add((edge.to-1,edge.c))

#ダイクストラ
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

#迷路探索
proc mazeBFS(R,C,sy,sx,gy,gx:int,field:seq[string],wall:char):int=
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
