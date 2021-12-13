

########## Cave ##########

mutable struct Cave
    name::String
    is_big::Bool
    connections::Vector{Cave}
    n_visits::Int
end
name(cave::Cave) = cave.name
is_big(cave) = cave.is_big
connections(cave::Cave) = cave.connections
n_visits(cave::Cave) = cave.n_visits

Cave(name::String) = Cave(name, isuppercase(name[1]), Cave[], 0)

visit!(cave::Cave) = cave.n_visits += 1

cancel_visit!(cave::Cave) = cave.n_visits -= 1

valid_connections(cave::Cave, n_visits_allowed_if_small_cave::Int)::Vector{Cave} =  
    [connected_cave for connected_cave in connections(cave) 
    if is_big(connected_cave) || n_visits(connected_cave) < n_visits_allowed_if_small_cave]


########## functions ##########

function find(caves::Vector{Cave}, ref_name::String)::Union{Cave, Missing}
    for cave in caves
        name(cave) == ref_name && return cave
    end
    return missing
end

function add_cave!(caves::Vector{Cave}, name::String)::Cave
    cave = find(caves, name)
    if ismissing(cave)
        cave = Cave(name)
        append!(caves, [cave])
    end
    return cave
end

function add_path!(caves::Vector{Cave}, entry::String)
    name1, name2 = String.(split(entry, "-"))
    cave1 = add_cave!(caves, name1)
    cave2 = add_cave!(caves, name2)
    append!(connections(cave1), [cave2])
    append!(connections(cave2), [cave1])
end

function try_paths!(caves::Vector{Cave}, allow_two_visits_in_a_single_small_cave::Bool)::Int
    # constants
    start_cave = find(caves, "start")
    visit!(start_cave)
    end_cave = find(caves, "end")
    
    # part 1 vs part 2
    allow_two_visits_in_a_single_small_cave ? 
        n_visits_allowed_in_small_caves = 2 : 
        n_visits_allowed_in_small_caves = 1
    special_small_cave = nothing

    # init complete current path, un-tried caves state and next caves
    n_paths = 0
    path = [start_cave]
    visit!(path[end])
    next_caves = valid_connections(path[end], n_visits_allowed_in_small_caves)
    tries = [length(next_caves)]

    # step forward and back in caves until all possible paths have been tried
    while !(path[end] == start_cave && tries[end] == 0)

        # end or dead-end case => step back to previous path state (end => add 1 to n_paths)
        if path[end] == end_cave || tries[end] == 0

            if path[end] == end_cave
                n_paths += 1
            end

            # erase every recordings since that point in time
            cancel_visit!(path[end])
            pop!(tries)
            if pop!(path) == special_small_cave
                special_small_cave = nothing
                n_visits_allowed_in_small_caves = 2
            end

            # possible next caves (regardless od the current tries state)
            next_caves = valid_connections(path[end], n_visits_allowed_in_small_caves)

        # normal case => step forward in the next un-tried possible cave for the current complete path state (tries)
        else

            append!(path, [next_caves[tries[end]]])
            visit!(path[end])
            if allow_two_visits_in_a_single_small_cave && !is_big(path[end]) && path[end] in path[1:(end - 1)]
                special_small_cave = path[end]
                n_visits_allowed_in_small_caves = 1
            end

            # mark current cave as already tried for the complete path previous state
            tries[end] -= 1

            # possible next caves (regardless od the current tries state)
            next_caves = valid_connections(path[end], n_visits_allowed_in_small_caves)

            # setup a new state of un-tried caves for the complete path
            append!(tries, [length(next_caves)])

        end
    end

    return n_paths
end

########## Script ##########

function main(input_name::String)

    # open file and store content into an input string
    input = open(join(["inputs//", input_name]), "r") do io
        read(io, String)
    end

    # split input into a data vector
    data = String.(split(input, "\r\n"))

    # use data to generate a vector of all caves
    caves = Cave[]
    for entry in data
        add_path!(caves, entry)
    end

    # part 1
    println("Part 1: ", try_paths!(caves, false))
    # part 2
    println("Part 2: ", try_paths!(caves, true))

end

main("day12.txt");
