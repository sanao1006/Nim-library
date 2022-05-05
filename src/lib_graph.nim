include module

func makeSeqNums[T](height:int,width:int,fille:T):seq[seq[T]] =
  result = newSeqWith(height, newSeq[T](width))
  for i in 0..<height:
    for j in 0..<width:
      result[i][j]=fille

template isemptyQ(a:typed):untyped = 
  if(a.len==0):true
  else:false
type Edge = seq[seq[int]]
type Graph = ref object of RootObj
  e:Edge
  edges:seq[seq[int]]
type GraphWithCost = ref object of Graph
  edgesWithCost:seq[seq[(int,int)]]
  cost:seq[int]
type ShortestPath = tuple 
  dist:seq[int]
  prev:seq[int]
proc initEdge(m:int):Edge=gIntsNs(m)
func initUG(arr:Edge,n:int,m:int):Graph =
  result=Graph(e:arr,edges:newSeq[seq[int]](n))
  for i in arr:
    var(first,back)=(i[0]-1,i[1]-1)
    result.edges[first].add(back)
    result.edges[back].add(first)
func initDG[T](arr:Edge,n:int,m:int):Graph =
  result=Graph(e:arr.initEdge(m),edges:newSeq[seq[T]](n))
  for i in arr:
    var(first,back)=(i[0]-1,i[1]-1)
    result.edges[first].add(back)
func path(arr:Edge,n:int):seq[seq[bool]] = 
  result=newSeq[seq[bool]]()
  for i in 0..<n:result.add(newSeqWith(n,false))
  for i in arr:
    result[i[0]-1][i[1]-1]=true
    result[i[1]-1][i[0]-1]=true

func initDGwithC(arr:Edge,n:int):GraphWithCost = 
  result=GraphWithCost(edgesWithCost:newSeq[seq[(int,int)]](n),cost:newSeqWith(n,-1))
  for inp in arr:result.edgesWithCost[inp[0]].add((inp[1]-1.int,inp[2]))

func initUGwithC(arr:Edge,n:int):GraphWithCost = 
  result=GraphWithCost(edgesWithCost:newSeq[seq[(int,int)]](n),cost:newSeqWith(n,-1))
  for inp in arr:
    result.edgesWithCost[inp[0]].add((inp[1]-1,inp[2]))
    result.edgesWithCost[inp[1]].add((inp[0]-1,inp[2]))
#ダイクストラ
func dijkstra(arr:GraphWithCost,start:int,n:int):GraphWithCost =
  var
    heap = initHeapQueue[(int,int)]()
    done=newSeqWith(n,false)
  heap.push((0,start))
  arr.cost[start] = 0
  while(not(heap.isemptyQ)):
    var(co,pos)=heap.pop()
    if(done[pos]):continue
    done[pos] = true
    for (i,d) in arr.edgesWithCost[pos]:
      if (arr.cost[i] == -1 or arr.cost[i] > arr.cost[pos] + d):
        arr.cost[i] = d + arr.cost[pos]
        heap.push((arr.cost[i],i))
  return arr
#幅優先探索
func bfs(G:Graph,n:int,start:int):ShortestPath = 
  result=ShortestPath((dist:newSeqWith(n,-1),prev:newSeqWith(n,-1)))
  var
    que = initDeque[int]()
  result.dist[start] = 0
  que.addLast(start)
  while(not(que.isemptyQ)):
    var v = que.popFirst()
    for nv in G.edges[v]:
      if(result.dist[nv] != -1):continue
      result.dist[nv] = result.dist[v] + 1
      result.prev[nv] = v
      que.addLast(nv)
  return  result

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