"""
    asdataframe(table) :: DataFrame

Robust table-to-`DataFrame` conversion.  Missing columns are filled
with `missing`s.

# Examples
```jldoctest
julia> using DataUtils: asdataframe

julia> asdataframe([(a=1, b=2), (a=3,)])
2×2 DataFrames.DataFrame
│ Row │ a     │ b       │
│     │ Int64 │ Int64⍰  │
├─────┼───────┼─────────┤
│ 1   │ 1     │ 2       │
│ 2   │ 3     │ missing │
```
"""
asdataframe(df::DataFrames.AbstractDataFrame) = df
function asdataframe(table::T) where {T}
    if (
        Base.IteratorEltype(T) isa Base.HasEltype && eltype(T) <: NamedTuple &&
        !(isconcretetype(eltype(T)) && Tables.istable(typeof(table)))
    )
        # In this case, `DataFrame` constructor does not work well.
        return _asdataframe(table)
    elseif Tables.istable(table)
        return DataFrame(table)
    elseif !(table isa AbstractArray)
        return asdataframe(collect(table))
    end
    return _asdataframe(table)
end

# Not sure if an iterable is stateless; so let's collect it first:
_asdataframe(itr) = _asdataframe(collect(itr)::AbstractArray)

_getvalue(x, name, default) =
    hasproperty(x, name) ? getproperty(x, name) : default
_getvalue(x::NamedTuple, name, default) = get(x, name, default)

function _asdataframe(table::AbstractArray)
    # Merge all column names of all rows:
    allnames = foldl(table; init=Symbol[]) do allnames, row
        newnames = setdiff(propertynames(row), allnames)
        append!(allnames, newnames)
    end

    # Create an empty DataFrame with known column names:
    df = DataFrame(fill(Union{}[], length(allnames)), allnames)

    # An iterable that yields named tuples with a fixed set of names:
    rows = let allnames = Tuple(allnames)
        Base.Generator(table) do row
            kvs = map(allnames) do name
                (name => _getvalue(row, name, missing))
            end
            return (; kvs...)
        end
    end

    # BangBang will appropriately widen column vectors:
    return append!!(df, rows)
end

function refineeltype(xs)
    if isconcretetype(Core.Compiler.typesubtract(Union{eltype(xs),Missing}, Missing))
        return xs
    else
        return identity.(xs)
    end
end

"""
    slimdataforvegalite(table) -> df

Remove columns that are not usable in vega-lite.  It also renames
column names with `.` and `-` to use `_` instead.

See also: <https://github.com/queryverse/VegaLite.jl/pull/195>

# Examples
```jldoctest
julia> using DataUtils

julia> slimdataforvegalite([(a=1, b=2, c=Ref(0)), (a=3,)])
2×2 DataFrames.DataFrame
│ Row │ a     │ b       │
│     │ Int64 │ Int64⍰  │
├─────┼───────┼─────────┤
│ 1   │ 1     │ 2       │
│ 2   │ 3     │ missing │
```
"""
function slimdataforvegalite(table)
    df = asdataframe(table)
    size(df, 1) == 0 && return df

    # To use `eltype(column)` below, refine `eltype` of all columns first:
    cols = map(refineeltype, eachcol(df))
    cnames = propertynames(df)

    idx = [
        i
        for (i, column) in enumerate(cols) if (
            eltype(column) <: Union{AbstractString,Missing,Nothing,Number,Symbol}
        )
    ]

    df = DataFrame(cols[idx], cnames[idx])

    rename!(df) do name
        str = String(name)
        str = replace(str, "." => "_")
        str = replace(str, "-" => "_")
        return Symbol(str)
    end
    return df
end
