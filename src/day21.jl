using SymPy

function find_val(monkeys, monkey)
    if monkeys[monkey] isa Int
        monkeys[monkey]
    else
        a, o, b = monkeys[monkey]

        ax = find_val(monkeys, a)
        bx = find_val(monkeys, b)

        x = if o == '+'
            ax + bx
        elseif o == '-'
            ax - bx
        elseif o == '*'
            ax * bx
        elseif o == '/'
            ax ÷ bx
        else
            @show o
        end

        monkeys[monkey] = x
    end
end

function part1()
    monkeys = Dict{String,Union{Int,Tuple{String,Char,String}}}()

    for l in eachline("input/day21/input")
        a, b = split(l, ": ")

        bs = split(b)

        if length(bs) == 1
            monkeys[a] = parse(Int, bs[1])
        else
            monkeys[a] = (String(bs[1]), bs[2][1], String(bs[3]))
        end
    end

    find_val(monkeys, "root")
end

function find_val_sym(monkeys, monkey)
    if monkeys[monkey] isa Sym
        monkeys[monkey]
    else
        a, o, b = monkeys[monkey]

        ax = find_val_sym(monkeys, a)
        bx = find_val_sym(monkeys, b)

        x = if o == '+'
            ax + bx
        elseif o == '-'
            ax - bx
        elseif o == '*'
            ax * bx
        elseif o == '/'
            if ax isa Sym || bx isa Sym
                ax / bx
            else
                ax ÷ bx
            end
        else
            @show o
        end

        monkeys[monkey] = x
    end
end

function find_humn(monkeys)
    monkeys["humn"] = Sym("humn")

    a, _, b = monkeys["root"]
    
    solve(find_val_sym(monkeys, a) - find_val_sym(monkeys, b))
end

function part2()
    monkeys = Dict{String,Union{Sym,Tuple{String,Char,String}}}()

    for l in eachline("input/day21/input")
        a, b = split(l, ": ")

        bs = split(b)

        if length(bs) == 1
            monkeys[a] = Sym(parse(Int, bs[1]))
        else
            monkeys[a] = (String(bs[1]), bs[2][1], String(bs[3]))
        end
    end

    find_humn(monkeys)
end
