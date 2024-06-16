using Statistics: mean
import Base.sum

"""
    biased_cumsum!(B, A, bias; dims)

Equivalent to `cumsum!(B, A .+ bias, dims=dims)`.
"""
function biased_cumsum!(B, A, bias; dims)
    result = accumulate!(B, A, dims = dims, init = 0) do a, b
        a + b + bias
    end

    return result
end

"""
    integral_array!(output, array, bias)

Compute the integral array.
"""
function integral_array!(
        output::AbstractArray{T, N},
        array::AbstractArray{T, N},
        bias::T
) where {T, N}
    biased_cumsum!(output, array, bias, dims = 1)
    for d in 2:N
        cumsum!(output, output, dims = d)
    end

    return output
end

"""
    IntegralArray(integral, bias)
    IntegralArray(array)
    IntegralArray(f, array)

Structure that represents an 
[integral array](https://en.wikipedia.org/wiki/Summed-area_table).
# Arguments
- `integral`: the already computed integral array.
- `bias`: the bias associated to computed integral array.
- `array`: the input array from which the integral image will be computed.
- `f`: a function to apply to each element of `array` before computing the integral.

Integral arrays allow fast summation queries over rectangular subregions using
[`sum(::IntegralArray, x, h)`](@ref).
"""
struct IntegralArray{T, A <: AbstractArray{T}}
    integral::A
    bias::T

    function IntegralArray(integral::AbstractArray{T, N}, bias::T) where {T, N}
        @assert N<64 "array with more than 64 dims are not yet supported"

        return new{T, typeof(integral)}(integral, bias)
    end

    function IntegralArray(array::AbstractArray{T}) where {T}
        bias = -mean(array)

        integral = integral_array!(similar(array), array, bias)

        return IntegralArray(integral, bias)
    end

    function IntegralArray(f, array::AbstractArray{T}) where {T}
        new_array = broadcast(f, array)
        bias = -mean(new_array)

        integral = integral_array!(new_array, new_array, bias)

        return IntegralArray(integral, bias)
    end
end

"""
    sum(integral, x, h)

Calculate the sum of values within a rectangle defined by its top-left corner
`x` and dimensions `h` in an [`IntegralArray`](@ref).

# Examples
```jldoctest
using TemplateMatching: IntegralArray

sum(IntegralArray([1. 2. 3.; 4. 5. 6.; 7. 8. 9.]), (2, 1), (2, 2))

# output
24.0
```
"""
@inline function sum(integral::IntegralArray{T}, x, h) where {T}
    d = ndims(integral.integral)

    x = Tuple(x)
    h = Tuple(h)

    result = 0

    # TODO: optimize this loop
    # - make sure the compiler can unroll the loop and infer value of most variables
    # ie: `i`, `n` and `sign` are comptime known
    # maybe write a macro

    # we can replace this by Iterators.product(ntuple(_ -> 0:1, d)...)
    # but this confuse the compiler and is much slower
    for i in 0:(2^d - 1)
        # index = x .+ h .* int_to_tuple(i) .- 1
        int_to_tuple(i, d)
        index = broadcast(muladd, h, int_to_tuple(i, d), x .- 1)

        # if we are in the border just skip
        if any(==(0), index)
            continue
        end

        # n = (sum(int_to_tuple(i)) + d) % 2
        n = (count_ones(i) + d) & 1

        sign = if n == 0
            1
        else
            -1
        end

        result += sign * integral.integral[index...]
    end

    result -= integral.bias * prod(h)
    return result
end

"""
    int_to_tuple(n, d)
Transform the `d` lower bits of `n` into a tuple

# Examples

```jldoctest
using TemplateMatching: int_to_tuple

int_to_tuple(0b0111011, 4)

# output
(1, 1, 0, 1)
```
"""
function int_to_tuple(n, d)
    return ntuple(i -> (n >> (i - 1)) & 1, d)
end
