using Base: String, Int
import Base.+


########## Command ##########

@enum Direction forward down up

struct Command{Direction}

    coeff::Int

end

function Command(entry::String)

    direction_string, coeff_string = split(entry)

    direction_string == "forward" ? direction = forward : 
    direction_string == "down" ? direction = down : 
    direction_string == "up" ? direction = up : 
    error("wrong command direction")
    
    Command{direction}(parse(Int, coeff_string))

end

coeff(c::Command) = c.coeff


########## Coordinates ##########

struct Coordinates

    x::Int
    y::Int

end

Coordinates() = Coordinates(0, 0)

x(c::Coordinates) = c.x
y(c::Coordinates) = c.y

+(a::Coordinates, b::Coordinates) = Coordinates(x(a) + x(b), y(a) + y(b))


########## Submarines_type 1 ##########

mutable struct Submarine_type1

    position::Coordinates

end

Submarine_type1() = Submarine_type1(Coordinates())

position(s::Submarine_type1) = s.position

instruct!(submarine::Submarine_type1, command::Command{forward}) = (submarine.position += Coordinates(coeff(command), 0))
instruct!(submarine::Submarine_type1, command::Command{down}) = (submarine.position += Coordinates(0, coeff(command)))
instruct!(submarine::Submarine_type1, command::Command{up}) = (submarine.position += Coordinates(0, -coeff(command)))


########## Submarines_type 2 ##########

mutable struct Submarine_type2

    position::Coordinates
    aim::Int

end

Submarine_type2() = Submarine_type2(Coordinates(), 0)

position(s::Submarine_type2) = s.position
aim(s::Submarine_type2) = s.aim

instruct!(submarine::Submarine_type2, command::Command{forward}) = (submarine.position += Coordinates(coeff(command), aim(submarine) * coeff(command)))
instruct!(submarine::Submarine_type2, command::Command{down}) = (submarine.aim += coeff(command))
instruct!(submarine::Submarine_type2, command::Command{up}) = (submarine.aim -= coeff(command))


########## Script ##########

function main()

    # open file and store content into a string
    input = open("inputs//day2.txt", "r") do io
        read(io, String)
    end

    # split the string into a vector and parse it as Commands
    data = Command.(String.(split(input, "\r\n")))

    # instantiate submarine
    submarine1 = Submarine_type1()
    submarine2 = Submarine_type2()

    # send all instructions
    for command in data
        instruct!(submarine1, command)
        instruct!(submarine2, command)
    end

    println("part1: ", x(position(submarine1)) * y(position(submarine1)))
    println("part2: ", x(position(submarine2)) * y(position(submarine2)))

end

main()
