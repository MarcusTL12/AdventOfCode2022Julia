
function parse_snafu(s)
    p = 1
    a = 0
    for c in reverse(s)
        if '0' <= c <= '2'
            a += p * (c - '0')
        elseif c == '-'
            a -= p
        elseif c == '='
            a -= 2p
        end

        p *= 5
    end

    a
end

function write_snafu(x)
    alphabet = ['=', '-', '0', '1', '2']

    i = floor(Int, log(5, x))

    dgts = Char[]

    while abs(x) > 2
        d = round(Int, x / 5^i)
        x -= d * 5^i
        i -= 1
        push!(dgts, alphabet[d + 3])
    end

    push!(dgts, alphabet[x + 3])

    String(dgts)
end

function part1()
    write_snafu(sum(parse_snafu, eachline("input/day25/input")))
end
