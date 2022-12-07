
function part1()
    dirsizes = Dict{String,Int}()

    dirstack = String[]

    for l in eachline("input/day7/input")
        if startswith(l, "\$ cd ")
            newdir = split(l)[3]

            if newdir != ".."
                push!(dirstack, newdir)
                key = joinpath(dirstack)
                if !haskey(dirsizes, key)
                    dirsizes[key] = 0
                end
            else
                curdirkey = joinpath(dirstack)
                pop!(dirstack)
                outdirkey = joinpath(dirstack)
                dirsizes[outdirkey] += dirsizes[curdirkey]
            end
        elseif isnumeric(l[1])
            dirsizes[joinpath(dirstack)] += parse(Int, split(l)[1])
        end
    end

    sum(v for v in values(dirsizes) if v <= 100000)
end

function part2()
    dirsizes = Dict{String,Int}()

    dirstack = String[]

    for l in eachline("input/day7/input")
        if startswith(l, "\$ cd ")
            newdir = split(l)[3]

            if newdir != ".."
                push!(dirstack, newdir)
                key = joinpath(dirstack)
                if !haskey(dirsizes, key)
                    dirsizes[key] = 0
                end
            else
                curdirkey = joinpath(dirstack)
                pop!(dirstack)
                outdirkey = joinpath(dirstack)
                dirsizes[outdirkey] += dirsizes[curdirkey]
            end
        elseif isnumeric(l[1])
            dirsizes[joinpath(dirstack)] += parse(Int, split(l)[1])
        end
    end

    while length(dirstack) > 1
        curdirkey = joinpath(dirstack)
        pop!(dirstack)
        outdirkey = joinpath(dirstack)
        dirsizes[outdirkey] += dirsizes[curdirkey]
    end

    unused = 70000000 - dirsizes["/"]

    cur_k = ""
    cur_v = typemax(Int)

    for (k, v) in dirsizes
        if (v + unused) >= 30000000 && v <= cur_v
            cur_k = k
            cur_v = v
        end
    end

    cur_v
end
