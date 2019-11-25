using Documenter, DataUtils

makedocs(;
    modules=[DataUtils],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/tkf/DataUtils.jl/blob/{commit}{path}#L{line}",
    sitename="DataUtils.jl",
    authors="Takafumi Arakaki <aka.tkf@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/tkf/DataUtils.jl",
)
