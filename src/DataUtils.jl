module DataUtils

# Use README as the docstring of the module:
@doc let path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    replace(read(path, String), r"^```julia"m => "```jldoctest README")
end DataUtils

export slimdataforvegalite, nonmissing

import Tables
using BangBang: append!!
using DataFrames: DataFrame, DataFrames, by, rename!, select!

include("base.jl")
include("dataframes.jl")

end # module
