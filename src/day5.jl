
function part1()
    top, bottom = split(read("input/day5/input", String), "\n\n")

    s_top = split(top, "\n")

    nstacks = length(split(s_top[end]))

    stacks = [Char[] for _ in 1:nstacks]

    for l in s_top[1:end-1]
        j = 2
        for i in 1:nstacks
            if l[j] != ' '
                push!(stacks[i], l[j])
            end
            j += 4
        end
    end

    display(stacks)

    for l in split(bottom, "\n")
        if !isempty(l)
            _, a, _, b, _, c = split(l)

            a = parse(Int, a)
            b = parse(Int, b)
            c = parse(Int, c)

            for _ in 1:a
                if !isempty(stacks[b])
                    pushfirst!(stacks[c], popfirst!(stacks[b]))
                end
            end
        end
    end

    String([first(c) for c in stacks if !isempty(c)])
end

function part2()
    top, bottom = split(read("input/day5/input", String), "\n\n")

    s_top = split(top, "\n")

    nstacks = length(split(s_top[end]))

    stacks = [Char[] for _ in 1:nstacks]

    for l in s_top[1:end-1]
        j = 2
        for i in 1:nstacks
            if l[j] != ' '
                push!(stacks[i], l[j])
            end
            j += 4
        end
    end

    display(stacks)

    for l in split(bottom, "\n")
        if !isempty(l)
            _, a, _, b, _, c = split(l)

            a = parse(Int, a)
            b = parse(Int, b)
            c = parse(Int, c)

            tmpstack = Char[]

            for _ in 1:a
                pushfirst!(tmpstack, popfirst!(stacks[b]))
            end

            for _ in 1:a
                pushfirst!(stacks[c], popfirst!(tmpstack))
            end
        end
    end

    String([first(c) for c in stacks if !isempty(c)])
end
