"""
    nonmissing(args...)

Something like `something` but for `missing`s.
"""
nonmissing(args...) = something(map(x -> x === missing ? nothing : x, args)...)
