
function infdist(a, b)
    maximum(abs, a .- b)
end

function part1()
    h = (0, 0)
    t = (0, 0)

    tvisited = Set([t])

    dirs = Dict([
        "U" => (0, 1),
        "D" => (0, -1),
        "R" => (1, 0),
        "L" => (-1, 0),
    ])

    for l in eachline("input/day9/input")
        d, n = split(l)

        n = parse(Int, n)

        d = dirs[d]

        for _ in 1:n
            new_h = h .+ d
            if infdist(new_h, t) > 1
                t = h
                push!(tvisited, t)
            end
            h = new_h
        end
    end

    length(tvisited)
end

function part2()
    rope = [(0, 0) for _ in 1:10]

    tvisited = Set([(0, 0)])

    dirs = Dict([
        "U" => (0, 1),
        "D" => (0, -1),
        "R" => (1, 0),
        "L" => (-1, 0),
    ])

    for l in eachline("input/day9/input")
        d, n = split(l)

        n = parse(Int, n)

        d = dirs[d]

        for _ in 1:n
            rope[1] = rope[1] .+ d

            for i in 2:10
                df = rope[i - 1] .- rope[i]
                if maximum(abs, df) > 1
                    rope[i] = rope[i] .+ (sign(df[1]), sign(df[2]))
                end
            end

            push!(tvisited, new_rope[end])
        end
    end

    length(tvisited) + 1
end
