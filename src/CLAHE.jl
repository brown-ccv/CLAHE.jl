module CLAHE

# Boilerplate from ImageContrastAdjustment.jl
using ImageContrastAdjustment
using ImageContrastAdjustment: AbstractHistogramAdjustmentAlgorithm, GenericGrayImage, imresize
using ImageCore
using ImageBase

# Where possible we avoid a direct dependency to reduce the number of [compat] bounds
using ImageCore.MappedArrays
using Parameters: @with_kw # Same as Base.@kwdef but works on Julia 1.0

greet() = print("Hello World!")

"""
```
    ContrastLimitedAdaptiveEqualization <: AbstractHistogramAdjustmentAlgorithm
    ContrastLimitedAdaptiveEqualization(; nbins = 128, minval = 0, maxval = 1, rblocks = 8, cblocks = 8, clip = 0.1)

    adjust_histogram([T,] img, f::ContrastLimitedAdaptiveEqualization)
    adjust_histogram!([out,] img, f::ContrastLimitedAdaptiveEqualization)
```

Performs Contrast Limited Adaptive Histogram Equalisation (CLAHE) on the input
image. 

This version is based on the description in:
GraphicsGems IV, "Contrast Limited Adaptive Histogram Equalization".

"""
@with_kw struct ContrastLimitedAdaptiveEqualization{T₁<:Union{Real,AbstractGray},
    T₂<:Union{Real,AbstractGray},
    T₃<:Real} <: AbstractHistogramAdjustmentAlgorithm
    nbins::Int = 128
    minval::T₁ = 0.0
    maxval::T₂ = 1.0
    rblocks::Int = 8
    cblocks::Int = 8
    clip::T₃ = 0.1
end

function (f::ContrastLimitedAdaptiveEqualization)(out::GenericGrayImage, img::GenericGrayImage)
    validate_parameters(f)
    height, width = length.(axes(img))
    @info "height: $height, width: $width"

    # If necessary, resize the image so that the requested number of blocks fit exactly.
    resized_height = ceil(Int, height / (2 * f.rblocks)) * 2 * f.rblocks
    resized_width = ceil(Int, width / (2 * f.cblocks)) * 2 * f.cblocks
    must_resize = (resized_height != height) || (resized_width != width) ? true : false
    @info "must_resize: $must_resize, resized_height: $resized_height, resized_width: $resized_width"
    if must_resize
        @info "resizing"
        img_tmp = imresize(img, (resized_height, resized_width))
        out_tmp = copy(img_tmp)
    else
        img_tmp = img
        out_tmp = copy(img)
    end

    out .= must_resize ? imresize(out_tmp, (height, width)) : out_tmp
    return out
end

function validate_parameters(f::ContrastLimitedAdaptiveEqualization)
    !(0 <= f.clip <= 1) && throw(ArgumentError("The parameter `clip` must be in the range [0..1]."))
    !(2 <= f.rblocks && 2 <= f.cblocks) && throw(ArgumentError("At least 4 contextual regions required (2x2 or greater)."))
end

export ContrastLimitedAdaptiveEqualization, adjust_histogram, adjust_histogram!

end # module CLAHE
