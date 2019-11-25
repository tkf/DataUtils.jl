module TestDataframes

using DataUtils
using Test

@testset "slimdataforvegalite" begin
    table = [
        # a: uniform column
        # b: not vegalite-friendly
        # c: with missing
        # d: structural missing
        (a = 1, b = [0], c = missing),
        (a = 2, b = [0], c = 1, d = 0),
        (a = 3, b = [0], c = 1),
    ]
    df = slimdataforvegalite(table)
    @test propertynames(df) == [:a, :c, :d]
    @test eltype(df.a) == Int
    @test eltype(df.c) == Union{Missing,Int}
    @test eltype(df.d) == Union{Missing,Int}
    @test df.a == [1, 2, 3]
    @test isequal(df.c, [missing, 1, 1])
    @test isequal(df.d, [missing, 0, missing])
end

end  # module
