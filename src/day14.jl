
function insert_sand(tiles, at)
    sand = at

    last_rock_y = maximum(k[2] for k in keys(tiles))

    while sand[2] < last_rock_y
        if get(tiles, sand .+ (0, 1), 0) == 0
            sand = sand .+ (0, 1)
        elseif get(tiles, sand .+ (-1, 1), 0) == 0
            sand = sand .+ (-1, 1)
        elseif get(tiles, sand .+ (1, 1), 0) == 0
            sand = sand .+ (1, 1)
        else
            tiles[sand] = 2
            return (true, sand)
        end
    end

    (false, sand)
end

function part1()
    tiles = Dict{Tuple{Int,Int},Int}()

    for l in eachline("input/day14/input")
        corners = [parse.(Int, split(x, ',')) for x in split(l, " -> ")]

        for i in 1:length(corners) - 1
            if corners[i][1] == corners[i + 1][1]
                ymin = min(corners[i][2], corners[i + 1][2])
                ymax = max(corners[i][2], corners[i + 1][2])
                for y in ymin:ymax
                    tiles[(corners[i][1], y)] = 1
                end
            elseif corners[i][2] == corners[i + 1][2]
                xmin = min(corners[i][1], corners[i + 1][1])
                xmax = max(corners[i][1], corners[i + 1][1])
                for x in xmin:xmax
                    tiles[(x, corners[i][2])] = 1
                end
            end
        end
    end

    x = 0

    while insert_sand(tiles, (500, 0))[1]
        x += 1
    end

    x
end

function insert_sand2(tiles, at)
    sand = at

    last_rock_y = maximum(k[2] for k in keys(tiles) if tiles[k] == 1)
    rock_floor_y = last_rock_y + 2

    while sand[2] < (rock_floor_y - 1)
        if get(tiles, sand .+ (0, 1), 0) == 0
            sand = sand .+ (0, 1)
        elseif get(tiles, sand .+ (-1, 1), 0) == 0
            sand = sand .+ (-1, 1)
        elseif get(tiles, sand .+ (1, 1), 0) == 0
            sand = sand .+ (1, 1)
        else
            tiles[sand] = 2
            return
        end
    end

    tiles[sand] = 2;
end

function part2()
    tiles = Dict{Tuple{Int,Int},Int}()

    for l in eachline("input/day14/input")
        corners = [parse.(Int, split(x, ',')) for x in split(l, " -> ")]

        for i in 1:length(corners) - 1
            if corners[i][1] == corners[i + 1][1]
                ymin = min(corners[i][2], corners[i + 1][2])
                ymax = max(corners[i][2], corners[i + 1][2])
                for y in ymin:ymax
                    tiles[(corners[i][1], y)] = 1
                end
            elseif corners[i][2] == corners[i + 1][2]
                xmin = min(corners[i][1], corners[i + 1][1])
                xmax = max(corners[i][1], corners[i + 1][1])
                for x in xmin:xmax
                    tiles[(x, corners[i][2])] = 1
                end
            end
        end
    end

    x = 0

    while get(tiles, (500, 0), 0) == 0
        insert_sand2(tiles, (500, 0))
        x += 1
    end

    x
end
