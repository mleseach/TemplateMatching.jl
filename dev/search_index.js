var documenterSearchIndex = {"docs":
[{"location":"reference/#Functions","page":"Reference","title":"Functions","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"match_template\nmatch_template!","category":"page"},{"location":"reference/#TemplateMatching.match_template","page":"Reference","title":"TemplateMatching.match_template","text":"match_template(source, template, alg::Algorithm)\n\nPerforms template matching between the source image and template using a specified algorithm.\n\nCompare a template to a source image using the algorithm specified by the alg parameter. It is designed to work with arrays of more than two dimensions, making it suitable for multidimensional arrays or sets of images. The function slides the template over the source array in all possible positions, computing a similarity metric at each position.\n\nArguments\n\nsource: Source array to search within. \ntemplate: Template array to search for.\nalg::Algorithm: Algorithm to use for calculating the similarity metric.\n\nThe dimensions of the source array should be greater than or equal to the dimensions of the template array. If the source is of size (S_1, S_2, ...) and template is (T_1, T_2, ...), then the size of the resultant match array will be (S_1-T_1+1, S_2-T_2+1, ...), representing the similarity metric for each possible position of the template over the source.\n\nThe algorithm for matching is chosen by passing an instance of one of the following structs as the alg parameter: SquareDiff, NormalizedSquareDiff, CrossCorrelation, NormalizedCrossCorrelation, CorrelationCoeff, or NormalizedCorrelationCoeff.\n\nReturns\n\nReturn an array of the same number of dimensions as the input arrays, containing the calculated similarity metric at each position of the template over the source image.\n\nExamples\n\nsource = rand(100, 100)\ntemplate = rand(10, 10)\nresult = match_template(source, template, CrossCorrelation())\n\nsource = rand(100, 100)\ntemplate = source[10:15, 20:30]\nresult = match_template(source, template, SquareDiff())\nargmin(result)\n\n# output\nCartesianIndex(10, 20)\n\nsource = rand(100, 100)\ntemplate = source[10:15, 20:30]\nresult = match_template(source, template, CorrelationCoeff())\nargmax(result)\n\n# output\nCartesianIndex(10, 20)\n\nSee also match_template! for a version of this function that writes the result into a preallocated array.\n\n\n\n\n\n","category":"function"},{"location":"reference/#TemplateMatching.match_template!","page":"Reference","title":"TemplateMatching.match_template!","text":"match_template!(dest, source, template, alg::Algorithm)\n\nPerforms template matching and writes the results into a preallocated destination array.\n\nInplace counterpart to match_template, designed to perform the template matching operation and store the results in a preallocated array dest passed by the user. This reduces memory allocations and can be more efficient when performing multiple template matching operations. It compares a template to a source image using the specified algorithm, suitable for multidimensional arrays or sets of images.\n\nSee match_template for further documentation.\n\nArguments\n\ndest: Preallocated destination array where the result will be stored.\nsource: Source array to search within.\ntemplate: Template array to search for.\nalg::Algorithm: Algorithm for calculating the similarity.\n\nReturns\n\nReturn its first argument dest containing the calculated similarity metric at each position of the template over the source image.\n\nThe dimensions of the source array should be greater than or equal to the dimensions of the template array. If the source is of size (S_1, S_2, ...) and template is (T_1, T_2, ...), then dest must be preallocated with dimensions (S_1-T_1+1, S_2-T_2+1, ...), representing the similarity metric for each possible position of the template over the source.\n\nThe algorithm for matching is chosen by passing an instance of one of the following structs as the alg parameter: SquareDiff, NormalizedSquareDiff, CrossCorrelation, NormalizedCrossCorrelation, CorrelationCoeff, or NormalizedCorrelationCoeff.\n\nExamples\n\nsource = rand(100, 100)\ntemplate = rand(10, 10)\ndest = Array{Float64}(undef, 91, 91)\nmatch_template!(dest, source, template, CrossCorrelation())\n\ndest = Array{Float64}(undef, 100, 100)\nmatch_template!(dest, source, template, CrossCorrelation()) # will fail\n\nSee also match_template for an immutable version of this function.\n\n\n\n\n\n","category":"function"},{"location":"reference/#Available-algorithms","page":"Reference","title":"Available algorithms","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"SquareDiff\nNormalizedSquareDiff\nCrossCorrelation\nNormalizedCrossCorrelation\nCorrelationCoeff\nNormalizedCorrelationCoeff","category":"page"},{"location":"reference/#TemplateMatching.SquareDiff","page":"Reference","title":"TemplateMatching.SquareDiff","text":"Algorithm that calculate the squared difference between the source and the template.\n\nThis method is used to find how much each part of the source array differs from the template by squaring the difference between corresponding values. It is straightforward and works well when the brightness of the images does not vary much. Lower values indicate a better match.\n\nFormula\n\nR_i = sum_j (S_i+j - T_j)^2\n\nSee also NormalizedSquareDiff\n\n\n\n\n\n","category":"type"},{"location":"reference/#TemplateMatching.NormalizedSquareDiff","page":"Reference","title":"TemplateMatching.NormalizedSquareDiff","text":"Normalized algorithm for computing the squared difference between the source and the template.\n\nThis method extends the SquareDiff algorithm by normalizing the squared differences. It is more robust against variations in brightness and contrast between the source and template images. Lower values indicate a better match.\n\nFormula\n\nR_i = fracsum_j (S_i+j - T_j)^2sqrtsum_j S_i+j^2 cdot sum_j T_j^2\n\nSee also SquareDiff\n\n\n\n\n\n","category":"type"},{"location":"reference/#TemplateMatching.CrossCorrelation","page":"Reference","title":"TemplateMatching.CrossCorrelation","text":"Algorithm that calculates the cross-correlation between the source and the template.\n\nThis method computes the similarity between the source and template by multiplying their corresponding elements and summing up the results. This approach inherently favors the brighter regions of the source image over the darker ones since the product of higher intensity values will naturally be greater. Higher values indicate a better match.\n\nFormula\n\nR_i = sum_j (S_i+j cdot T_j)\n\nSee also NormalizedCrossCorrelation\n\n\n\n\n\n","category":"type"},{"location":"reference/#TemplateMatching.NormalizedCrossCorrelation","page":"Reference","title":"TemplateMatching.NormalizedCrossCorrelation","text":"Normalized algorithm for computing the cross-correlation between the source and the template.\n\nThis method improves upon the CrossCorrelation by normalizing the results. It calculates the similarity by multiplying corresponding elements, summing up those products, and then dividing by the product of their norms. This reduces the bias toward brighter areas, providing a more balanced measurement of similarity. Higher values indicate a better match.\n\nFormula\n\nR_i = fracsum_j (S_i+j cdot T_j)sqrtsum_j S_i+j^2 cdot sum_j T_j^2\n\nSee also CrossCorrelation\n\n\n\n\n\n","category":"type"},{"location":"reference/#TemplateMatching.CorrelationCoeff","page":"Reference","title":"TemplateMatching.CorrelationCoeff","text":"Algorithm that measures the correlation coefficient between the source and the template.\n\nThis method quantifies the degree to which the source and template match by computing their correlation coefficient. It offers a balance between capturing the structural similarity and adjusting for brightness variations, making it less biased towards the brighter parts in comparison to simple cross-correlation methods. A higher value indicates a better match.\n\nFormula\n\nR_i = frac     sum_j ((S_i+j - barS_i) cdot (T_j - barT))      sqrtsum_j (S_i+j - barS_i)^2 cdot sum_j (T_j - barT)^2 \n\nWhere barS_i is the mean of the source values within the region considered for matching and barT is the mean of the template values.\n\nSee also NormalizedCorrelationCoeff\n\n\n\n\n\n","category":"type"},{"location":"reference/#TemplateMatching.NormalizedCorrelationCoeff","page":"Reference","title":"TemplateMatching.NormalizedCorrelationCoeff","text":"Normalized algorithm for computing the correlation coefficient between the source and the template.\n\nThis method extends the CorrelationCoeff by applying additional normalization steps, aiming to further minimize the influence of the absolute brightness levels and enhance the robustness of matching. It calculates the normalized correlation coefficient, providing a standardized measure. A higher value indicates a better match.\n\nFormula\n\nR_i = frac     sum_j ((S_i+j - barS_i) cdot (T_j - barT))      sqrtsum_j (S_i+j - barS_i)^2 cdot sqrtsum_j (T_j - barT)^2 \n\nWhere barS_i is the mean of the source values within the region considered for matching and barT is the mean of the template values.\n\nSee also CorrelationCoeff\n\n\n\n\n\n","category":"type"},{"location":"","page":"Get started","title":"Get started","text":"CurrentModule = TemplateMatching","category":"page"},{"location":"#TemplateMatching","page":"Get started","title":"TemplateMatching","text":"","category":"section"},{"location":"","page":"Get started","title":"Get started","text":"Documentation for TemplateMatching.","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"TemplateMatching is a Julia package designed to offer a native Julia implementation of template matching functionalities similar to those available in OpenCV. This package aims to provide an easy-to-use interface for image processing and computer vision applications, allowing users to leverage the high-performance capabilities of Julia for template matching operations. The package offers performance slightly below that of OpenCV but significantly better than a naive implementation.","category":"page"},{"location":"#Features","page":"Get started","title":"Features","text":"","category":"section"},{"location":"","page":"Get started","title":"Get started","text":"Masks are not yet supported in the current version of the package. Unlike OpenCV, TemplateMatching.jl supports n-dimensional arrays[1].","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"Below is a table summarising available methods and their equivalent in opencv.","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"TemplateMatching.jl Mask OpenCV equivalent\nSquareDiff Not yet supported TM_SQDIFF\nNormalizedSquareDiff Not yet supported TM_SQDIFF_NORMED\nCrossCorrelation Not yet supported TM_CCORR\nNormalizedCrossCorrelation Not yet supported TM_CCORR_NORMED\nCorrelationCoeff Not yet supported TM_CCOEFF\nNormalizedCorrelationCoeff Not yet supported TM_CCOEFF_NORMED","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"[1]: Up to 64 dimensions because of an implementation detail, but this shouldn't be a","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"problem in most cases.","category":"page"},{"location":"#Installation","page":"Get started","title":"Installation","text":"","category":"section"},{"location":"","page":"Get started","title":"Get started","text":"To install TemplateMatching, use the Julia package manager. Open your Julia command-line interface and run:","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"using Pkg\nPkg.add(\"TemplateMatching\")","category":"page"},{"location":"#Usage","page":"Get started","title":"Usage","text":"","category":"section"},{"location":"","page":"Get started","title":"Get started","text":"Almost everything you need is the function match_template and its inplace counterpart match_template!.","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"Below is a quick start example on how to use the TemplateMatching package to perform template matching:","category":"page"},{"location":"","page":"Get started","title":"Get started","text":"using TemplateMatching\nusing Images\n\n# Load your source image and template\nsource = rand(1000, 1000)\ntemplate = source[400:500, 100:150]\n\n# Perform template matching using square difference\nresult = match_template(source, template, SquareDiff)\n\n# Get the best match\nargmin(result) # CartesianIndex(400, 100)\n\n# Perform template matching using normalized correlation coefficient\nresult = match_template(source, template, NormalizedCorrCoeff)\n\n# Get the best match\nargmax(result) # CartesianIndex(400, 100)","category":"page"}]
}
