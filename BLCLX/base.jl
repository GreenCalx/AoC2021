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

mutable struct DEPTH_LOG_WINDOW
  index::Int
  value::Int
end

println("#######################")
println("### AoC2021 - Day 1 ###")
println("#######################")

println(">> @arg1 : Input file")
println()

if ( size(ARGS)[1] != 1 )
  println("FATAL ERROR : Invalid number of args. Input file is required as @arg1.")
  quit()
end

window_size = 5


# open input file
fd = open(ARGS[1], "r")
vals = readlines(ARGS[1])
if (size(vals)[1] <= 1)
  println("INVALID INPUT : Not enough data for meaningful answer.")
  quit()
end

# convert to int array
measures = [parse(Int,x) for x in vals]

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
# println("~~~ DEPTH LOGS ~~~")
# for result in res
#   println(result)
# end
# println()

# print AoC result
cpt = 0
for log in res
  if log.slope == 1
    global cpt += log.length
  end
end
println("Number of larger than previous measures : $cpt")

# - part 2
res2 = DEPTH_LOG_WINDOW[]
for i=window_size:n
  depth_log_wdw = DEPTH_LOG_WINDOW(i, 0)
  for j=0:window_size-1
    depth_log_wdw.value += measures[i-j]
  end
  push!(res2, depth_log_wdw)
end

# Find how many sliding windows values are superior than their precedecessors
cpt2=0
for k=1:size(res2)[1]
  if (k==1)
    continue
  end
  if res2[k].value > res2[k-1].value
    global cpt2 += 1
  end
end
println("Number of larger than previous sliding windows of size $window_size : $cpt2")

# close file
close(fd)