using Permutations
using DataStructures

valvereg::Regex = r"Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.+)"

function find_shortest_all2all(valves, nonzero_valves)
    bfs_queue = Tuple{String,Int}[]
    bfs_visited = Set{String}()

    length_table = Dict{Tuple{String,String},Int}()

    for a in nonzero_valves
        empty!(bfs_queue)
        empty!(bfs_visited)

        push!(bfs_queue, (a, 0))
        push!(bfs_visited, a)

        while !isempty(bfs_queue)
            (pos, l) = popfirst!(bfs_queue)

            if valves[pos][1] != 0
                length_table[(a, pos)] = l
            end

            for tunnel = valves[pos][2]
                if tunnel ∉ bfs_visited
                    push!(bfs_queue, (tunnel, l + 1))
                    push!(bfs_visited, tunnel)
                end
            end
        end
    end

    length_table
end

function do_strategy(valves, nonzero, all2all, pos, open_valves, time_remaining)
    time_remaining -= 1
    push!(open_valves, pos)
    relief = valves[pos][1] * time_remaining

    x = 0

    for a in nonzero
        if a ∉ open_valves && all2all[(pos, a)] < time_remaining
            y = do_strategy(valves, nonzero, all2all, a,
                open_valves, time_remaining - all2all[(pos, a)])

            x = max(x, y)
        end
    end

    delete!(open_valves, pos)

    relief + x
end

function part1()
    valves = Dict{String,Tuple{Int,Vector{String}}}()

    for l in eachline("input/day16/input")
        m = match(valvereg, l)

        v = m.captures[1]
        r = parse(Int, m.captures[2])
        dests = split(m.captures[3], ", ")

        valves[v] = (r, dests)
    end

    nonzero_valves = [k for (k, (r, _)) in valves if r != 0]

    all2all = find_shortest_all2all(valves, [nonzero_valves; "AA"])

    x = 0

    for a in nonzero_valves
        y = do_strategy(valves, nonzero_valves, all2all, a,
            Set{String}(), 30 - all2all[("AA", a)])
        x = max(x, y)
    end

    x
end

# function do_strategy2(valves, nonzero, all2all, actions, open_valves,
#     time_remaining)

#     @show time_remaining, actions

#     time_spent = actions[1][1]

#     if time_spent > time_remaining
#         return 0
#     end

#     time_remaining -= time_spent
#     push!(open_valves, actions[1][2])
#     relief = valves[actions[1][2]][1] * time_remaining

#     x = 0

#     for a in nonzero
#         if a ∉ open_valves
#             if a == actions[2][2]
#                 new_actions = copy(actions)
#                 if all2all[(actions[1][2], a)] + 1 < actions[2][1] - time_spent
#                     new_actions[1] = (all2all[(actions[1][2], a)] + 1, a)

#                     for b in nonzero
#                         if b != a && b ∉ open_valves
#                             new_actions[2] = (all2all[(actions[2][2], b)] + 1, a)

#                             y = do_strategy2(valves, nonzero, all2all, sort!(new_actions),
#                                 open_valves, time_remaining)
#                             x = max(x, y)
#                         end
#                     end
#                 else
#                     new_actions[1] = (actions[2][1] - time_spent, actions[2][2])
#                 end
#             else
#                 new_actions = copy(actions)
#                 new_actions[1] = (all2all[(actions[1][2], a)] + 1, a)
#                 new_actions[2] = (actions[2][1] - time_spent, actions[2][2])

#                 y = do_strategy2(valves, nonzero, all2all, sort!(new_actions),
#                     open_valves, time_remaining)
#                 x = max(x, y)
#             end
#         end
#     end

#     delete!(open_valves, actions[1][1])

#     relief + x
# end

function part2()
    valves = Dict{String,Tuple{Int,Vector{String}}}()

    for l in eachline("input/day16/input")
        m = match(valvereg, l)

        v = m.captures[1]
        r = parse(Int, m.captures[2])
        dests = split(m.captures[3], ", ")

        valves[v] = (r, dests)
    end

    nonzero_valves = [k for (k, (r, _)) in valves if r != 0]

    all2all = find_shortest_all2all(valves, [nonzero_valves; "AA"])

    xs = [0 for _ in 1:Threads.nthreads()]

    Threads.@threads for i in 0:2^length(nonzero_valves) - 1
        thid = Threads.threadid()
        partition = digits(i; base=2, pad=length(nonzero_valves))

        my_valves = String[]
        elephant_valves = String[]

        for (b, s) in zip(partition, nonzero_valves)
            if b == 0
                push!(my_valves, s)
            else
                push!(elephant_valves, s)
            end
        end

        my_score = 0

        for a in my_valves
            y = do_strategy(valves, my_valves, all2all, a,
                Set{String}(), 26 - all2all[("AA", a)])
            my_score = max(my_score, y)
        end

        elephant_score = 0

        for a in elephant_valves
            y = do_strategy(valves, elephant_valves, all2all, a,
                Set{String}(), 26 - all2all[("AA", a)])
            elephant_score = max(elephant_score, y)
        end

        xs[thid] = max(xs[thid], my_score + elephant_score)
    end

    maximum(xs)
end
