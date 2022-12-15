
sensor_reg::Regex = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"

function mandist((x1, y1), (x2, y2))
    abs(x1 - x2) + abs(y1 - y2)
end

function part1()
    not_becons = Set{Tuple{Int,Int}}()

    y = 2000000

    for l in eachline("input/day15/input")
        m = match(sensor_reg, l)

        sx = parse(Int, m.captures[1])
        sy = parse(Int, m.captures[2])

        bx = parse(Int, m.captures[3])
        by = parse(Int, m.captures[4])

        d = mandist((sx, sy), (bx, by))

        for x in sx-d:sx+d
            if mandist((x, y), (sx, sy)) <= d && (x, y) != (bx, by)
                push!(not_becons, (x, y))
            end
        end
    end

    length(not_becons)
end

function range_contained(r1, r2)
    r1[1] <= r2[1] && r1[2] >= r2[2]
end

function is_any_overlap(r1, r2)
    (r1[1] >= r2[1] && r1[1] <= r2[2] ||
     r1[2] >= r2[1] && r1[2] <= r2[2] ||
     r2[1] >= r1[1] && r2[1] <= r1[2] ||
     r2[2] >= r1[1] && r2[2] <= r1[2])
end

function union_ranges(r1, r2)
    if range_contained(r1, r2)
        r1
    elseif range_contained(r2, r1)
        r2
    elseif is_any_overlap(r1, r2) || max(r1[1], r2[1]) == min(r1[2], r2[2]) + 1
        (min(r1[1], r2[1]), max(r1[2], r2[2]))
    else
        nothing
    end
end

function union_range_lists(rs1, rs2)
    all_rs = [rs1; rs2]
    sort!(all_rs, by=r -> r[1])

    new_rs = Tuple{Int,Int}[popfirst!(all_rs)]

    while !isempty(all_rs)
        r = popfirst!(all_rs)

        u = union_ranges(new_rs[end], r)

        if !isnothing(u)
            new_rs[end] = u
        else
            push!(new_rs, r)
        end
    end

    new_rs
end

function part2()
    max_coord = 4000000

    not_beacons = [Tuple{Int,Int}[] for _ in 0:max_coord]

    for l in eachline("input/day15/input")
        m = match(sensor_reg, l)

        sx = parse(Int, m.captures[1])
        sy = parse(Int, m.captures[2])

        bx = parse(Int, m.captures[3])
        by = parse(Int, m.captures[4])

        d = mandist((sx, sy), (bx, by))

        for y in sy-d:sy+d
            if 0 <= y <= max_coord
                xr = (
                    clamp(sx - (d - abs(sy - y)), 0, max_coord),
                    clamp(sx + (d - abs(sy - y)), 0, max_coord)
                )

                not_beacons[y+1] = union_range_lists(not_beacons[y+1], [xr])
            end
        end
    end

    res = 0

    for (y, rs) in enumerate(not_beacons)
        if length(rs) == 2
            x = rs[1][2] + 1

            res = x * 4000000 + y - 1
        end
    end

    res
end
