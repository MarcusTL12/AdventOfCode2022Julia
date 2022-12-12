
dirs = [
    (1, 0),
    (-1, 0),
    (0, 1),
    (0, -1),
]

function part1()
    mountain = Char[]

    w = 0

    for l in eachline("input/day12/input")
        w = length(l)
        append!(mountain, l)
    end

    h = length(mountain) ÷ w

    mountain = reshape(mountain, w, h)

    start = (0, 0)
    stop = (0, 0)

    for i in 1:w, j in 1:h
        if mountain[i, j] == 'S'
            start = (i, j)
            mountain[i, j] = 'a'
        end

        if mountain[i, j] == 'E'
            stop = (i, j)
            mountain[i, j] = 'z'
        end
    end

    @show start stop

    # display(mountain)

    queue = [(start, 0)]

    visited = Set([start])

    while !isempty(queue)
        (pos, l) = popfirst!(queue)

        # @show pos, l

        # if pos == stop
        #     return l
        # end

        for d in dirs
            npos = pos .+ d

            if npos ∉ visited && (1 <= npos[1] <= w && 1 <= npos[2] <= h) &&
               mountain[pos...] - mountain[npos...] >= -1
                if npos == stop
                    return l + 1
                end
                push!(queue, (npos, l + 1))
                push!(visited, npos)
            end
        end
    end
end

function find_shortest(mountain, start, stop)
    w, h = size(mountain)

    queue = [(start, 0)]

    visited = Set([start])

    while !isempty(queue)
        (pos, l) = popfirst!(queue)

        for d in dirs
            npos = pos .+ d

            if npos ∉ visited && (1 <= npos[1] <= w && 1 <= npos[2] <= h) &&
               mountain[pos...] - mountain[npos...] >= -1
                if npos == stop
                    return l + 1
                end
                push!(queue, (npos, l + 1))
                push!(visited, npos)
            end
        end
    end

    typemax(Int)
end

function part2()
    mountain = Char[]

    w = 0

    for l in eachline("input/day12/input")
        w = length(l)
        append!(mountain, l)
    end

    h = length(mountain) ÷ w

    mountain = reshape(mountain, w, h)

    starts = Tuple{Int,Int}[]
    stop = (0, 0)

    for i in 1:w, j in 1:h
        if mountain[i, j] == 'S'
            mountain[i, j] = 'a'
        end

        if mountain[i, j] == 'a'
            push!(starts, (i, j))
        end

        if mountain[i, j] == 'E'
            stop = (i, j)
            mountain[i, j] = 'z'
        end
    end

    minimum(find_shortest(mountain, start, stop) for start in starts)
end
