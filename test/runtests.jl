using TestItems

@testitem "Initialization tests" begin
    @test ContrastLimitedAdaptiveHistogramEqualization() isa ContrastLimitedAdaptiveHistogramEqualization
end


@testitem "Parameter validation tests" begin
    using CLAHE: validate_parameters
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; rblocks=0))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; rblocks=-1))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; cblocks=0))
    @test_throws ArgumentError validate_parameters(ContrastLimitedAdaptiveHistogramEqualization(; cblocks=-1))
end

@testitem "No crash for different image sizes" begin
    using TestImages: testimage
    using ImageTransformations: imresize
    f = ContrastLimitedAdaptiveHistogramEqualization()
    image = "cameraman" # Grayscale
    for xsz in [63, 64, 65, 96, 128, 256, 300, 512], ysz in [63, 64, 65, 96, 128, 256, 300, 512]
        @info "Testing size: ($xsz, $ysz) for image: $image"
        img = imresize(testimage(image), (xsz, ysz))
        out = adjust_histogram(img, f)
        @test size(out) == size(img)
    end
end


@testitem "No crash for different image types" begin
    using TestImages: testimage
    using ImageBase
    f = ContrastLimitedAdaptiveHistogramEqualization()
    for image in ["cameraman", "mandrill"], colortype in [Gray, RGB, RGBA], numerictype in [N0f8, N0f16, Float32, Float64]
        @test adjust_histogram(convert.(colortype{numerictype}, testimage(image)), f) isa Array{colortype{numerictype},2}
    end
end