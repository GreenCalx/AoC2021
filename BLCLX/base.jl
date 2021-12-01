#structs & enums
@enum SLOPE begin
  decrease = -1
  undefined = 0
  increase = 1
end

mutable struct DEPTH_LOG
  index::Int
  length::Int
  slope::Int
  end

println("AoC2021 - Day 1")
println("> @arg1 : Input file")

if ( size(ARGS)[1] != 1 )
  println("FATAL ERROR : Invalid number of args. Input file is required as @arg1.")
  quit()
end

# open input file
fd = open(ARGS[1], "r")
vals = readlines(ARGS[1])
if (size(vals)[1] <= 1)
  println("INVALID INPUT : Not enough data in input file.")
  quit()
end

# convert to int array
measures = [parse(Int,x) for x in vals]
println(measures)

# count depth changes
res = DEPTH_LOG[]
depth_log = DEPTH_LOG( 0, 0, 0)
n = size(measures)[1]

for i =1:n

  if (i==1)
    depth_log.length += 1
    continue;
  end

  if measures[i] > measures[i-1] # increase
    if (depth_log.slope == 0)
      depth_log.slope = 1
    end
    if (depth_log.slope != 1)
      push!(res, depth_log)
      global depth_log = DEPTH_LOG( i, 0, 1)
    end
    depth_log.length+=1
  elseif measures[i] < measures[i-1] # decrease
    if (depth_log.slope == 0)
      depth_log.slope = -1
    end
    if (depth_log.slope != -1)
      push!(res, depth_log)
      global depth_log = DEPTH_LOG( i, 0, -1)
    end
    depth_log.length+=1
  end

  if (i==n)
    push!(res, depth_log)
  end;

end #!for

# prints logs
println("~~~ DEPTH LOGS ~~~")
for result in res
  println(result)
end
println()

# print AoC result
cpt = 0
for log in res
  if log.slope == 1
    global cpt += log.length
  end
end
println("Number of larger than previous measures : $cpt")

# close file
close(fd)