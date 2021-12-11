

########## Dumbo ##########

mutable struct Dumbo
    energy::Int
    neighbors::Vector{Dumbo}
    has_flashed::Bool
end
energy(dumbo::Dumbo) = dumbo.energy
has_flashed(dumbo::Dumbo) = dumbo.has_flashed
neighbors(dumbo::Dumbo) = dumbo.neighbors

Dumbo(energy::Int) = Dumbo(energy, Vector{Dumbo}[], false)

is_ready(dumbo::Dumbo) = !has_flashed(dumbo) && energy(dumbo) > 9

energize!(dumbo::Dumbo) = dumbo.energy += 1

function reset!(dumbo::Dumbo) 
    if has_flashed(dumbo)
        dumbo.energy = 0
        dumbo.has_flashed = false
    end
end

function flash!(dumbo::Dumbo)
    dumbo.has_flashed = true
    energize!.(neighbors(dumbo))
    for neighbor in neighbors(dumbo)
        is_ready(neighbor) && flash!(neighbor)
    end
end

function set_neighbors!(dumbos::Matrix{Dumbo})
    indices = Tuple.(CartesianIndices(dumbos))
    for (x, y) in indices
        # 3 by 3 matrix centered on the current position but excluding said position
        # as well as positions outside the reference matrix
        neighbors_indices = indices ∩ 
            [(x2, y2) for x2 = x .+ (-1:1), y2 = y .+ (-1:1) if (x2, y2) != (x, y)]

        dumbos[x, y].neighbors = [dumbos[x2, y2] for (x2, y2) in neighbors_indices]
    end
end

function step!(dumbos::Matrix{Dumbo})::Tuple{Int, Bool}
    energize!.(dumbos)
    for dumbo in dumbos
        is_ready(dumbo) && flash!(dumbo)
    end
    flashes = has_flashed.(dumbos)
    n_flashes = sum(flashes)
    synchronized = all(flashes)
    reset!.(dumbos)
    return n_flashes, synchronized
end


########## Script ##########

function main(input_name::String)

    # open file and store content into an input string
    input = open(join(["inputs//", input_name]), "r") do io
        read(io, String)
    end

    # split input into a data vector of vector of integers
    data = [parse.(Int, collect(row)) 
        for row in String.(split(input, "\r\n"))]

    # parse data into a matrix of dumbos and set neighbors
    dumbos = Dumbo.([data[i][j] 
        for i = 1:length(data), j = 1:length(data[1])])
    set_neighbors!(dumbos)

    # a bit of complexity to make sure part 2 does'nt end the loop 
    # before part 1 is done and vice-versa (unecessary for the input
    # I got but I pretend I don't know that)
    total_flashes = 0
    synchronized = false
    has_synchronized = false
    step_sync = Inf
    step = 0
    while !synchronized || step <= 100
        step += 1
        n_flashes, synchronized = step!(dumbos)

        # part 1
        step <= 100 && (total_flashes += n_flashes)

        # part 2
        if synchronized && !has_synchronized
            step_sync = step
            has_synchronized = true
        end
    end
    println("Part 1: ", total_flashes)
    println("Part 2: ", step_sync)
    
end

main("day11.txt");
