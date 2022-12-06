
function part1()
    s = ""

    for l in eachline("input/day6/input")
        s = l
        break
    end

    x = 0

    for i in 1:length(s)
        if length(Set(s[i:i+3])) == 4
            @show s[i:i+3]
            return i + 3
        end
    end
end

function part2()
    s = ""

    for l in eachline("input/day6/input")
        s = l
        break
    end

    x = 0

    for i in 1:length(s)
        if length(Set(s[i:i+13])) == 14
            return i + 13
        end
    end
end
