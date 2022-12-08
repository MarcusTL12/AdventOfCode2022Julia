
function part1()
    trees = Int[]

    w = 0

    for l in eachline("input/day8/input")
        w = length(l)
        append!(trees, c - '0' for c in l)
    end

    h = length(trees) ÷ w

    trees = reshape(trees, w, h)

    x = 0

    for i in 1:h, j in 1:w
        north = all(trees[k, j] < trees[i, j] for k in 1:(i - 1))
        south = all(trees[k, j] < trees[i, j] for k in (i + 1):h)
        west = all(trees[i, k] < trees[i, j] for k in 1:(j - 1))
        east = all(trees[i, k] < trees[i, j] for k in (j + 1):w)

        if any((north, south, west, east))
            x += 1
        end
    end

    x
end

function part2()
    trees = Int[]

    w = 0

    for l in eachline("input/day8/input")
        w = length(l)
        append!(trees, c - '0' for c in l)
    end

    h = length(trees) ÷ w

    trees = reshape(trees, w, h)

    x = 0

    for i in 1:h, j in 1:w
        north = 0
        for k in reverse(1:(i - 1))
            north += 1
            if trees[k, j] >= trees[i, j]
                break
            end
        end
        south = 0
        for k in (i + 1):h
            south += 1
            if trees[k, j] >= trees[i, j]
                break
            end
        end
        west = 0
        for k in reverse(1:(j - 1))
            west += 1
            if trees[i, k] >= trees[i, j]
                break
            end
        end
        east = 0
        for k in (j + 1):w
            east += 1
            if trees[i, k] >= trees[i, j]
                break
            end
        end

        y = prod((north, south, west, east))

        if y > x
            x = y
        end
    end

    x
end
