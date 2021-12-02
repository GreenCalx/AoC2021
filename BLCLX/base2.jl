#structs & enums

# consts
const forward="forward"
const down="down"
const up="up"


mutable struct INSTRUCTION
  X::Int
  Z::Int
  INSTRUCTION() = new(0, 0)
end
function parseInstruction(instruction::INSTRUCTION, direction::String, svalue::String)

  instruction.X = 0
  instruction.Z = 0

  value = parse(Int,svalue)
  if direction == forward
    instruction.X = value
  elseif direction == down
    instruction.Z = value
  elseif direction == up
    instruction.Z = (-1)*value
  end
end

mutable struct SUBMARINE
  X::Int
  Z::Int
  AIM::Int
  DEPTH::Int
  SUBMARINE() = new(0,0,0,0)
end
function updateSub(sub::SUBMARINE, iX::Int64, iZ::Int64)
  sub.X += iX
  sub.Z += iZ
  sub.AIM += iZ
  if iX > 0
    sub.DEPTH += ( sub.AIM * iX )
  end
end

println("#######################")
println("### AoC2021 - Day 2 ###")
println("#######################")

println(">> @arg1 : Input file")
println()

if ( size(ARGS)[1] != 1 )
  println("FATAL ERROR : Invalid number of args. Input file is required as @arg1.")
  quit()
end


# open input file
fd = open(ARGS[1], "r")
vals = readlines(ARGS[1])
if (size(vals)[1] <= 1)
  println("INVALID INPUT : Not enough data for meaningful answer.")
  quit()
end
n = size(vals)[1]

# interpret lines
# > DIRECTION : VAL
submarine   = SUBMARINE()
instruction = INSTRUCTION()

for i=1:n
  line = vals[i]
  splitted = split(line, " ")
  if (size(splitted)[1] != 2 )
    println("INVALID INPUT : Bad line length in input data for line : $splitted")
  end
  parseInstruction(instruction, String(splitted[1]), String(splitted[2]))
  updateSub( submarine, instruction.X, instruction.Z) 
end

subx = submarine.X
subz = submarine.Z
println("SUBMARINE : $subx:$subz")

submul = subx * subz
println("PART 1 RESULT : $submul")

submul2 = subx * submarine.DEPTH
println("PART 2 RESULT : $submul2")

# close file
close(fd)