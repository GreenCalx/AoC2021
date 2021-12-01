

# open file and store as a single string
open("inputs//day1_1.txt", "r") do io
    input = read(io, String)
end

# split the string in a vector and parse it as integers
data = parse.(Int, split(input))


##### part 1 #####

# bit-sum of all the "true" when checking for positive in the derivation of data
result1 = sum(0 .< diff(data))

println("part1: ", result1)


##### part 2 #####

# generate the new data (gliding window of 3 terms sum)
data3 = zeros(Int, length(data) - 2)
for i = 1:length(data)-2
    data3[i] = data[i] + data[i+1] + data[i+2]
end

# bit-sum of all the "true" when checking for positive in the derivation of data
result2 = sum(0 .< diff(data3))

println("part2: ", result2)
