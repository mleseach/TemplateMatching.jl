using Test
using TemplateMatching

using ImageFiltering
using Statistics
using Random

rng = Xoshiro(0)

@testset "::SquareDiff" begin
    function naive_square_diff(source, template)
        sum2(a) = sum(x -> x^2, a)

        result = mapwindow(source, size(template), border=Inner()) do subsection
            sum2(subsection .- template)
        end
    
        return parent(result)
    end

    let
        source = rand(rng, 100, 3, 100)
        template = source[50:70, :, 30:35]
        dest = similar(source, 80, 1, 95)

        result = match_template!(dest, source, template, SquareDiff())

        @test argmin(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_square_diff(source, template)
        result = match_template(source, template, SquareDiff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)

        naive_result = naive_square_diff(source, template)
        result = match_template(source, template, SquareDiff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end
end

@testset "::NormalizedSquareDiff" begin
    function naive_normalized_square_diff(source, template)
        sum2(a) = sum(x -> x^2, a)
        sum2_template = sum2(template)

        result = mapwindow(source, size(template), border=Inner()) do subsection
            sum2(subsection .- template) / sqrt(sum2(subsection) * sum2_template)
        end
    
        return parent(result)
    end

    let
        source = rand(rng, 100, 3, 100)
        template = source[50:70, :, 30:35]
        dest = similar(source, 80, 1, 95)

        result = match_template!(dest, source, template, NormalizedSquareDiff())

        @test argmin(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_normalized_square_diff(source, template)
        result = match_template(source, template, NormalizedSquareDiff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)

        naive_result = naive_normalized_square_diff(source, template)
        result = match_template(source, template, NormalizedSquareDiff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end    
end

@testset "::CrossCorrelation" begin
    function naive_cross_correlation(source, template)
        result = mapwindow(source, size(template), border=Inner()) do subsection
            sum(subsection .* template)
        end
    
        return parent(result)
    end

    let
        source = rand(rng, 100, 3, 100)
        template = source[50:70, :, 30:35]
        dest = similar(source, 80, 1, 95)

        result = match_template!(dest, source, template, CrossCorrelation())

        @test argmax(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_cross_correlation(source, template)
        result = match_template(source, template, CrossCorrelation())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)
        naive_result = naive_cross_correlation(source, template)
        result = match_template(source, template, CrossCorrelation())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end
end

@testset "::NormalizedCrossCorrelation" begin
    function naive_normalized_cross_correlation(source, template)
        sum2(a) = sum(x -> x^2, a)
        sum2_template = sum2(template)

        result = mapwindow(source, size(template), border=Inner()) do subsection
            sum(subsection .* template) / sqrt(sum2(subsection) * sum2_template)
        end
    
        return parent(result)
    end

    let
        source = rand(rng, 100, 3, 100)
        template = source[50:70, :, 30:35]
        dest = similar(source, 80, 1, 95)

        result = match_template!(dest, source, template, NormalizedCrossCorrelation())

        @test argmax(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end

    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_normalized_cross_correlation(source, template)
        result = match_template(source, template, NormalizedCrossCorrelation())

        @test all(isapprox.(result, naive_result, rtol=1e-5))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)

        naive_result = naive_normalized_cross_correlation(source, template)
        result = match_template(source, template, NormalizedCrossCorrelation())

        @test all(isapprox.(result, naive_result, rtol=1e-5))
    end
end

@testset "::CorrelationCoeff" begin
    function naive_correlation_coeff(source, template)
        template = template .- mean(template)

        result = mapwindow(source, size(template), border=Inner()) do subsection
            subsection = subsection .- mean(subsection)

            sum(subsection .* template)
        end
    
        return parent(result)
    end

    let
        source = rand(rng, 100, 3, 100)
        template = source[50:70, :, 30:35]
        dest = similar(source, 80, 1, 95)

        result = match_template!(dest, source, template, CorrelationCoeff())

        @test argmax(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_correlation_coeff(source, template)
        result = match_template(source, template, CorrelationCoeff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)
        naive_result = naive_correlation_coeff(source, template)
        result = match_template(source, template, CorrelationCoeff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end
end

@testset "::NormalizedCorrelationCoeff" begin
    function naive_normalized_correlation_coeff(source, template)
        sum2(a) = sum(x -> x^2, a)

        template = template .- mean(template)
        sum2_template = sum2(template)

        result = mapwindow(source, size(template), border=Inner()) do subsection
            subsection = subsection .- mean(subsection)

            sum(subsection .* template) / sqrt(sum2(subsection) * sum2_template)
        end
    
        return parent(result)
    end

    let
        source = rand(rng, 100, 3, 100)
        template = source[50:70, :, 30:35]
        dest = similar(source, 80, 1, 95)

        result = match_template!(dest, source, template, NormalizedCorrelationCoeff())

        @test argmax(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_normalized_correlation_coeff(source, template)
        result = match_template(source, template, NormalizedCorrelationCoeff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)
        naive_result = naive_normalized_correlation_coeff(source, template)
        result = match_template(source, template, NormalizedCorrelationCoeff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end
end
