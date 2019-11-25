module TestBase

using DataUtils
using Test

getmatch(x) = x.match
getoffset(x) = x.offset

@testset "findallmatches($(repr(r)), $(repr(s)))" for (r, s, desired) in [
    (
        r = r"a",
        s = "a__a_a",
        desired = RegexMatch.(
            "a",                # match
            Ref([]),            # captures
            [1, 4, 6],          # offsets
            Ref([]),            # offsets
            r"a",               # regex
        ),
    ),
    (
        r = r"σ",
        s = "σ__σ_σ",
        desired = RegexMatch.(
            "σ",                # match
            Ref([]),            # captures
            [1, 5, 8],          # offsets
            Ref([]),            # offsets
            r"σ",               # regex
        ),
    ),
    (
        r = r"[σa]",
        s = "σ_aσ_aσ",
        desired = RegexMatch.(
            ["σ", "a", "σ", "a", "σ"], # match
            Ref([]),                   # captures
            [1, 4, 5, 8, 9],           # offset
            Ref([]),                   # offsets
            r"σa",                     # regex
        ),
    )
]
    actual = findallmatches(r, s)
    @test getmatch.(actual) == getmatch.(desired)
    @test getoffset.(actual) == getoffset.(desired)

    # `==` doesn't work since it fallbacks to `===`:
    # @test actual == desired
end

end  # module
