"""
    asnamedtuple(x) :: NamedTuple

# Examples
```jldoctest
julia> using DataUtils: asnamedtuple

julia> asnamedtuple(Dict(:a => 1, :b => 2))
(a = 1, b = 2)

julia> asnamedtuple(Dict("a" => 1, "b" => 2))
(b = 2, a = 1)

julia> asnamedtuple(1 + 2im)
(re = 1, im = 2)
```
"""
asnamedtuple(d::AbstractDict) =
    NamedTuple{Tuple(Symbol.(keys(d)))}(Tuple(values(d)))

asnamedtuple(obj) = NamedTuple{fieldnames(typeof(obj))}(fieldvalues(obj))

fieldvalues(obj) = ntuple(i -> getfield(obj, i), nfields(obj))
