

########## Useful functions ##########

suite(a, b) = a <= b ? (a : b) : (a : -1 : b)


########## Point ##########

struct Point
    x::Int
    y::Int
end

x(p::Point) = p.x
y(p::Point) = p.y

Point((x, y)::Tuple{Int, Int}) = Point(x, y)
Point(entry::String) = Point(Tuple(parse.(Int, String.(split(entry, ",")))))


########## Line ##########

struct Line
    points::Vector{Point}
    is_straight::Bool
end

points(l::Line) = l.points
is_straight(l::Line) = l.is_straight

function Line(entry::String, include_diagonals::Bool)
    a, b = Point.(String.(split(entry, " -> ")))
    Line(a, b, include_diagonals)
end

function Line(a::Point, b::Point, include_diagonals)
    
    is_straight = x(a) == x(b) || y(a) == y(b)
    if include_diagonals
        is_straight = is_straight || (abs(x(a) - x(b)) == abs(y(a) - y(b)))
    end

    is_straight ? points = Point.(suite(x(a), x(b)), suite(y(a), y(b))) : points = [a, b]

    Line(points, is_straight)
end


########## generate_grid and danger_score ##########

function generate_grid(lines::Vector{Line})
    grid = Dict{Point, Int}()
    for line in lines
        if is_straight(line)
            for point in points(line)
                get(grid, point, 0) > 0 ? grid[point] += 1 : grid[point] = 1
            end
        end
    end
    grid
end

danger_score(grid::Dict{Point, Int}) = sum(values(grid) .> 1)


########## Script ##########

function main()

    # open file and store content into an input string
    input = open("inputs//day5.txt", "r") do io
        read(io, String)
    end

    # split input into a data vector
    data = String.(split(input, "\r\n"))

    # part1
    grid1 = generate_grid(Line.(data, false))
    println("part 1: ", danger_score(grid1))

    # part2
    grid2 = generate_grid(Line.(data, true))
    println("part 2: ", danger_score(grid2))

end

main()
