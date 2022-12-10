
function part1()
    x = 1
    y = 0

    cycles = 0

    milestones = [20, 60, 100, 140, 180, 220]

    for l in eachline("input/day10/input")
        s = split(l)

        if length(s) > 1
            n = parse(Int, s[2])

            cycles += 1
            if cycles in milestones
                y += cycles * x
            end
            cycles += 1
            if cycles in milestones
                y += cycles * x
            end
            x += n
        else
            cycles += 1
            if cycles in milestones
                y += cycles * x
            end
        end
    end

    y
end

function drawscreen(screen)
    for c in eachcol(screen)
        for x in c
            print(x ? '#' : ' ')
        end
        println()
    end
end

function part2()
    x = 2

    sx = Ref(1)
    sy = Ref(1)

    screen = falses(40, 6)

    function push_to_screen()
        if abs(sx[] - x) <= 1
            screen[sx[], sy[]] = true
        end

        sx[] += 1
        if sx[] > 40
            sx[] = 1
            sy[] += 1
        end
    end

    for l in eachline("input/day10/input")
        s = split(l)

        if length(s) > 1
            n = parse(Int, s[2])

            push_to_screen()
            push_to_screen()
            x += n
        else
            push_to_screen()
        end
    end

    drawscreen(screen)
end
