
function parse_stacks(lines)
    stacks = Vector{Char}[]

    for l in lines
        if l[2] == '1'
            popfirst!(lines)
            break
        end

        if isempty(stacks)
            append!(stacks, Char[] for _ in 1:cld(length(l), 4))
        end

        j = 2
        for i in eachindex(stacks)
            if l[j] != ' '
                pushfirst!(stacks[i], l[j])
            end
            j += 4
        end
    end

    stacks
end

function part1()
    lines = Iterators.Stateful(eachline("input/day5/input"))

    stacks = parse_stacks(lines)

    for l in lines
        _, a, _, b, _, c = split(l)

        a = parse(Int, a)
        b = parse(Int, b)
        c = parse(Int, c)

        for _ in 1:a
            push!(stacks[c], pop!(stacks[b]))
        end
    end

    String([last(c) for c in stacks])
end

function part2()
    lines = Iterators.Stateful(eachline("input/day5/input"))

    stacks = parse_stacks(lines)

    for l in lines
        _, a, _, b, _, c = split(l)

        a = parse(Int, a)
        b = parse(Int, b)
        c = parse(Int, c)

        append!(stacks[c], @view stacks[b][end-(a-1):end])
        resize!(stacks[b], length(stacks[b]) - a)
    end

    String([last(c) for c in stacks])
end
