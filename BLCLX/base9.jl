function main()

  println("#######################")
  println("### AoC2021 - Day 8 ###")
  println("#######################")

  println(" 3 THREADS : 0.103469 seconds (139.97 k allocations: 7.868 MiB, 95.28% compilation time)")
  println(" 6 THREADS : 0.103764 seconds (140.03 k allocations: 7.872 MiB, 95.39% compilation time)")
  println(" 2 THREADS : 0.101803 seconds (139.96 k allocations: 7.867 MiB, 94.77% compilation time)")
  println(" 10 THREADS :  0.110305 seconds (140.11 k allocations: 7.878 MiB, 94.27% compilation time)")
  println(" 1 THREAD : 0.102803 seconds (139.96 k allocations: 7.866 MiB, 90.45% compilation time)")


  println(">> @arg1 : Input file")
  println()

  if ( size(ARGS)[1] != 1 )
    println("FATAL ERROR : Invalid number of args. Input file is required as @arg1.")
    quit()
  end

  if ( Threads.nthreads() <= 1)
    println("Launch threads in command by calling : julia --threads [n_threads] <...>")
  end

# open input file
fd = open(ARGS[1], "r")
vals = readlines(ARGS[1])
if (size(vals)[1] <= 1)
  println("INVALID INPUT : Not enough data for meaningful answer.")
  quit()
end

  # close file
  close(fd)


  # read matrix
  n_lines = length(vals)
  n_cols  = length(vals[1])

  matrix = zeros(Int, n_lines, n_cols)
  line = ""
  for i=1:n_lines
    line = vals[i]
    for j=1:length(line)
      matrix[i,j] = parse(Int,line[j])
    end
  end

  # thread compute matrixuu
  #println("input : $matrix \n")

  lowpoints = zeros(Int, n_lines, n_cols)
  # thread id repartiton per line
  Threads.@threads for t=1:n_lines

    tid = Threads.threadid()

    # create submatrixes to avoid mem conflict in each thread (naive repartiton)
    submatrix = Matrix{Int64}(undef,0,n_cols)
    
    is_firstline = ( t == 1)
    is_lastline =  ( t == n_lines )
    if (!is_firstline && !is_lastline)
      submatrix = matrix[(t-1):(t+1), :]
    elseif ( is_firstline )
      submatrix = matrix[t:(t+1), :]
    else
      submatrix = matrix[(t-1):t, :]
    end
    #println("SUBMAT  $t, thread $tid : $submatrix")

    # find low pointz
    for j=1:n_cols

      val = 0
      up = 0
      down = 0
      left = 0
      right = 0

      is_firstcol = (j==1)
      is_lastcol = (j == n_cols)
      
      if is_firstline
        val = submatrix[1,j]
        up = 9
        down = submatrix[2,j]
        right = is_lastcol ? 9 : submatrix[1,j+1]
        left = is_firstcol ? 9 : submatrix[1,j-1]
      elseif is_lastline
        val = submatrix[2,j]
        up = submatrix[1,j]
        down = 9
        right = is_lastcol ? 9 : submatrix[2,j+1]
        left = is_firstcol ? 9 : submatrix[2,j-1]
      else
        val = submatrix[2,j]
        up = submatrix[1,j]
        down = submatrix[3,j]
        right = is_lastcol ? 9 : submatrix[2,j+1]
        left = is_firstcol ? 9 : submatrix[2,j-1]
      end

      if ( (val < up) && (val < down) && (val < right) && (val<left) )
          lowpoints[t,j] = 1 + val
      end

    end

  end #!threads ends

  #println(lowpoints)
  tot_risk = sum(lowpoints)
  println("RESULT P1 : $tot_risk" )


end

@time main()