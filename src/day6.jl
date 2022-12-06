
function solve(s, n)
    for i in 1:length(s)
        if length(Set(s[i:i+n-1])) == n
            return i + n - 1
        end
    end
end

function part1()
    solve(read("input/day6/input", String), 4)
end

function part2()
    solve(read("input/day6/input", String), 14)
end
