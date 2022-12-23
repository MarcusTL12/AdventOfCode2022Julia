
function show_elves(grid)
    minx = minimum(x for (x, _) in grid)
    maxx = maximum(x for (x, _) in grid)
    miny = minimum(y for (_, y) in grid)
    maxy = maximum(y for (_, y) in grid)

    for y in miny:maxy
        for x in minx:maxx
            if (x, y) ∈ grid
                print('#')
            else
                print('.')
            end
        end
        println()
    end
end

function part1()
    grid = Set{Tuple{Int,Int}}()

    y = 1
    for l in eachline("input/day23/input")
        for (x, c) in enumerate(l)
            if c == '#'
                push!(grid, (x, y))
            end
        end

        y += 1
    end

    moves = Dict{Tuple{Int,Int},Tuple{Int,Int}}()
    rev_moves = copy(moves)

    dirs = [
        (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)
    ]

    consi_dir_ations = [
        ([(-1, -1), (0, -1), (1, -1)], (0, -1)),
        ([(-1, 1), (0, 1), (1, 1)], (0, 1)),
        ([(-1, -1), (-1, 0), (-1, 1)], (-1, 0)),
        ([(1, -1), (1, 0), (1, 1)], (1, 0))
    ]

    for _ in 1:10
        empty!(moves)
        empty!(rev_moves)

        for elf in grid
            if any((elf .+ d) ∈ grid for d in dirs)
                d = (0, 0)

                do_move = false

                for (checks, nd) in consi_dir_ations
                    if !any((elf .+ x) ∈ grid for x in checks)
                        d = nd
                        do_move = true
                        break
                    end
                end

                if do_move
                    dest = elf .+ d
                    if haskey(rev_moves, dest)
                        delete!(moves, rev_moves[dest])
                    else
                        rev_moves[dest] = elf
                        moves[elf] = dest
                    end
                end
            end
        end

        push!(consi_dir_ations, popfirst!(consi_dir_ations))

        for (from, to) in moves
            delete!(grid, from)
            push!(grid, to)
        end
    end

    minx = minimum(x for (x, _) in grid)
    maxx = maximum(x for (x, _) in grid)
    miny = minimum(y for (_, y) in grid)
    maxy = maximum(y for (_, y) in grid)

    (maxx - minx + 1) * (maxy - miny + 1) - length(grid)
end

function part2()
    grid = Set{Tuple{Int,Int}}()

    y = 1
    for l in eachline("input/day23/input")
        for (x, c) in enumerate(l)
            if c == '#'
                push!(grid, (x, y))
            end
        end

        y += 1
    end

    moves = Dict{Tuple{Int,Int},Tuple{Int,Int}}()
    rev_moves = copy(moves)

    dirs = [
        (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)
    ]

    consi_dir_ations = [
        ([(-1, -1), (0, -1), (1, -1)], (0, -1)),
        ([(-1, 1), (0, 1), (1, 1)], (0, 1)),
        ([(-1, -1), (-1, 0), (-1, 1)], (-1, 0)),
        ([(1, -1), (1, 0), (1, 1)], (1, 0))
    ]

    for i in 1:1000_000
        empty!(moves)
        empty!(rev_moves)

        any_moves = false

        for elf in grid
            if any((elf .+ d) ∈ grid for d in dirs)
                d = (0, 0)

                do_move = false

                for (checks, nd) in consi_dir_ations
                    if !any((elf .+ x) ∈ grid for x in checks)
                        d = nd
                        do_move = true
                        break
                    end
                end

                if do_move
                    dest = elf .+ d
                    if haskey(rev_moves, dest)
                        delete!(moves, rev_moves[dest])
                    else
                        rev_moves[dest] = elf
                        moves[elf] = dest
                    end
                end
            end
        end

        push!(consi_dir_ations, popfirst!(consi_dir_ations))

        for (from, to) in moves
            any_moves = true
            delete!(grid, from)
            push!(grid, to)
        end

        if !any_moves
            return i
        end
    end
end
