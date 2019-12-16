module TestDoctests

using DataUtils
using Documenter
using Test

@testset "docstest" begin
    doctest(DataUtils; manual=false)
end

end  # module
