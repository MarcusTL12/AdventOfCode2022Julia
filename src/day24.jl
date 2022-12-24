
function blizzard_pos(((bx, by), d), t, w, h)
    if d == 1
        ((bx + t - 2) % (w - 2) + 2, by)
    elseif d == 2
        (bx, (by + t - 2) % (h - 2) + 2)
    elseif d == 3
        (((bx - t - 2) % (w - 2) + (w - 2)) % (w - 2) + 2, by)
    elseif d == 4
        (bx, ((by - t - 2) % (h - 2) + (h - 2)) % (h - 2) + 2)
    end
end

function is_blizzard(blizzards, pos, t, w, h)
    any(blizzard_pos(blz, t, w, h) == pos for blz in blizzards)
end

function inside_board(x, y, w, h)
    (x, y) == (2, 1) || (x, y) == (w - 1, h) || 1 < x < w && 1 < y < h
end

function mandist(a, b)
    sum(abs, a .- b)
end

function bfs(start, stop, t0, blizzards, w, h, tmax)
    tmax += t0

    dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]

    queue = [(start, t0)]
    visited = Set(queue)

    while !isempty(queue)
        (pos, t) = popfirst!(queue)

        if !is_blizzard(blizzards, pos, t + 1, w, h) &&
           (pos, t + 1) ∉ visited && mandist(pos, stop) + t + 1 <= tmax
            push!(queue, (pos, t + 1))
            push!(visited, (pos, t + 1))
        end

        for d in dirs
            npos = pos .+ d
            nt = t + 1

            if npos == stop
                return t + 1
            end

            if !is_blizzard(blizzards, npos, nt, w, h) &&
               (npos, nt) ∉ visited &&
               inside_board(npos..., w, h) &&
               mandist(npos, stop) + nt <= tmax
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

    bfs((2, 1), (w - 1, h), 0, blizzards, w, h, 320)
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

    start = (2, 1)
    goal = (w - 1, h)

    time1 = bfs(start, goal, 0, blizzards, w, h, 320)
    @show time1
    time2 = bfs(goal, start, time1, blizzards, w, h, 320)
    @show time2
    bfs(start, goal, time2, blizzards, w, h, 320)
end
