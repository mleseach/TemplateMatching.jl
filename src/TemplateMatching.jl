module TemplateMatching

export match_template, match_template!,
    SquareDiff, NormalizedSquareDiff,
    CrossCorrelation, NormalizedCrossCorrelation,
    CorrelationCoeff, NormalizedCorrelationCoeff

include("IntegralArray.jl")

abstract type Algorithm end

struct SquareDiff <: Algorithm end
struct NormalizedSquareDiff <: Algorithm end
struct CrossCorrelation <: Algorithm end
struct NormalizedCrossCorrelation <: Algorithm end
struct CorrelationCoeff <: Algorithm end
struct NormalizedCorrelationCoeff <: Algorithm end

include("square_diff.jl")
include("cross_correlation.jl")
include("correlation_coeff.jl")

function match_template(source, template, alg::Algorithm)
    dest_size = Tuple(size(source) .- size(template) .+ 1)

    # similar doesn't work on channelview
    dest = Array{eltype(source)}(undef, dest_size)

    return match_template!(dest, source, template, alg)
end

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