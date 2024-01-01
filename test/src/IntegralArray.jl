using Test
using TemplateMatching: IntegralArray, int_to_tuple, sum
using Random

@testset "IntegralArray" begin
    @testset "int_to_tuple" begin
        test_table() = [
            # (n, d, expected result)
            (0b010101010, 1, (0,)),
            (0b010101010, 4, (0, 1, 0, 1)),
            (0b010101010, 3, (0, 1, 0)),
            (0b001010101, 4, (1, 0, 1, 0)),
            (0b000001111, 4, (1, 1, 1, 1)),
            (0b000101000, 4, (0, 0, 0, 1)),
            (0xf0f0f0f0f, 20, (1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1)),
        ]

        for (n, d, expected) in test_table()
            @test int_to_tuple(n, d) == expected
        end
    end

    @testset "sum" begin
        # test that naive_sum give the same result as sum for
        # various size and indices
        naive_sum(array, x, h) = sum(array[x:x+h-oneunit(h)])
        naive_sum(f, array, x, h) = sum(f, array[x:x+h-oneunit(h)], init=0)

        rng = Xoshiro(0)

        test_table() = [
            # (size, x, h)
            (10, 1, 10),
            (10, 4, 3),
            (10, 1, 3),
            (10, 7, 4),
            (10, 7, 0),
            ((10, 5), (1, 1), (10, 5)),
            ((10, 5), (5, 1), (5, 5)),
            ((10, 5), (1, 2), (2, 2)),
            ((10, 5), (1, 2), (2, 3)),
            ((10, 5), (8, 2), (2, 3)),
            ((10, 5), (8, 2), (2, 3)),
            ((10, 5), (8, 2), (2, 0)),
            ((10, 5), (8, 2), (0, 2)),
            ((10, 5), (8, 2), (0, 0)),
            ((7, 7, 7), (1, 1, 1), (7, 7, 7)),
            ((7, 7, 7), (3, 2, 5), (0, 3, 1)),
            ((7, 7, 7), (3, 2, 5), (1, 1, 1)),
            ((7, 7, 7), (3, 1, 5), (2, 0, 2)),
            ((7, 7, 7), (2, 1, 2), (5, 6, 5)),
            ((7, 7, 7), (2, 1, 2), (1, 6, 1)),
            ((7, 7, 7, 7), (1, 1, 1, 1), (7, 7, 7, 7)),
            ((7, 7, 7, 7), (1, 1, 1, 1), (7, 0, 7, 7)),
            ((7, 7, 7, 7), (1, 1, 1, 1), (7, 0, 0, 7)),
            ((7, 7, 7, 7), (1, 1, 1, 1), (0, 0, 0, 0)),
            ((7, 7, 7, 7), (1, 1, 1, 1), (0, 7, 7, 7)),
        ]

        for (size, x, h) in test_table()
            x = CartesianIndex(x)
            h = CartesianIndex(h)

            array = rand(rng, size...)
            integral = IntegralArray(array)

            @test isapprox(sum(integral, x, h), naive_sum(array, x, h), rtol=1e-5)
        end

        for f in [exp, sqrt, log, (x -> 2x)]
            for (size, x, h) in test_table()
                x = CartesianIndex(x)
                h = CartesianIndex(h)
    
                array = rand(rng, size...)
                integral = IntegralArray(f, array)
    
                @test isapprox(sum(integral, x, h), naive_sum(f, array, x, h), rtol=1e-5)
            end
        end
    end
end
