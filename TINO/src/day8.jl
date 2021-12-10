
import Base: ==


########## Display ##########

@enum Segment a=Int('a') b=Int('b') c=Int('c') d=Int('d') e=Int('e') f=Int('f') g=Int('g')

mutable struct Display
    signal::Vector{Segment}
    digit::Union{Int, Missing}
end

signal(display::Display) = display.signal
digit(display::Display) = display.digit
decoded(display::Display) = !ismissing(digit(display))

Display() = Display(Vector{Segment}(undef, 0), missing)

function Display(signal_str::String)
    signal = Segment.(Int.(collect(signal_str)))
    n_segments = length(signal)
    n_segments == 2 ? digit = 1 :
    n_segments == 3 ? digit = 7 :
    n_segments == 4 ? digit = 4 :
    n_segments == 7 ? digit = 8 :
    digit = missing
    Display(signal, digit)
end

Base.Int(display::Display) = 
    decoded(display) ? digit(display) : error("display not decoded")

function contains(display, sub_display)
    for segment in signal(sub_display)
        !(segment in signal(display)) && return false
    end
    return true
end

display1::Display == display2::Display =
    contains(display1, display2) && contains(display2, display1)


########## Entry ##########

mutable struct Entry 
    patterns::Vector{Display}
    output::Vector{Display}
end

patterns(entry::Entry) = entry.patterns
output(entry::Entry) = entry.output

function Entry(entry_str::String)
    patterns_str, output_str = String.(split(entry_str, " | "))
    patterns = Display.(String.(split(patterns_str, " ")))
    output = Display.(String.(split(output_str, " ")))
    Entry(patterns, output)
end

Base.Int(entry::Entry) = parse(Int, join(string.(Int.(output(entry)))))

function get_pattern(entry::Entry, digit::Int)
    for pattern in patterns(entry)
        if decoded(pattern)
            Int(pattern) == digit && return pattern
        end
    end
    error("digit not found")
end

function decode!(entry::Entry)

    # d_9 => d_4 & 6 segments
    pattern_9 = Display()
    pattern_4 = get_pattern(entry, 4)
    for pattern in patterns(entry)
        if !decoded(pattern) && length(signal(pattern)) == 6 && contains(pattern, pattern_4)
            pattern.digit = 9
            pattern_9 = pattern
            break
        end
    end

    # e => d_8 - d_9
    segment_e = nothing
    pattern_8 = get_pattern(entry, 8)
    for segment in signal(pattern_8)
        if !(segment in signal(pattern_9))
            segment_e = segment 
            break
        end
    end

    # d_2 => e & 5 segments
    pattern_2 = Display()
    for pattern in patterns(entry)
        if !decoded(pattern) && length(signal(pattern)) == 5 && segment_e in signal(pattern)
            pattern.digit = 2
            pattern_2 = pattern
            break
        end
    end

    # c => in d_1 & in d_2
    pattern_1 = get_pattern(entry, 1)
    segment_c = only(signal(pattern_1) ∩ signal(pattern_2))

    # d_0 => c & 6 segments
    for pattern in patterns(entry)
        if !decoded(pattern) && length(signal(pattern)) == 6 && segment_c in signal(pattern)
            pattern.digit = 0
            break
        end
    end

    # d_6 => 6 segments
    pattern_6 = Display()
    for pattern in patterns(entry)
        if !decoded(pattern) && length(signal(pattern)) == 6
            pattern.digit = 6
            pattern_6 = pattern
            break
        end
    end

    # d_5 => in d_6
    for pattern in patterns(entry)
        if !decoded(pattern) && contains(pattern_6, pattern)
            pattern.digit = 5
            break
        end
    end

    # d_3 => only one left
    for pattern in patterns(entry)
        if !decoded(pattern)
            pattern.digit = 3
            break
        end
    end

    # match outputs with patterns
    for display in output(entry)
        for pattern in patterns(entry)
            if display == pattern
                display.digit = pattern.digit
                break
            end
        end
    end

    return Int(entry)

end


########## Script ##########

function main()

    # open file and store content into an input string
    input = open("inputs//day8.txt", "r") do io
        read(io, String)
    end

    # split input into a data vector
    data = String.(split(input, "\r\n"))

    # parse data as a vector of entries
    entries = Entry.(data)

    # part 1
    result = 0
    for entry in entries
        for display in entry.output
            result += decoded(display)
        end
    end
    println("Part 1: ", result)

    # part 2
    outputs_number = decode!.(entries)
    println("Part 2: ", sum(outputs_number))
    
end

main()
