```@meta
CurrentModule = TemplateMatching
```

# TemplateMatching

Documentation for [TemplateMatching](https://github.com/mleseach/TemplateMatching.jl).

TemplateMatching is a Julia package designed to offer a native Julia implementation of
template matching functionalities similar to those available in OpenCV. This package aims
to provide an easy-to-use interface for image processing and computer vision applications,
allowing users to leverage the high-performance capabilities of Julia for template matching
operations. The package offers performance slightly below that of OpenCV but significantly
better than a naive implementation.

## Features

Masks are not yet supported in the current version of the package.
Unlike OpenCV, TemplateMatching.jl supports n-dimensional arrays[^1].

Below is a table summarising available methods and their equivalent in opencv.

| TemplateMatching.jl                   | Mask                | OpenCV equivalent      | 
|:--------------------------------------|:-------------------:|:-----------------------|
| [`SquareDiff`](@ref)                  | Not yet supported   | `TM_SQDIFF`            |
| [`NormalizedSquareDiff`](@ref)        | Not yet supported   | `TM_SQDIFF_NORMED`     |
| [`CrossCorrelation`](@ref)            | Not yet supported   | `TM_CCORR`             |
| [`NormalizedCrossCorrelation`](@ref)  | Not yet supported   | `TM_CCORR_NORMED`      |
| [`CorrelationCoeff`](@ref)            | Not yet supported   | `TM_CCOEFF`            |
| [`NormalizedCorrelationCoeff`](@ref)  | Not yet supported   | `TM_CCOEFF_NORMED`     |

[^1]: Up to 64 dimensions because of an implementation detail, but this shouldn't be a
problem in most cases.

## Installation

To install TemplateMatching, use the Julia package manager.
As it is not yet registered, use the full url of the repository.
Open your Julia command-line interface and run:

```julia
using Pkg
Pkg.add("https://github.com/mleseach/TemplateMatching.jl")
```

## Usage

Almost everything you need is the function [`match_template`](@ref) and its inplace counterpart
[`match_template!`](@ref).

Below is a quick start example on how to use the TemplateMatching package to perform
template matching:

```julia
using TemplateMatching
using Images

# Load your source image and template
source = rand(1000, 1000)
template = source[400:500, 100:150]

# Perform template matching using square difference
result = match_template(source, template, SquareDiff)

# Get the best match
argmin(result) # CartesianIndex(400, 100)

# Perform template matching using normalized correlation coefficient
result = match_template(source, template, NormalizedCorrCoeff)

# Get the best match
argmax(result) # CartesianIndex(400, 100)
```

