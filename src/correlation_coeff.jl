"""
Implementation of the CorrelationCoeff method
"""
function correlation_coeff!(dest, source, template)
	@assert ndims(source) == ndims(template) "source and template should have same number of dims"
	
	dest_size = Tuple(size(source) .- size(template) .+ 1)
	@assert dest_size == size(dest) "size(dest) should be $(dest_size), $(size(dest)) given"
			
	source_integral = IntegralArray(source)
	template_sum = sum(template)

	# we use dest as temporary storage for cross_correlation
	cross_correlation = cross_correlation!(dest, source, template)
	
    n = length(template)
	h = CartesianIndex(size(template))
	for i in CartesianIndices(dest)
		source_sum = sum(source_integral, i, h)

		dest[i] = cross_correlation[i] - template_sum * source_sum / n
	end

	return dest
end

"""
Implementation of the NormalizedCorrelationCoeff method
"""
function normalized_correlation_coeff!(dest, source, template)
	@assert ndims(source) == ndims(template) "source and template should have same number of dims"
	
	dest_size = Tuple(size(source) .- size(template) .+ 1)
	@assert dest_size == size(dest) "size(dest) should be $(dest_size), $(size(dest)) given"
			
	source_integral = IntegralArray(source)
	source_square_integral = IntegralArray(x -> x^2, source)
	template_sum = sum(template)
	template_square_sum = sum(x -> x^2, template)

	# we use dest as temporary storage for cross_correlation
	cross_correlation = cross_correlation!(dest, source, template)
	
    n = length(template)
	h = CartesianIndex(size(template))
	for i in CartesianIndices(dest)
		source_sum = sum(source_integral, i, h)
        source_square_sum = sum(source_square_integral, i, h)

		dest[i] = cross_correlation[i] - template_sum * source_sum / n
        dest[i] /= sqrt((template_square_sum - template_sum^2 / n) *
            (source_square_sum - source_sum^2 / n))
	end

	return dest
end
