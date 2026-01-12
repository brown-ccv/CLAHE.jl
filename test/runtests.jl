using TestItems

@testitem "Initialization tests" begin
    @test ContrastLimitedAdaptiveEqualization() isa ContrastLimitedAdaptiveEqualization
end


@testitem "Parameter validation tests" begin
    using CLAHE: validate_parameters
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; clip=-0.1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; clip=1.1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; rblocks=0))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; rblocks=-1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; cblocks=0))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; cblocks=-1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; rblocks=1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveEqualization(; cblocks=1))
end


@testitem "Null operation tests" begin
    using ImageCore: Gray, fill, n0f8
    using TestImages: testimage
    for img in [fill(Gray(n0f8(0.0)), 16, 16),
        fill(Gray(n0f8(1.0)), 16, 16),
        testimage("cameraman")]
        f = ContrastLimitedAdaptiveEqualization(; clip=1.0)
        out = adjust_histogram(img, f)
        @test size(out) == size(img)
        @test all(out .== img)
    end
end