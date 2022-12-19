
reg::Regex = r"Blueprint \d+: Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\."

function get_n_geodes(ore_cost, clay_cost, obs_cost, geode_cost)
    memo = Dict{Tuple{NTuple{4,Int},NTuple{4,Int},Int},Int}()

    function rec((ore, clay, obs, geode),
        (ore_bots, clay_bots, obs_bots, geo_bots), time_left)

        k = ((ore, clay, obs, geode),
            (ore_bots, clay_bots, obs_bots, geo_bots), time_left)

        if haskey(memo, k)
            return memo[k]
        end

        if time_left == 0
            memo[k] = geode
            return geode
        end

        tot_geodes = rec(
            (
                ore + ore_bots,
                clay + clay_bots,
                obs + obs_bots,
                geode + geo_bots
            ),
            (ore_bots, clay_bots, obs_bots, geo_bots),
            time_left - 1
        )

        if ore >= ore_cost
            tot_geodes = max(tot_geodes, rec(
                (
                    ore + ore_bots - ore_cost,
                    clay + clay_bots,
                    obs + obs_bots,
                    geode + geo_bots
                ),
                (ore_bots + 1, clay_bots, obs_bots, geo_bots),
                time_left - 1
            ))
        end

        if ore >= clay_cost
            tot_geodes = max(tot_geodes, rec(
                (
                    ore + ore_bots - clay_cost,
                    clay + clay_bots,
                    obs + obs_bots,
                    geode + geo_bots
                ),
                (ore_bots, clay_bots + 1, obs_bots, geo_bots),
                time_left - 1
            ))
        end

        if ore >= obs_cost[1] && clay >= obs_cost[2]
            tot_geodes = max(tot_geodes, rec(
                (
                    ore + ore_bots - obs_cost[1],
                    clay + clay_bots - obs_cost[2],
                    obs + obs_bots,
                    geode + geo_bots
                ),
                (ore_bots, clay_bots, obs_bots + 1, geo_bots),
                time_left - 1
            ))
        end

        if ore >= geode_cost[1] && obs >= geode_cost[2]
            tot_geodes = max(tot_geodes, rec(
                (
                    ore + ore_bots - geode_cost[1],
                    clay + clay_bots,
                    obs + obs_bots - geode_cost[2],
                    geode + geo_bots
                ),
                (ore_bots, clay_bots, obs_bots, geo_bots + 1),
                time_left - 1
            ))
        end

        memo[k] = tot_geodes

        tot_geodes
    end

    rec((0, 0, 0, 0), (1, 0, 0, 0), 24)
end

function part1()
    tasks = Task[]

    for (i, l) in enumerate(eachline("input/day19/ex1"))
        m = match(reg, l)

        costs = parse.(Int, m.captures)

        push!(tasks, @async get_n_geodes(
            costs[1], costs[2], (costs[3:4]...,), (costs[5:6]...,)
        ))
    end

    x
end

function part2()
    for l in eachline("input/day19/input")
    end
end
