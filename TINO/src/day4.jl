

########## Bingo ##########

mutable struct Bingo
    grid::Matrix{Int}
    checks::BitMatrix
end

# gets
grid(b::Bingo) = b.grid
checks(b::Bingo) = b.checks

# constructors

Bingo(n_row::Int) = Bingo(zeros(n_row, n_row), zeros(n_row, n_row))

function Bingo(entry::String)
    rows_str = String.(split(entry, "\r\n"))
    n_row = length(rows_str)
    bingo = Bingo(n_row)
    for n = 1 : n_row
        bingo.grid[n, :] = parse.(Int, String.(split(rows_str[n])))'
    end
    bingo
end

# methods

function reset!(bingo::Bingo)
    bingo.checks .= 0
    return nothing
end

function win(bingo::Bingo)
    n_row = size(grid(bingo), 1)
    for n = 1 : n_row
        if sum(checks(bingo)[:, n]) == n_row || sum(checks(bingo)[n, :]) == n_row
            return true
        end
    end
    return false
end

function check!(bingo::Bingo, num::Int)
    bingo.checks += grid(bingo) .== num
    win(bingo)
end

score(bingo::Bingo, num::Int) = num * sum(grid(bingo) .* (checks(bingo) .== false))


########## Part 1 ##########

function play_for_win!(bingos::Vector{Bingo}, numbers:: Vector{Int})
    reset!.(bingos)
    for num in numbers
        for bingo in bingos
            check!(bingo, num) && return score(bingo, num)
        end
    end
    error("something went wrong")
end


########## Part 2 ##########

function play_for_lose!(bingos::Vector{Bingo}, numbers:: Vector{Int})
    reset!.(bingos)
    n_bingo = length(bingos)
    winning_bingos = zeros(Bool, n_bingo)
    for num in numbers
        for n = 1 : n_bingo
            if !winning_bingos[n]
                winning_bingos[n] = check!(bingos[n], num)
                sum(winning_bingos) == n_bingo && return score(bingos[n], num)
            end
        end
    end
    error("something went wrong")
end


########## Script ##########

function main()

    # open file and store content into an input string
    input = open("inputs//day4.txt", "r") do io
        read(io, String)
    end

    # split input into a vector
    data = String.(split(input, "\r\n\r\n"))
    # parse first line as integers
    numbers = parse.(Int, String.(split(data[1], ",")))
    # parse the rest as bingos
    bingos = Bingo.(data[2:end])

    println("Part 1: ", play_for_win!(bingos, numbers))
    println("Part 2: ", play_for_lose!(bingos, numbers))

end

main()
