

########## functions ##########

function start_fishes(data)
    fishes = zeros(BigInt, 9)
    for day = 1:9
        fishes[day] = sum(data .== (day - 1))
    end
    return fishes
end

function live_another_day!(fishes)
    n_spawns = fishes[1]
    fishes[1:8] = fishes[2:9]
    fishes[9] = n_spawns
    fishes[7] += n_spawns
    return nothing
end


########## Script ##########

function main()

    # open file and store content into an input string
    input = open("inputs//day6.txt", "r") do io
        read(io, String)
    end

    # split input into a data vector of integers
    data = parse.(Int, String.(split(input, ",")))

    # initialize fishes table
    fishes = start_fishes(data)

    # part 1
    for _ = 1:80
        live_another_day!(fishes)
    end
    println("part 1: ", sum(fishes))

    # part 2
    for _ = 81:256
        live_another_day!(fishes)
    end
    println("part 1: ", sum(fishes))

end

main()
