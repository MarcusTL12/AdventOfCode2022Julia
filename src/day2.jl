
function part1()
    score = 0

    for l in eachline("input/day2/input")
        abc, _, xyz = l

        a = abc - 'A'
        b = xyz - 'X'

        score += (b + 1) + (b - a + 4) % 3 * 3
    end

    score
end

function part2()
    score = 0

    for l in eachline("input/day2/input")
        abc, _, xyz = l

        a = abc - 'A'
        b = xyz - 'X'

        score += b * 3 + (b + a + 2) % 3 + 1
    end

    score
end
