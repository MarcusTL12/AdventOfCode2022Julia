
function print_ll_in_order(ll)
    i = 1

    print("[")
    isfirst = true
    for _ in eachindex(ll)
        if !isfirst
            print(", ")
        end
        print(ll[i][1])
        isfirst = false

        i = ll[i][3]
    end

    println("]")
end

function part1()
    inp = parse.(Int, eachline("input/day20/input"))

    ll = [[x, 0, 0] for x in inp]

    i_zero = 0

    for i in eachindex(ll)
        if ll[i][1] == 0
            i_zero = i
        end

        ll[i][2] = if i == 1
            length(ll)
        else
            i - 1
        end

        ll[i][3] = if i == length(ll)
            1
        else
            i + 1
        end
    end

    for i in eachindex(ll)
        n_swap = ll[i][1]

        if n_swap > 0
            for _ in 1:n_swap
                ind1 = i

                ind0 = ll[ind1][2]
                ind2 = ll[ind1][3]
                ind3 = ll[ind2][3]

                ll[ind0][3] = ind2
                ll[ind3][2] = ind1

                ll[ind1][2] = ind2
                ll[ind1][3] = ind3

                ll[ind2][2] = ind0
                ll[ind2][3] = ind1
            end
        elseif n_swap < 0
            for _ in 1:-n_swap
                ind1 = ll[i][2]

                ind0 = ll[ind1][2]
                ind2 = ll[ind1][3]
                ind3 = ll[ind2][3]

                ll[ind0][3] = ind2
                ll[ind3][2] = ind1

                ll[ind1][2] = ind2
                ll[ind1][3] = ind3

                ll[ind2][2] = ind0
                ll[ind2][3] = ind1
            end
        end
    end

    s = 0

    i = i_zero

    for _ in 1:3
        for _ in 1:1000
            i = ll[i][3]
        end

        s += ll[i][1]
    end

    s
end

function part2()
    inp = parse.(Int, eachline("input/day20/input"))

    k = 811589153

    ll = [[x * k, 0, 0] for x in inp]

    i_zero = 0

    for i in eachindex(ll)
        if ll[i][1] == 0
            i_zero = i
        end

        ll[i][2] = if i == 1
            length(ll)
        else
            i - 1
        end

        ll[i][3] = if i == length(ll)
            1
        else
            i + 1
        end
    end

    for _ in 1:10
        for i in eachindex(ll)
            n_swap = ll[i][1] % (length(ll) - 1)

            if n_swap > 0
                for _ in 1:n_swap
                    ind1 = i

                    ind0 = ll[ind1][2]
                    ind2 = ll[ind1][3]
                    ind3 = ll[ind2][3]

                    ll[ind0][3] = ind2
                    ll[ind3][2] = ind1

                    ll[ind1][2] = ind2
                    ll[ind1][3] = ind3

                    ll[ind2][2] = ind0
                    ll[ind2][3] = ind1
                end
            elseif n_swap < 0
                for _ in 1:-n_swap
                    ind1 = ll[i][2]

                    ind0 = ll[ind1][2]
                    ind2 = ll[ind1][3]
                    ind3 = ll[ind2][3]

                    ll[ind0][3] = ind2
                    ll[ind3][2] = ind1

                    ll[ind1][2] = ind2
                    ll[ind1][3] = ind3

                    ll[ind2][2] = ind0
                    ll[ind2][3] = ind1
                end
            end
        end
    end

    s = 0

    i = i_zero

    for _ in 1:3
        for _ in 1:1000
            i = ll[i][3]
        end

        s += ll[i][1]
    end

    s
end
