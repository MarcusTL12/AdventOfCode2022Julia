
function part1()
    score = 0

    for l in eachline("input/day2/input")
        abc, xyz = split(l)

        tmp = 0

        tmp += xyz[1] - 'X' + 1

        if abc == "A" && xyz == "Y" || abc == "B" && xyz == "Z" || abc == "C" && xyz == "X"
            tmp += 6
        end

        if (abc[1] - 'A') == (xyz[1] - 'X')
            tmp += 3
        end

        score += tmp
    end

    score
end

function part2()
    lookup = Dict([
        ('A', 'X') => 3,
        ('A', 'Y') => 3 + 1,
        ('A', 'Z') => 2 + 6,
        ('B', 'X') => 1,
        ('B', 'Y') => 2 + 3,
        ('B', 'Z') => 3 + 6,
        ('C', 'X') => 2,
        ('C', 'Y') => 3 + 3,
        ('C', 'Z') => 1 + 6,
    ])

    score = 0

    for l in eachline("input/day2/input")
        abc, xyz = split(l)

        score += lookup[(abc[1], xyz[1])]
    end

    score
end
