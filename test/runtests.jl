using TestItems

@testitem "Initialization tests" begin
    @test ContrastLimitedAdaptiveHistogramEqualization() isa ContrastLimitedAdaptiveHistogramEqualization
end


@testitem "Parameter validation tests" begin
    using CLAHE: validate_parameters
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; clip=-0.1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; clip=1.1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; rblocks=0))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; rblocks=-1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; cblocks=0))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; cblocks=-1))
end

@testitem "Zeroes image, clip=1" begin
    using ImageCore: Gray, fill, n0f8
    img = fill(Gray(n0f8(0.0)), 32, 32)
    f = ContrastLimitedAdaptiveHistogramEqualization(; clip=1.0, nbins=4)
    out = adjust_histogram(img, f)
    @info img
    @info out
    @test size(out) == size(img)
    @test all(out .== img)
end

@testitem "Grays image, clip=1" begin
    using ImageCore: Gray, fill, n0f8
    img = fill(Gray(n0f8(0.5)), 32, 32)
    f = ContrastLimitedAdaptiveHistogramEqualization(; clip=1.0, nbins=4)
    out = adjust_histogram(img, f)
    @info img
    @info out
    @test size(out) == size(img)
    @test all(out .== img)
end

@testitem "Ones image, clip=1" begin
    using ImageCore: Gray, fill, n0f8
    img = fill(Gray(n0f8(1.0)), 32, 32)
    f = ContrastLimitedAdaptiveHistogramEqualization(; clip=1.0, nbins=4)
    out = adjust_histogram(img, f)
    @info img
    @info out
    @test size(out) == size(img)
    @test all(out .== img)
end

@testitem "Cameraman image, clip=1" begin
    using TestImages: testimage
    img = testimage("cameraman")
    f = ContrastLimitedAdaptiveHistogramEqualization(; clip=1.0)
    out = adjust_histogram(img, f)
    @test size(out) == size(img)
    @test all(out .== img)
end