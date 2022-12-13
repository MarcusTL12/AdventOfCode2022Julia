
function compare(a::Int, b::Int)
    # @show (a, b)
    a - b
end

function compare(a::Vector, b::Vector)
    # @show (a, b)
    for (x, y) in zip(a, b)
        c = compare(x, y)
        if c != 0
            return c
        end
    end

    length(a) - length(b)
end

function compare(a::Int, b::Vector)
    # @show (a, b)
    compare([a], b)
end

function compare(a::Vector, b::Int)
    # @show (a, b)
    compare(a, [b])
end

function part1()
    inp = read("input/day13/input", String)

    s = split(inp, "\n\n")

    x = 0

    for (i, ss) in enumerate(s)
        as, bs = split(ss, "\n")

        a = eval(Meta.parse(as))
        b = eval(Meta.parse(bs))

        if compare(a, b) < 0
            x += i
        end
    end

    x
end

function part2()
    packets = Any[]

    for l in eachline("input/day13/input")
        if !isempty(l)
            push!(packets, eval(Meta.parse(l)))
        end
    end

    div1 = [[2]]
    div2 = [[6]]

    push!(packets, div1)
    push!(packets, div2)

    sort!(packets, lt=(x, y) -> compare(x, y) < 0)

    x = 1

    for (i, p) in enumerate(packets)
        if (p == div1) || (p == div2)
            x *= i
        end
    end

    x
end
