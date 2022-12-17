
pieces::Vector{BitMatrix} = BitMatrix[
    [true true true true],
    [
        false true false
        true true true
        false true false
    ],
    [
        true true true
        false false true
        false false true
    ],
    [true; true; true; true;;],
    [
        true true
        true true
    ]
]

function is_overlap(board, piece, x, y)
    for i in axes(piece, 1), j in axes(piece, 2)
        if piece[i, j] && (x + j - 1, y + i - 1) ∈ board
            return true
        end
    end

    false
end

function is_outside(piece, x, y)
    x < 1 || x + size(piece, 2) - 1 > 7 || y < 1
end

function insert_piece(board, piece, x, y)
    for i in axes(piece, 1), j in axes(piece, 2)
        if piece[i, j]
            push!(board, (x + j - 1, y + i - 1))
        end
    end
end

function part1()
    inp = Vector{Char}(popfirst!(Iterators.Stateful(eachline("input/day17/input"))))
    i = 1

    board = Set{Tuple{Int,Int}}()

    peak = 0

    pieces_placed = 0

    while pieces_placed < 2022
        x = 3
        y = peak + 4

        piece = pieces[pieces_placed%length(pieces)+1]

        while true
            d = inp[i]
            i += 1
            if i > length(inp)
                i = 1
            end
            s = if d == '>'
                1
            else
                -1
            end

            if !is_overlap(board, piece, x + s, y) && !is_outside(piece, x + s, y)
                x += s
            end

            if !is_overlap(board, piece, x, y - 1) && !is_outside(piece, x, y - 1)
                y -= 1
            else
                pieces_placed += 1
                peak = max(peak, y + size(piece, 1) - 1)
                insert_piece(board, piece, x, y)
                break
            end
        end
    end

    peak
end

function extract_top_n(board, n, peak)
    mat = falses(n, 7)

    for i in 1:n, j in 1:7
        mat[i, j] = (j, i + peak - n) ∈ board
    end

    mat
end

function part2()
    inp = Vector{Char}(popfirst!(Iterators.Stateful(eachline("input/day17/input"))))
    i = 1

    board = Set{Tuple{Int,Int}}()

    peak = 0
    skipped_height = 0

    pieces_placed = 0
    pieces_skipped = 0

    seen_states = Dict{Tuple{BitMatrix,Int,Int},Tuple{Int,Int}}()

    n = 6

    piece_target = 1000000000000

    while pieces_placed + pieces_skipped < piece_target
        x = 3
        y = peak + 4

        piece = pieces[pieces_placed%length(pieces)+1]

        while true
            d = inp[i]
            i += 1
            if i > length(inp)
                i = 1
            end
            s = if d == '>'
                1
            else
                -1
            end

            if !is_overlap(board, piece, x + s, y) && !is_outside(piece, x + s, y)
                x += s
            end

            if !is_overlap(board, piece, x, y - 1) && !is_outside(piece, x, y - 1)
                y -= 1
            else
                pieces_placed += 1
                peak = max(peak, y + size(piece, 1) - 1)
                insert_piece(board, piece, x, y)

                if peak > n
                    key = (
                        extract_top_n(board, n, peak),
                        pieces_placed % length(pieces) + 1,
                        i
                    )

                    if skipped_height == 0
                        if haskey(seen_states, key)
                            (prev_peak, prev_pieces) = seen_states[key]

                            n_piece_skip = pieces_placed - prev_pieces
                            height_gained = peak - prev_peak

                            n_rounds = (piece_target - pieces_placed) ÷ n_piece_skip
                            skipped_height = height_gained * n_rounds
                            pieces_skipped = n_piece_skip * n_rounds
                        else
                            seen_states[key] = (peak, pieces_placed)
                        end
                    end
                end
                break
            end
        end
    end

    peak + skipped_height
end
