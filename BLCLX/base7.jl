

# consts

function GAZCost( start::Int64, finish::Int64)
  #puzzle 1
  #return abs( start- finish )

  #puzzle2
  cost = 0
  for i=1:abs(start-finish)
    cost += i
  end
  return cost
end

# methods
function computeGAZ( entry::Vector{Int64}, pivot::Int64)
  
  totgaz = 0
  n = size(entry)[1]
  if ( pivot > n)
    return Inf;
  elseif ( pivot < 1 )
    return Inf;
  end

  for i=1:n
    totgaz += GAZCost( entry[i] , pivot )
  end
  return totgaz
end

function findGAZ( entry::Vector{Int64}, index::Int64)

  current = computeGAZ(entry, index)
  upward  = computeGAZ(entry, index+1)
  downward= computeGAZ(entry, index-1)

  if ( (current<upward) && (current<downward) )
    return current
  end

  next_index =  (upward > downward) ? (index - 1) : (index + 1)
  return findGAZ( entry, next_index)

end


function main()

  println("#######################")
  println("### AoC2021 - Day 7 ###")
  println("#######################")

  println(">> @arg1 : Input file")
  println()

  if ( size(ARGS)[1] != 1 )
    println("FATAL ERROR : Invalid number of args. Input file is required as @arg1.")
    quit()
  end

  fd = open(ARGS[1], "r")
  data = split(read(fd, String), ",")

  crabs = [parse(Int,x) for x in data]
  n = size(crabs)[1]
  if (n <= 1)
    println("INVALID INPUT : Not enough data for meaningful answer.")
    quit()
  end

  sort!(crabs)

  # find candidate median halfway between min & max
  min = crabs[1]
  max = crabs[n]
  median = ( min + max ) / 2
  println(" Min : $min , Max : $max , Median : $median")

  # total gaz 
  minGaz = findGAZ( crabs, trunc(Int, median) )

  println("MIN GAZ : $minGaz")

  # close file
  close(fd)

end

@time main()