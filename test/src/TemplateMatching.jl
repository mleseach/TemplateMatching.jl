using Test
using TemplateMatching

using Images
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

@testset "::NormedSquareDiff" begin
    function naive_normed_square_diff(source, template)
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

        result = match_template!(dest, source, template, NormedSquareDiff())

        @test argmin(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_normed_square_diff(source, template)
        result = match_template(source, template, NormedSquareDiff())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)

        naive_result = naive_normed_square_diff(source, template)
        result = match_template(source, template, NormedSquareDiff())

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

@testset "::NormedCrossCorrelation" begin
    function naive_normed_cross_correlation(source, template)
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

        result = match_template!(dest, source, template, NormedCrossCorrelation())

        @test argmax(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end

    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_normed_cross_correlation(source, template)
        result = match_template(source, template, NormedCrossCorrelation())

        @test all(isapprox.(result, naive_result, rtol=1e-5))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)

        naive_result = naive_normed_cross_correlation(source, template)
        result = match_template(source, template, NormedCrossCorrelation())

        @test all(isapprox.(result, naive_result, rtol=1e-5))
    end
end

@testset "::CorrelationCoef" begin
    function naive_correlation_coef(source, template)
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

        result = match_template!(dest, source, template, CorrelationCoef())

        @test argmax(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_correlation_coef(source, template)
        result = match_template(source, template, CorrelationCoef())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)
        naive_result = naive_correlation_coef(source, template)
        result = match_template(source, template, CorrelationCoef())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end
end

@testset "::NormedCorrelationCoef" begin
    function naive_normed_correlation_coef(source, template)
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

        result = match_template!(dest, source, template, NormedCorrelationCoef())

        @test argmax(result) === CartesianIndex(50, 1, 30)
        @test dest === result
    end


    let
        source = rand(rng, 50, 50)
        template = rand(rng, 35, 25)

        naive_result = naive_normed_correlation_coef(source, template)
        result = match_template(source, template, NormedCorrelationCoef())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end

    let
        source = rand(rng, 20, 20, 20)
        template = rand(rng, 7, 5, 3)
        naive_result = naive_normed_correlation_coef(source, template)
        result = match_template(source, template, NormedCorrelationCoef())

        @test all(isapprox.(result, naive_result, rtol=1e-10))
    end
end
