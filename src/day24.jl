
function inside_board(x, y, w, h)
    (x, y) == (2, 1) || (x, y) == (w - 1, h) || 1 < x < w && 1 < y < h
end

function is_blizzard(blizzard_grid, (x, y), t)
    (w, h, _) = size(blizzard_grid)

    x -= 1
    y -= 1

    if 1 <= x <= w && 1 <= y <= h
        blizzard_grid[mod1(x - t, w), y, 1] ||
            blizzard_grid[x, mod1(y - t, h), 2] ||
            blizzard_grid[mod1(x + t, w), y, 3] ||
            blizzard_grid[x, mod1(y + t, h), 4]
    else
        false
    end
end

function bfs(start, stop, t0, blizzards, w, h)
    dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]

    queue = [(start, t0)]
    visited = Set(queue)

    while !isempty(queue)
        (pos, t) = popfirst!(queue)

        if !is_blizzard(blizzards, pos, t + 1) &&
           (pos, t + 1) ∉ visited
            push!(queue, (pos, t + 1))
            push!(visited, (pos, t + 1))
        end

        for d in dirs
            npos = pos .+ d
            nt = t + 1

            if npos == stop
                return t + 1
            end

            if !is_blizzard(blizzards, npos, nt) &&
               (npos, nt) ∉ visited &&
               inside_board(npos..., w, h)
                push!(queue, (npos, nt))
                push!(visited, (npos, nt))
            end
        end
    end
end

function part1()
    blizzards = Tuple{Tuple{Int,Int},Int}[]

    y = 1
    w = 0
    for l in eachline("input/day24/input")
        x = 1
        for c in l
            if c == '>'
                push!(blizzards, ((x, y), 1))
            elseif c == 'v'
                push!(blizzards, ((x, y), 2))
            elseif c == '<'
                push!(blizzards, ((x, y), 3))
            elseif c == '^'
                push!(blizzards, ((x, y), 4))
            end

            x += 1
            w = max(w, x)
        end

        y += 1
    end

    w -= 1
    h = y - 1

    blizz_grid = falses(w - 2, h - 2, 4)

    for ((x, y), d) in blizzards
        blizz_grid[x-1, y-1, d] = true
    end

    bfs((2, 1), (w - 1, h), 0, blizz_grid, w, h)
end

function part2()
    blizzards = Tuple{Tuple{Int,Int},Int}[]

    y = 1
    w = 0
    for l in eachline("input/day24/input")
        x = 1
        for c in l
            if c == '>'
                push!(blizzards, ((x, y), 1))
            elseif c == 'v'
                push!(blizzards, ((x, y), 2))
            elseif c == '<'
                push!(blizzards, ((x, y), 3))
            elseif c == '^'
                push!(blizzards, ((x, y), 4))
            end

            x += 1
            w = max(w, x)
        end

        y += 1
    end

    w -= 1
    h = y - 1

    blizz_grid = falses(w - 2, h - 2, 4)

    for ((x, y), d) in blizzards
        blizz_grid[x-1, y-1, d] = true
    end

    start = (2, 1)
    goal = (w - 1, h)

    bfs(
        start,
        goal,
        bfs(
            goal,
            start,
            bfs(start, goal, 0, blizz_grid, w, h), blizz_grid, w, h),
        blizz_grid,
        w,
        h
    )
end
