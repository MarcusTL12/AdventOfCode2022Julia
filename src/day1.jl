
function part1()
    elves = Int[]

    elf = Int[]

    for l in eachline("input/day1/input")
        if length(l) == 0
            push!(elves, sum(elf))
            empty!(elf)
        else
            push!(elf, parse(Int, l))
        end
    end

    maximum(elves)
end

function part2()
    elves = Int[]

    elf = Int[]

    for l in eachline("input/day1/input")
        if length(l) == 0
            push!(elves, sum(elf))
            empty!(elf)
        else
            push!(elf, parse(Int, l))
        end
    end

    sort!(elves)

    sum(elves[end-2:end])
end
