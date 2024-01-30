module TemplateMatching

export match_template, match_template!,
    SquareDiff, NormedSquareDiff,
    CrossCorrelation, NormedCrossCorrelation,
    CorrelationCoef, NormedCorrelationCoef

include("IntegralArray.jl")

abstract type Algorithm end

struct SquareDiff <: Algorithm end
struct NormedSquareDiff <: Algorithm end
struct CrossCorrelation <: Algorithm end
struct NormedCrossCorrelation <: Algorithm end
struct CorrelationCoef <: Algorithm end
struct NormedCorrelationCoef <: Algorithm end

include("square_diff.jl")
include("cross_correlation.jl")
include("correlation_coef.jl")

function match_template(source, template, alg::Algorithm)
    dest_size = Tuple(size(source) .- size(template) .+ 1)

    # similar doesn't work on channelview
    dest = Array{eltype(source)}(undef, dest_size)

    return match_template!(dest, source, template, alg)
end

function match_template!(dest, source, template, ::SquareDiff)
    return square_diff!(dest, source, template)
end

function match_template!(dest, source, template, ::NormedSquareDiff)
    return normed_square_diff!(dest, source, template)
end

function match_template!(dest, source, template, ::CrossCorrelation)
    return cross_correlation!(dest, source, template)
end

function match_template!(dest, source, template, ::NormedCrossCorrelation)
    return normed_cross_correlation!(dest, source, template)
end

function match_template!(dest, source, template, ::CorrelationCoef)
    return correlation_coef!(dest, source, template)
end

function match_template!(dest, source, template, ::NormedCorrelationCoef)
    return normed_correlation_coef!(dest, source, template)
end

end