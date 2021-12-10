

########## Script ##########

function main(input_name)

    # open file and store content into an input string
    input = open(join(["inputs//", input_name]), "r") do io
        read(io, String)
    end

    # split input into a data vector
    data = String.(split(input, "\r\n"))

    # tables from day10 instructions
    pairs = Dict('('=>')', '['=>']', '{'=>'}', '<'=>'>')
    score1 = Dict(')'=>3, ']'=>57, '}'=>1197, '>'=>25137)
    score2 = Dict(')'=>1, ']'=>2, '}'=>3, '>'=>4)
    
    # part 1 and 2
    total_score1 = 0
    total_scores2 = Int[]
    for line in data
        
        opened_chars = Char[]
        corrupted = false
        for char in line
            if char in keys(pairs)
                append!(opened_chars, [char])
            elseif char in values(pairs)
                if char == pairs[opened_chars[end]]
                    pop!(opened_chars)
                else
                    total_score1 += score1[char]
                    corrupted = true
                    break
                end
            end
        end

        if !corrupted
            total_score2 = 0
            for char in reverse(opened_chars)
                total_score2 *= 5
                total_score2 += score2[pairs[char]]
            end
            append!(total_scores2, [total_score2])
        end

    end
    sort!(total_scores2)

    println("Part 1: ", total_score1)
    println("Part 2: ", total_scores2[ceil(Int, length(total_scores2) / 2)])

end

main("day10.txt")
