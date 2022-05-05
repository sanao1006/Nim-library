include module

proc g(): string = stdin.readLine
proc gin(): int = g().parseInt
proc gInts(): seq[int] = g().split.map(parseInt)
proc gIntsN(n:int): seq[int] = 
  result=newSeq[int](n)
  for i in 0..n-1:result[i]=gin()
proc gIntsNs(n:int): seq[seq[int]] =
  result=newSeq[seq[int]](n)
  for i in 0..n-1:result[i]=gInts()