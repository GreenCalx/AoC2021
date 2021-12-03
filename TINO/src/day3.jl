

function bool2int(vec::BitVector)

    num::Int = 0
    reversed_vec = reverse(vec)

    for n = 1 : length(vec)
        num += reversed_vec[n] * 2 ^ (n - 1)
    end

    num

end


function main()

    # open file and store content into a string
    input = open("inputs//day3.txt", "r") do io
        read(io, String)
    end

    # split and collect input into a data Vector{Vector{Char}} of '0's and '1's
    data = collect.(split(input))
    n_data = length(data)
    n_bits = length(data[1])

    # build a Matrix{Bool} from data
    matrix = Matrix{Bool}(undef, n_data, n_bits)
    for m = 1 : n_data
        for n = 1 : n_bits
            matrix[m, n] = parse(Bool, data[m][n])
        end
    end

    ########## part 1 ##########

    gamma_rate_bits = BitVector(undef, n_bits)
    for n = 1 : n_bits
        gamma_rate_bits[n] = sum(matrix[:, n]) >= n_data / 2
    end
    gamma_rate = bool2int(gamma_rate_bits)
    epsilon_rate = bool2int(gamma_rate_bits .== false)

    println("part 1: ", gamma_rate * epsilon_rate)

    ########## part 2 ##########

    matrix_O2 = copy(matrix)
    for n = 1 : n_bits
        n_data = size(matrix_O2, 1)
        if n_data == 1
            break
        end
        bit_criteria = sum(matrix_O2[:, n]) >= n_data / 2
        new_matrix_O2 = Matrix{Bool}(undef, 0, n_bits)
        for m = 1 : n_data
            if matrix_O2[m, n] == bit_criteria
                new_matrix_O2 = vcat(new_matrix_O2, matrix_O2[m, :]')
            end
        end
        matrix_O2 = copy(new_matrix_O2)
    end
    O2_rate_bits = BitVector(vec(matrix_O2))
    O2_rate = bool2int(O2_rate_bits)

    matrix_CO2 = copy(matrix)
    for n = 1 : n_bits
        n_data = size(matrix_CO2, 1)
        if n_data == 1
            break
        end
        bit_criteria = sum(matrix_CO2[:, n]) < n_data / 2
        new_matrix_CO2 = Matrix{Bool}(undef, 0, n_bits)
        for m = 1 : n_data
            if matrix_CO2[m, n] == bit_criteria
                new_matrix_CO2 = vcat(new_matrix_CO2, matrix_CO2[m, :]')
            end
        end
        matrix_CO2 = copy(new_matrix_CO2)
    end
    CO2_rate_bits = BitVector(vec(matrix_CO2))
    CO2_rate = bool2int(CO2_rate_bits)

    println("part 2: ", O2_rate * CO2_rate)

end

main()
