

########## Functions ##########

cost(pos1, pos2) = abs(pos1 - pos2)

function cost2(pos1, pos2)::Int
    n_step = cost(pos1, pos2)
    n_step * (n_step + 1) / 2
end

optimal_cost(cost_fn, data) = 
    minimum([sum(cost_fn.(data, pos)) for pos in 0:maximum(data)])


########## Script ##########

function main()

    # open file and store content into an input string
    input = open("inputs//day7.txt", "r") do io
        read(io, String)
    end

    # split input into a data vector of numbers
    data = parse.(Int, String.(split(input, ",")))
    
    println("part 1: ", optimal_cost(cost, data))
    println("part 2: ", optimal_cost(cost2, data))

end

main()
