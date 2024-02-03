using ImageFiltering: imfilter!, Inner
using OffsetArrays: OffsetArray

function cross_correlation!(dest, source, template)
	@assert ndims(source) == ndims(template) "source and template should have same number of dims"
	
	dest_size = Tuple(size(source) .- size(template) .+ 1)
	@assert dest_size == size(dest) "size(dest) should be $(dest_size), $(size(dest)) given"
			
	return imfilter!(
		dest,
		source,
		OffsetArray(template, ntuple(_ -> -1, ndims(source))),
		Inner(),
	)
end

function normalized_cross_correlation!(dest, source, template)
    @assert ndims(source) == ndims(template) "source and template should have same number of dims"
    
    dest_size = Tuple(size(source) .- size(template) .+ 1)
    @assert dest_size == size(dest) "size(dest) should be $(dest_size), $(size(dest)) given"
    
    source_square_integral = IntegralArray(x -> x^2, source)
    template_square_sum = sum(v -> v^2, template)

    dest = cross_correlation!(dest, source, template)
    
    h = CartesianIndex(size(template))
    for i in CartesianIndices(dest)
        source_square_sum = sum(source_square_integral, i, h)

		dest[i] /= sqrt(source_square_sum * template_square_sum)
    end

    return dest
end
