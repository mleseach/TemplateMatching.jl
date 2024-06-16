module TemplateMatching

export match_template,
       match_template!,
       SquareDiff,
       NormalizedSquareDiff,
       CrossCorrelation,
       NormalizedCrossCorrelation,
       CorrelationCoeff,
       NormalizedCorrelationCoeff

include("IntegralArray.jl")

@doc raw"""
Base type for specifying the algorithm used in template matching operations.

`Algorithm` serves as an abstract base type for all template matching algorithms within the
package. It is meant to be subclassed by specific algorithm implementations.
"""
abstract type Algorithm end

@doc raw"""
Algorithm that calculate the squared difference between the source and the template.

This method is used to find how much each part of the source array differs from the
template by squaring the difference between corresponding values. It is straightforward
and works well when the brightness of the images does not vary much.
Lower values indicate a better match.

# Formula
``R_i = \sum_j (S_{i+j} - T_j)^2``

See also [`NormalizedSquareDiff`](@ref)
"""
struct SquareDiff <: Algorithm end

@doc raw"""
Normalized algorithm for computing the squared difference between the source and the
template.

This method extends the [`SquareDiff`](@ref) algorithm by normalizing the squared
differences. It is more robust against variations in brightness and contrast between
the source and template images.
Lower values indicate a better match.
    
# Formula
``R_i = \frac{\sum_j (S_{i+j} - T_j)^2}{\sqrt{\sum_j S_{i+j}^2 \cdot \sum_j T_j^2}}``

See also [`SquareDiff`](@ref)
"""
struct NormalizedSquareDiff <: Algorithm end

@doc raw"""
Algorithm that calculates the cross-correlation between the source and the template.

This method computes the similarity between the source and template by multiplying
their corresponding elements and summing up the results. This approach inherently
favors the brighter regions of the source image over the darker ones since the product
of higher intensity values will naturally be greater.
Higher values indicate a better match.

# Formula
``R_i = \sum_j (S_{i+j} \cdot T_j)``

See also [`NormalizedCrossCorrelation`](@ref)
"""
struct CrossCorrelation <: Algorithm end

@doc raw"""
Normalized algorithm for computing the cross-correlation between the source and the
template.

This method improves upon the [`CrossCorrelation`](@ref) by normalizing the results. It
calculates the similarity by multiplying corresponding elements, summing up those products,
and then dividing by the product of their norms. This reduces the bias toward brighter
areas, providing a more balanced measurement of similarity.
Higher values indicate a better match.

# Formula
``R_i = \frac{\sum_j (S_{i+j} \cdot T_j)}{\sqrt{\sum_j S_{i+j}^2 \cdot \sum_j T_j^2}}``

See also [`CrossCorrelation`](@ref)
"""
struct NormalizedCrossCorrelation <: Algorithm end

@doc raw"""
Algorithm that measures the correlation coefficient between the source and the template.

This method quantifies the degree to which the source and template match by computing their
correlation coefficient. It offers a balance between capturing the structural similarity
and adjusting for brightness variations, making it less biased towards the brighter parts
in comparison to simple cross-correlation methods.
A higher value indicates a better match.

# Formula
``
R_i = \frac{
    \sum_j ((S_{i+j} - \bar{S}_i) \cdot (T_j - \bar{T}))
}{
    \sqrt{\sum_j (S_{i+j} - \bar{S}_i)^2 \cdot \sum_j (T_j - \bar{T})^2}
}
``

Where ``\bar{S}_i`` is the mean of the source values within the region considered for
matching and ``\bar{T}`` is the mean of the template values.

See also [`NormalizedCorrelationCoeff`](@ref)
"""
struct CorrelationCoeff <: Algorithm end

@doc raw"""
Normalized algorithm for computing the correlation coefficient between the source and the
template.

This method extends the [`CorrelationCoeff`](@ref) by applying additional normalization
steps, aiming to further minimize the influence of the absolute brightness levels and
enhance the robustness of matching. It calculates the normalized correlation coefficient,
providing a standardized measure.
A higher value indicates a better match.

# Formula
``
R_i = \frac{
    \sum_j ((S_{i+j} - \bar{S}_i) \cdot (T_j - \bar{T}))
}{
    \sqrt{\sum_j (S_{i+j} - \bar{S}_i)^2} \cdot \sqrt{\sum_j (T_j - \bar{T})^2}
}
``

Where ``\bar{S}_i`` is the mean of the source values within the region considered for
matching and ``\bar{T}`` is the mean of the template values.

See also [`CorrelationCoeff`](@ref)
"""
struct NormalizedCorrelationCoeff <: Algorithm end

include("square_diff.jl")
include("cross_correlation.jl")
include("correlation_coeff.jl")

@doc raw"""
    match_template(source, template, alg::Algorithm)

Performs template matching between the source image and template using a specified
algorithm.

Compare a template to a source image using the algorithm specified by the `alg` parameter.
It is designed to work with arrays of more than two dimensions, making it suitable for
multidimensional arrays or sets of images. The function slides the template over the source
array in all possible positions, computing a similarity metric at each position.

# Arguments
- `source`: Source array to search within. 
- `template`: Template array to search for.
- `alg::Algorithm`: Algorithm to use for calculating the similarity metric.

The dimensions of the `source` array should be greater than or equal to the dimensions of
the `template` array. If the `source` is of size `(S_1, S_2, ...)` and `template` is
`(T_1, T_2, ...)`, then the size of the resultant match array will be
`(S_1-T_1+1, S_2-T_2+1, ...)`, representing the similarity metric for each possible
position of the template over the source.

The algorithm for matching is chosen by passing an instance of one of the following structs
as the `alg` parameter: [`SquareDiff`](@ref), [`NormalizedSquareDiff`](@ref),
[`CrossCorrelation`](@ref), [`NormalizedCrossCorrelation`](@ref),
[`CorrelationCoeff`](@ref), or [`NormalizedCorrelationCoeff`](@ref).

# Returns
Return an array of the same number of dimensions as the input arrays,
containing the calculated similarity metric at each position of the template over the
source image.

# Examples
```julia
source = rand(100, 100)
template = rand(10, 10)
result = match_template(source, template, CrossCorrelation())
```

```jldoctest
source = rand(100, 100)
template = source[10:15, 20:30]
result = match_template(source, template, SquareDiff())
argmin(result)

# output
CartesianIndex(10, 20)
```

```jldoctest
source = rand(100, 100)
template = source[10:15, 20:30]
result = match_template(source, template, CorrelationCoeff())
argmax(result)

# output
CartesianIndex(10, 20)
```

See also [`match_template!`](@ref) for a version of this function that writes the result
into a preallocated array.
"""
function match_template(source, template, alg::Algorithm)
    dest_size = Tuple(size(source) .- size(template) .+ 1)

    # similar doesn't work on channelview
    dest = Array{eltype(source)}(undef, dest_size)

    return match_template!(dest, source, template, alg)
end

@doc raw"""
    match_template!(dest, source, template, alg::Algorithm)

Performs template matching and writes the results into a preallocated destination array.

Inplace counterpart to `match_template`, designed to perform the template matching
operation and store the results in a preallocated array `dest` passed by the user.
This reduces memory allocations and can be more efficient when performing multiple
template matching operations. It compares a template to a source image using the
specified algorithm, suitable for multidimensional arrays or sets of images.

See [`match_template`](@ref) for further documentation.
    
# Arguments
- `dest`: Preallocated destination array where the result will be stored.
- `source`: Source array to search within.
- `template`: Template array to search for.
- `alg::Algorithm`: Algorithm for calculating the similarity.

# Returns
Return its first argument `dest` containing the calculated similarity metric at each
position of the template over the source image.

The dimensions of the `source` array should be greater than or equal to the dimensions of
the template array. If the source is of size `(S_1, S_2, ...)` and `template` is
`(T_1, T_2, ...)`, then `dest` must be preallocated with dimensions
`(S_1-T_1+1, S_2-T_2+1, ...)`, representing the similarity metric for each possible
position of the template over the source.

The algorithm for matching is chosen by passing an instance of one of the following structs
as the `alg` parameter: [`SquareDiff`](@ref), [`NormalizedSquareDiff`](@ref),
[`CrossCorrelation`](@ref), [`NormalizedCrossCorrelation`](@ref),
[`CorrelationCoeff`](@ref), or [`NormalizedCorrelationCoeff`](@ref).

# Examples
```julia
source = rand(100, 100)
template = rand(10, 10)
dest = Array{Float64}(undef, 91, 91)
match_template!(dest, source, template, CrossCorrelation())

dest = Array{Float64}(undef, 100, 100)
match_template!(dest, source, template, CrossCorrelation()) # will fail
```

See also [`match_template`](@ref) for an immutable version of this function.
"""
match_template!(dest, source, template, alg)

function match_template!(dest, source, template, ::SquareDiff)
    return square_diff!(dest, source, template)
end

function match_template!(dest, source, template, ::NormalizedSquareDiff)
    return normalized_square_diff!(dest, source, template)
end

function match_template!(dest, source, template, ::CrossCorrelation)
    return cross_correlation!(dest, source, template)
end

function match_template!(dest, source, template, ::NormalizedCrossCorrelation)
    return normalized_cross_correlation!(dest, source, template)
end

function match_template!(dest, source, template, ::CorrelationCoeff)
    return correlation_coeff!(dest, source, template)
end

function match_template!(dest, source, template, ::NormalizedCorrelationCoeff)
    return normalized_correlation_coeff!(dest, source, template)
end

end
