
import Base: ==


@enum Digit d_0 d_1 d_2 d_3 d_4 d_5 d_6 d_7 d_8 d_9 d_unknown=-1
@enum Segment a=Int('a') b=Int('b') c=Int('c') d=Int('d') e=Int('e') f=Int('f') g=Int('g')


########## Display ##########

mutable struct Display
    signal::Vector{Segment}
    digit::Digit
end

Display() = Display(Vector{Segment}(undef, 0), d_unknown)

function Display(signal_str::String)
    signal = Segment.(Int.(collect(signal_str)))
    n_segments = length(signal)
    n_segments == 2 ? digit = d_1 :
    n_segments == 3 ? digit = d_7 :
    n_segments == 4 ? digit = d_4 :
    n_segments == 7 ? digit = d_8 :
    digit = d_unknown
    Display(signal, digit)
end

Base.Int(display::Display) = Int(display.digit)

function contains(display, sub_display)
    for segment in sub_display.signal
        !(segment in display.signal) && return false
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

function Entry(entry_str::String)
    patterns_str, output_str = String.(split(entry_str, " | "))
    patterns = Display.(String.(split(patterns_str, " ")))
    output = Display.(String.(split(output_str, " ")))
    Entry(patterns, output)
end

Base.Int(entry::Entry) = parse(Int, join(string.(Int.(entry.output))))

function get_pattern(entry::Entry, digit::Digit)
    for pattern in entry.patterns
        pattern.digit == digit && return pattern
    end
    error("digit not found")
end

function decode!(entry::Entry)

    # d_9 => d_4 & 6 segments
    pattern_4 = get_pattern(entry, d_4)
    pattern_9 = Display()
    for pattern in entry.patterns
        if pattern.digit == d_unknown && length(pattern.signal) == 6 && contains(pattern, pattern_4)
            pattern.digit = d_9
            pattern_9 = pattern
            break
        end
    end

    # e => d_8 - d_9
    segment_e = nothing
    pattern_8 = get_pattern(entry, d_8)
    for segment in pattern_8.signal
        if !(segment in pattern_9.signal)
            segment_e = segment 
            break
        end
    end

    # d_2 => e & 5 segments
    pattern_2 = Display()
    for pattern in entry.patterns
        if pattern.digit == d_unknown && length(pattern.signal) == 5 && segment_e in pattern.signal
            pattern.digit = d_2
            pattern_2 = pattern
            break
        end
    end

    # c => in d_1 & in d_2
    segment_c = nothing
    pattern_1 = get_pattern(entry, d_1)
    for segment in pattern_1.signal
        if segment in pattern_2.signal
            segment_c = segment
            break
        end
    end

    # d_0 => c & 6 segments
    for pattern in entry.patterns
        if pattern.digit == d_unknown && length(pattern.signal) == 6 && segment_c in pattern.signal
            pattern.digit = d_0
            break
        end
    end

    # d_6 => 6 segments
    pattern_6 = Display()
    for pattern in entry.patterns
        if pattern.digit == d_unknown && length(pattern.signal) == 6
            pattern.digit = d_6
            pattern_6 = pattern
            break
        end
    end

    # d_5 => in d_6
    for pattern in entry.patterns
        if pattern.digit == d_unknown && contains(pattern_6, pattern)
            pattern.digit = d_5
            break
        end
    end

    # d_3 => only one left
    for pattern in entry.patterns
        if pattern.digit == d_unknown
            pattern.digit = d_3
            break
        end
    end

    # match outputs with patterns
    for display in entry.output
        for pattern in entry.patterns
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
            result += display.digit !== d_unknown
        end
    end
    println("Part 1: ", result)

    # part 2
    outputs_number = decode!.(entries)
    println("Part 2: ", sum(outputs_number))

end

out = main()
