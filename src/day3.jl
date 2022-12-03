
function priority(c)
    if islowercase(c)
        c - 'a' + 1
    else
        c - 'A' + 27
    end
end

function part1()
    x = 0

    for l in eachline("input/day3/input")
        c, = intersect(
            (@view l[1:length(l)÷2]),
            (@view l[length(l)÷2+1:end])
        )

        x += priority(c)
    end

    x
end

function part2()
    lines = collect(eachline("input/day3/input"))

    x = 0

    for (a, b, c) in eachcol(reshape(lines, 3, length(lines) ÷ 3))
        s = intersect(a, b, c)

        ch, = s
        x += priority(ch)
    end

    x
end
