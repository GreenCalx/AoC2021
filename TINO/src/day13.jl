

########## Fold ##########

@enum Fold_type f_x=Int('x') f_y=Int('y')

struct Fold{Fold_type}
    line::Int
end
line(fold::Fold) = fold.line

Fold(entry::String) = 
    Fold{Fold_type(Int(entry[12]))}(parse(Int, entry[14:end]))


########## Point ##########

mutable struct Point
    x::Int
    y::Int
end
x(point::Point) = point.x
y(point::Point) = point.y

Point(entry::String) = 
    Point(parse.(Int, String.(split(entry, ",")))...)

Base.:(==)(point1::Point, point2::Point)::Bool =
    x(point1) == x(point2) && y(point1) == y(point2)


########## functions ##########

mirror(coord::Int, line::Int)::Int = 
    coord - line > 0 ? 2 * line - coord : coord

fold!(point::Point, fold::Fold{f_x}) = 
    point.x = mirror(x(point), line(fold))
fold!(point::Point, fold::Fold{f_y}) =
    point.y = mirror(y(point), line(fold))

function Base.unique(points::Vector{Point})
    result = Point[]
    for point in points
        !(point in result) && append!(result, [point])
    end
    return result
end

function fold!(points::Vector{Point}, fold::Fold)
    for point in points
        fold!(point, fold)
    end
    points = unique(points)
end

function code(points::Vector{Point})::Vector{String}
    width = maximum(x.(points))
    height = maximum(y.(points))
    return [join(row) for row in eachrow(
        [exist ? '#' : '.' for exist in 
            [Point(x, y) in points for x = 0:width, y = 0:height]'
        ]
    )]
end


########## Script ##########

function main(input_name::String)

    # open file and store content into an input string
    input = open(join(["inputs//", input_name]), "r") do io
        read(io, String)
    end

    # split input into a the points part and the folding instructions part
    data = String.(split(input, "\r\n\r\n"))
    # parse data as a vector of points and a vector of fold instructions
    points = Point.(String.(split(data[1], "\r\n")))
    folds = Fold.(String.(split(data[2], "\r\n")))

    # part 1
    fold!(points, folds[1])
    println("Part 1: ", length(points))

    # part 2
    for fold in folds[2:end]
        fold!(points, fold)
    end
    println("Part 2: ")
    for row in eachrow(code(points))
        println(row)
    end

end

main("day13.txt");
