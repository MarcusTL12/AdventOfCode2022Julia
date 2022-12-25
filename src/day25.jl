
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
    
end

function part1()
    sum(parse_snafu, eachline("input/day25/input"))
end

x = part1()

parse_snafu("2-02===-21---2002==0") - x
