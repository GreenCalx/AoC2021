

########## Basin ##########

mutable struct Basin
    spread::Int
end

spread(basin::Basin) = basin.spread
spread(::Nothing) = 0

Basin() = Basin(1)


########## Location ##########

mutable struct Location
    height::Int
    neighbors::Vector{Location}
    basin::Union{Basin, Nothing, Missing}
end

height(location::Location) = location.height
neighbors(location::Location) = location.neighbors
basin(location::Location) = location.basin

Location(height::Int) = 
    Location(height, Vector{Location}(undef, 0), missing)

link!(location::Location, neighbor::Location) = 
    append!(neighbors(location), [neighbor])

function process!(locations::Matrix{Location})
    bottom_pits = Location[]
    for (x, y) in Tuple.(CartesianIndices(locations))
        location = locations[x, y]
        x > firstindex(locations, 1) && link!(location, locations[x - 1, y])
        x < lastindex(locations, 1)  && link!(location, locations[x + 1, y])
        y > firstindex(locations, 2) && link!(location, locations[x, y - 1])
        y < lastindex(locations, 2)  && link!(location, locations[x, y + 1])

        if all(height(location) .< height.(neighbors(location)))
            location.basin = Basin()
            append!(bottom_pits, [location])
        elseif height(location) == 9
            location.basin = nothing
        end
    end
    return bottom_pits
end

function check!(location::Location, local_basin::Basin)
    !ismissing(basin(location)) && return false
    local_basin.spread += 1
    location.basin = local_basin
    return true
end

function measure!(bottom_pit::Location)
    local_basin = basin(bottom_pit)
    locations = [bottom_pit]
    while !isempty(locations)
        locations = [neighbor 
            for location in locations 
            for neighbor in neighbors(location)
            if check!(neighbor, local_basin)]
    end
    return spread(local_basin)
end


########## Script ##########

function main()

    # open file and store content into an input string
    input = open("inputs//day9.txt", "r") do io
        read(io, String)
    end

    # split input into a data vector of vector of integers
    data = [parse.(Int, collect(row)) 
        for row in String.(split(input, "\r\n"))]

    # parse data into a matrix of locations
    locations = Location.([data[i][j] 
        for i = 1:length(data), j = 1:length(data[1])])

    # establish neighbors and extract bottom pits
    # (and then forget about coordinates forever)
    bottom_pits = process!(locations)

    # part 1
    risk_level = sum(height.(bottom_pits) .+ 1)
    println("Part 1: ", risk_level)

    # part 2
    basins_spreads = sort(measure!.(bottom_pits))
    result = prod(basins_spreads[(end - 2):end])
    println("Part 2: ", result)

    # for a nice bonus drawing
    return spread.(basin.(locations))
            
end

main();
