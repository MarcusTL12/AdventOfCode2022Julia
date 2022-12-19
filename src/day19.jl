using DataStructures

reg::Regex = r"Blueprint \d+: Each ore robot costs (\d+) ore\. " *
             r"Each clay robot costs (\d+) ore\. " *
             r"Each obsidian robot costs (\d+) ore and (\d+) clay\. " *
             r"Each geode robot costs (\d+) ore and (\d+) obsidian\."

function get_n_geodes(ore_cost, clay_cost, obs_cost, geode_cost, total_time)

    queue = PriorityQueue(((0, 0, 0, 0), (1, 0, 0, 0), total_time) => 0)

    while !isempty(queue)
        (
            (ore, clay, obs, geode),
            (ore_bots, clay_bots, obs_bots, geo_bots),
            time_left
        ), wasted_geodes = dequeue_pair!(queue)

        if time_left == 0
            return geode
        end

        added_nodes = false

        if ore >= geode_cost[1] && obs >= geode_cost[2]
            k = (
                (
                    ore + ore_bots - geode_cost[1],
                    clay + clay_bots,
                    obs + obs_bots - geode_cost[2],
                    geode + geo_bots
                ),
                (ore_bots, clay_bots, obs_bots, geo_bots + 1),
                time_left - 1
            )

            queue[k] = min(
                get(queue, k, typemax(Int)),
                wasted_geodes
            )
        else
            if ore_bots < max(clay_cost, obs_cost[1], geode_cost[1])
                needed_ore = max(0, ore_cost - ore)
                waiting_time = cld(needed_ore, ore_bots)
                time_spent = waiting_time + 1

                if time_spent <= time_left
                    added_nodes = true

                    k = (
                        (
                            ore + ore_bots * time_spent - ore_cost,
                            clay + clay_bots * time_spent,
                            obs + obs_bots * time_spent,
                            geode + geo_bots * time_spent
                        ),
                        (ore_bots + 1, clay_bots, obs_bots, geo_bots),
                        time_left - time_spent
                    )

                    queue[k] = min(
                        get(queue, k, typemax(Int)),
                        wasted_geodes + sum(time_left-time_spent:time_left-1)
                    )
                end
            end

            if clay_bots < obs_cost[2]
                needed_ore = max(0, clay_cost - ore)
                waiting_time = cld(needed_ore, ore_bots)
                time_spent = waiting_time + 1

                if time_spent <= time_left
                    added_nodes = true

                    k = (
                        (
                            ore + ore_bots * time_spent - clay_cost,
                            clay + clay_bots * time_spent,
                            obs + obs_bots * time_spent,
                            geode + geo_bots * time_spent
                        ),
                        (ore_bots, clay_bots + 1, obs_bots, geo_bots),
                        time_left - time_spent
                    )

                    queue[k] = min(
                        get(queue, k, typemax(Int)),
                        wasted_geodes + sum(time_left-time_spent:time_left-1)
                    )
                end
            end

            if clay_bots > 0 && obs_bots < geode_cost[2]
                needed_ore = max(0, obs_cost[1] - ore)
                needed_clay = max(0, obs_cost[2] - clay)
                waiting_time_ore = cld(needed_ore, ore_bots)
                waiting_time_clay = cld(needed_clay, clay_bots)
                time_spent = max(waiting_time_ore, waiting_time_clay) + 1

                if time_spent <= time_left
                    added_nodes = true

                    k = (
                        (
                            ore + ore_bots * time_spent - obs_cost[1],
                            clay + clay_bots * time_spent - obs_cost[2],
                            obs + obs_bots * time_spent,
                            geode + geo_bots * time_spent
                        ),
                        (ore_bots, clay_bots, obs_bots + 1, geo_bots),
                        time_left - time_spent
                    )

                    queue[k] = min(
                        get(queue, k, typemax(Int)),
                        wasted_geodes + sum(time_left-time_spent:time_left-1)
                    )
                end
            end

            if obs_bots > 0
                needed_ore = max(0, geode_cost[1] - ore)
                needed_obs = max(0, geode_cost[2] - obs)
                waiting_time_ore = cld(needed_ore, ore_bots)
                waiting_time_obs = cld(needed_obs, obs_bots)
                time_spent = max(waiting_time_ore, waiting_time_obs) + 1

                if time_spent <= time_left
                    added_nodes = true

                    k = (
                        (
                            ore + ore_bots * time_spent - geode_cost[1],
                            clay + clay_bots * time_spent,
                            obs + obs_bots * time_spent - geode_cost[2],
                            geode + geo_bots * time_spent
                        ),
                        (ore_bots, clay_bots, obs_bots, geo_bots + 1),
                        time_left - time_spent
                    )

                    queue[k] = min(
                        get(queue, k, typemax(Int)),
                        wasted_geodes + sum(time_left-time_spent+1:time_left-1)
                    )
                end
            end

            if !added_nodes
                k = (
                    (
                        ore + ore_bots * time_left,
                        clay + clay_bots * time_left,
                        obs + obs_bots * time_left,
                        geode + geo_bots * time_left
                    ),
                    (ore_bots, clay_bots, obs_bots, geo_bots),
                    0
                )

                queue[k] = min(
                    get(queue, k, typemax(Int)),
                    wasted_geodes + sum(1:time_left-1)
                )
            end
        end
    end
end

function part1()
    blueprints = Tuple{Int,Tuple{Int,Int,NTuple{2,Int},NTuple{2,Int}}}[]

    for (i, l) in enumerate(eachline("input/day19/input"))
        m = match(reg, l)

        costs = parse.(Int, m.captures)

        push!(blueprints, (i, (
            costs[1], costs[2], (costs[3:4]...,), (costs[5:6]...,)
        )))
    end

    xs = [0 for _ in 1:Threads.nthreads()]

    Threads.@threads for (i, b) in blueprints
        xs[Threads.threadid()] += i * get_n_geodes(b..., 24)
    end

    sum(xs)
end

function part2()
    blueprints = Tuple{Int,Tuple{Int,Int,NTuple{2,Int},NTuple{2,Int}}}[]

    for (i, l) in enumerate(eachline("input/day19/input"))
        m = match(reg, l)

        costs = parse.(Int, m.captures)

        push!(blueprints, (i, (
            costs[1], costs[2], (costs[3:4]...,), (costs[5:6]...,)
        )))
    end

    xs = [1 for _ in 1:Threads.nthreads()]

    Threads.@threads for (_, b) in blueprints[1:3]
        xs[Threads.threadid()] *= get_n_geodes(b..., 32)
    end

    prod(xs)
end
