

########## Fish ##########

mutable struct Fish
    cycle::UInt8
end

cycle(f::Fish) = f.cycle

function next_day!(fish::Fish)
    (spawn = cycle(fish) == 0x00) ? fish.cycle = 0x06 : fish.cycle -= 0x01
    return spawn
end

function next_day!(fishes::Vector{Fish})
    n_spawns = sum(next_day!.(fishes))
    append!(fishes, Fish.(0x08 * ones(UInt8, n_spawns)))
    return n_spawns
end


########## Script ##########

function main()

    # open file and store content into an input string
    input = open("inputs//day6.txt", "r") do io
        read(io, String)
    end

    # split input into a data vector
    data = String.(split(input, ","))

    # parse data as a vector of fishes
    fishes = Fish.(parse.(UInt8, data))

    # part 1
    count::BigInt = length(fishes)
    for _ = 1:80
        count += next_day!(fishes)
    end
    println("part 1: ", count)

    # part 2
    for _ = 81:256
        count += next_day!(fishes)
    end
    println("part 2: ", count)

end

main()
