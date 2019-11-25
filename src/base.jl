"""
    nonmissing(args...)

Something like `something` but for `missing`s.
"""
nonmissing(args...) = something(map(x -> x === missing ? nothing : x, args)...)

"""
    findallmatches(r::Regex, s::AbstractString) :: Vector{RegexMatch}

Find all non-overlapping matches of regular expression `r` in string `s`.
"""
function findallmatches(r::Regex, s::AbstractString)
    matches = RegexMatch[]
    i = firstindex(s)
    while true
        m = match(r, s, i)
        m === nothing && return matches
        push!(matches, m)
        i = m.offset + sizeof(m.match)
    end
end
