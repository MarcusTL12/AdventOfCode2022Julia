
function part1()
    x = 0

    for l in eachline("input/day4/input")
        a, b = split(l, ",")

        a1, a2 = split(a, "-")
        b1, b2 = split(b, "-")

        s1 = parse(Int, a1):parse(Int, a2)
        s2 = parse(Int, b1):parse(Int, b2)

        if isempty(setdiff(s1, s2)) || isempty(setdiff(s2, s1))
            x += 1
        end
    end

    x
end

function part2()
    x = 0

    for l in eachline("input/day4/input")
        a, b = split(l, ",")

        a1, a2 = split(a, "-")
        b1, b2 = split(b, "-")

        s1 = parse(Int, a1):parse(Int, a2)
        s2 = parse(Int, b1):parse(Int, b2)

        if !isempty(intersect(s1, s2))
            x += 1
        end
    end

    x
end
