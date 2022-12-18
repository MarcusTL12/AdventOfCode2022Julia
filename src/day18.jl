
function part1()
    cubes = Set{NTuple{3,Int}}()

    DIRS = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]

    area = 0

    for l in eachline("input/day18/input")
        a, b, c = parse.(Int, split(l, ','))

        t = (a, b, c)

        for d in DIRS
            if (t .+ d) ∉ cubes
                area += 1
            else
                area -= 1
            end
        end

        push!(cubes, t)
    end

    area
end

function part2()
    cubes = Set{NTuple{3,Int}}()

    DIRS = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]

    minx = miny = minz = typemax(Int)
    maxx = maxy = maxz = typemin(Int)

    for l in eachline("input/day18/input")
        a, b, c = parse.(Int, split(l, ','))

        minx = min(minx, a)
        miny = min(miny, b)
        minz = min(minz, c)

        maxx = max(maxx, a)
        maxy = max(maxy, b)
        maxz = max(maxz, c)

        push!(cubes, (a, b, c))
    end

    minx -= 1
    miny -= 1
    minz -= 1

    maxx += 1
    maxy += 1
    maxz += 1

    function is_inside_large_cube((x, y, z),)
        minx <= x <= maxx && miny <= y <= maxy && minz <= z <= maxz
    end

    exterior = Set{NTuple{3,Int}}()

    queue = [(minx, miny, minz)]

    area = 0

    while !isempty(queue)
        pos = popfirst!(queue)

        for d in DIRS
            npos = pos .+ d

            if npos ∈ cubes
                area += 1
            end

            if npos ∉ cubes && npos ∉ exterior && is_inside_large_cube(npos)
                push!(queue, npos)
                push!(exterior, npos)
            end
        end
    end

    area
end
