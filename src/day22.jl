using StaticArrays


instruction_reg::Regex = r"(?:\d+)|(?:R|L)"

rot_r::SMatrix{2, 2, Int, 4} = @SMatrix [0 -1; 1 0]
rot_l::SMatrix{2, 2, Int, 4} = @SMatrix [0 1; -1 0]

function draw_grid(grid, pos, dir)
    minx = minimum(k[1] for k in keys(grid))
    maxx = maximum(k[1] for k in keys(grid))
    miny = minimum(k[2] for k in keys(grid))
    maxy = maximum(k[2] for k in keys(grid))

    for y in miny:maxy
        for x in minx:maxx
            xy = @SVector [x, y]

            if xy == pos
                if dir == @SVector [1, 0]
                    print('>')
                elseif dir == @SVector [-1, 0]
                    print('<')
                elseif dir == @SVector [0, 1]
                    print('v')
                elseif dir == @SVector [0, -1]
                end
            elseif haskey(grid, xy)
                
            end
        end
    end
end

function get_facing_num(dir)
    if dir == @SVector [1, 0]
        0
    elseif dir == @SVector [0, 1]
        1
    elseif dir == @SVector [-1, 0]
        2
    elseif dir == @SVector [0, -1]
        3
    end
end

function part1()
    grid = Dict{SVector{2, Int},Bool}()

    y = 1

    pos = @SVector [0, 0]

    lines = Iterators.Stateful(eachline("input/day22/input"))

    for l in lines
        if isempty(l)
            break
        end

        x = 1
        for c in l
            if c != ' '
                grid[@SVector [x, y]] = c == '#'

                if y == 1 && c == '.' && pos[1] == 0
                    pos = @SVector [x, y]
                end
            end

            x += 1
        end

        y += 1
    end

    instructions = popfirst!(lines)

    dir = @SVector [1, 0]

    for m in eachmatch(instruction_reg, instructions)
        s = m.match

        if s == "R"
            dir = rot_r * dir
        elseif s == "L"
            dir = rot_l * dir
        else
            l = parse(Int, s)

            for _ in 1:l
                if haskey(grid, pos + dir)
                    if !grid[pos + dir]
                        pos += dir
                    else
                        break
                    end
                else
                    portal_pos = pos
                    while haskey(grid, portal_pos - dir)
                        portal_pos -= dir
                    end

                    if !grid[portal_pos]
                        pos = portal_pos
                    else
                        break
                    end
                end
            end
        end
    end

    pos[2] * 1000 + pos[1] * 4 + get_facing_num(dir)
end

function part2()
    for l in eachline("input/day22/input")
    end
end
