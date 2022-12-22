using StaticArrays


instruction_reg::Regex = r"(?:\d+)|(?:R|L)"

rot_r::SMatrix{2,2,Int,4} = @SMatrix [0 -1; 1 0]
rot_l::SMatrix{2,2,Int,4} = @SMatrix [0 1; -1 0]

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
    grid = Dict{SVector{2,Int},Bool}()

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
                    if !grid[pos+dir]
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

function hand_coded_data_ex1()
    function face_inds()
        [
            (@SVector [3, 1]),
            (@SVector [1, 2]),
            (@SVector [2, 2]),
            (@SVector [3, 2]),
            (@SVector [3, 3]),
            (@SVector [4, 3]),
        ]
    end

    function get_face(x, y)
        if 1 <= y <= 4
            1
        elseif 5 <= y <= 8
            if 1 <= x <= 4
                2
            elseif 5 <= x <= 8
                3
            else
                4
            end
        else
            if 9 <= x <= 12
                5
            else
                6
            end
        end
    end

    function adjacencies()
        [
            [(6, 3), (4, 2), (3, 2), (2, 2)],
            [(3, 1), (5, 4), (6, 4), (1, 2)],
            [(4, 1), (5, 1), (2, 3), (1, 1)],
            [(6, 2), (2, 1), (5, 3), (4, 2)],
            [(6, 1), (2, 4), (3, 4), (4, 4)]
        ]
    end

    (face_inds, get_face, adjacencies, 4)
end

function hand_coded_data_input()
    function face_inds()
        [
            (@SVector [2, 1]),
            (@SVector [3, 1]),
            (@SVector [2, 2]),
            (@SVector [1, 3]),
            (@SVector [2, 3]),
            (@SVector [1, 4]),
        ]
    end

    function get_face(x, y)
        if 1 <= y <= 50
            if 51 <= x <= 100
                1
            else
                2
            end
        elseif 51 <= y <= 100
            3
        elseif 101 <= y <= 150
            if 1 <= x <= 50
                4
            else
                5
            end
        else
            6
        end
    end

    function adjacencies()
        [
            [(2, 1), (3, 2), (4, 1), (6, 1)],
            [(5, 3), (3, 3), (1, 3), (6, 4)],
            [(2, 4), (5, 2), (4, 2), (1, 4)],
            [(5, 1), (6, 2), (1, 1), (3, 1)],
            [(2, 3), (6, 3), (4, 3), (3, 4)],
            [(5, 4), (2, 2), (1, 2), (4, 4)],
        ]
    end

    (face_inds, get_face, adjacencies, 50)
end

function get_face_coord(face_ind, w)
    (face_ind .- 1) .* w .+ 1
end

function portal_rel_coord(relpos, w, dirnum, target_dirnum)
    if dirnum == 1
        relpos = @SVector [0, relpos[2]]
    elseif dirnum == 2
        relpos = @SVector [relpos[1], 0]
    elseif dirnum == 3
        relpos = @SVector [w - 1, relpos[2]]
    elseif dirnum == 4
        relpos = @SVector [relpos[1], w - 1]
    end

    if dirnum == target_dirnum
        relpos
    elseif abs(dirnum - target_dirnum) == 2
        @SVector [w - relpos[1] - 1, w - relpos[2] - 1]
    elseif (target_dirnum - dirnum + 4) % 4 == 1
        @SVector [w - relpos[2] - 1, relpos[1]]
    elseif (target_dirnum - dirnum + 4) % 4 == 3
        @SVector [relpos[2], w - relpos[1] - 1]
    end
end

function part2()
    (face_inds, get_face, adjacencies, w) = hand_coded_data_input()

    grid = Dict{SVector{2,Int},Tuple{Int,Bool}}()

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
                grid[@SVector [x, y]] = (get_face(x, y), c == '#')

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

    adj = adjacencies()

    face_inds = face_inds()

    dirs = [
        (@SVector [1, 0]),
        (@SVector [0, 1]),
        (@SVector [-1, 0]),
        (@SVector [0, -1]),
    ]

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
                    if !grid[pos+dir][2]
                        pos += dir
                    else
                        break
                    end
                else
                    face = grid[pos][1]
                    dirnum = get_facing_num(dir) + 1

                    (target_face, target_dir) = adj[face][dirnum]

                    rel_pos = pos - get_face_coord(face_inds[face], w)

                    new_rel_pos =
                        portal_rel_coord(rel_pos, w, dirnum, target_dir)

                    npos = new_rel_pos +
                           get_face_coord(face_inds[target_face], w)
                    ndir = dirs[target_dir]

                    if !grid[npos][2]
                        pos = npos
                        dir = ndir
                    end
                end
            end
        end
    end

    pos[2] * 1000 + pos[1] * 4 + get_facing_num(dir)
end

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
                    print('^')
                end
            elseif haskey(grid, xy)
                if grid[xy][2]
                    print('#')
                else
                    print('.')
                end
            else
                print(' ')
            end
        end
        println()
    end
end
