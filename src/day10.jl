
function part1()
    x = 1
    y = 0

    # pipeline = Int[0, ]

    cycles = 0

    milestones = [20, 60, 100, 140, 180, 220]

    for l in eachline("input/day10/input")
        s = split(l)

        if length(s) > 1
            n = parse(Int, s[2])

            # push!(pipeline, 0)
            cycles += 1
            if cycles in milestones
                y += cycles * x
                @show x, cycles
            end
            cycles += 1
            if cycles in milestones
                y += cycles * x
                @show x, cycles
            end
            x += n
        else
            # push!(pipeline, 0)
            cycles += 1
            if cycles in milestones
                y += cycles * x
                @show x, cycles
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
    x = 1

    sx = Ref(1)
    sy = Ref(1)

    screen = falses(40, 6)

    function push_too_screen()
        if 0 <= sx[] - x <= 2
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

            push_too_screen()
            push_too_screen()
            x += n
        else
            push_too_screen()
        end
    end

    drawscreen(screen)
end
