
parse_reg::Regex = r"Monkey \d+:\n +Starting items: ((?:\d+,? ?)+)\n +Operation: new = old (.) (\w+)\n +Test: divisible by (\d+)\n +If true: throw to monkey (\d+)\n +If false: throw to monkey (\d+)"

function parse_inp(filename)
    s = read(filename, String)

    monkeys = []

    for m in eachmatch(parse_reg, s)
        items = parse.(Int, split(m.captures[1], ", "))
        operation = m.captures[2]
        rhs = m.captures[3]
        divtest = parse(Int, m.captures[4])
        m_true = parse(Int, m.captures[5]) + 1
        m_false = parse(Int, m.captures[6]) + 1

        push!(monkeys, (items, operation, rhs, divtest, m_true, m_false))
    end

    monkeys
end

function part1()
    monkeys = parse_inp("input/day11/ex1")

    inspects = [0 for _ in monkeys]

    for _ in 1:20
        for (j, m) in enumerate(monkeys)
            throw_monkeys = []

            inspects[j] += length(m[1])

            for i in eachindex(m[1])
                new = 0
                rhs = if m[3] == "old"
                    m[1][i]
                else
                    parse(Int, m[3])
                end

                if m[2] == "+"
                    new = m[1][i] + rhs
                else
                    new = m[1][i] * rhs
                end

                m[1][i] = new ÷ 3

                if m[1][i] % m[4] == 0
                    push!(throw_monkeys, i => m[5])
                else
                    push!(throw_monkeys, i => m[6])
                end
            end

            for (i, to) in throw_monkeys
                push!(monkeys[to][1], m[1][i])
            end

            empty!(m[1])
        end
    end

    sort!(inspects)

    # inspects[end] * inspects[end - 1]
end

function part2()
    monkeys = parse_inp("input/day11/input")

    inspects = [0 for _ in monkeys]

    divtests = [m[4] for m in monkeys]

    max_div = lcm(divtests)

    for k in 1:10000
        for (j, m) in enumerate(monkeys)
            throw_monkeys = []

            inspects[j] += length(m[1])

            for i in eachindex(m[1])
                new = 0
                rhs = if m[3] == "old"
                    m[1][i]
                else
                    parse(Int, m[3])
                end

                if m[2] == "+"
                    new = m[1][i] + rhs
                else
                    new = m[1][i] * rhs
                end

                m[1][i] = new % max_div

                if m[1][i] % m[4] == 0
                    push!(throw_monkeys, i => m[5])
                else
                    push!(throw_monkeys, i => m[6])
                end
            end

            for (i, to) in throw_monkeys
                push!(monkeys[to][1], m[1][i])
            end

            empty!(m[1])
        end

        if k in [1, 20, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
            @show (k, inspects)
        end
    end

    sort!(inspects)

    inspects[end] * inspects[end - 1]
end
