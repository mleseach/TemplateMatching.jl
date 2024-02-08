# TemplateMatching

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://mleseach.github.io/TemplateMatching.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://mleseach.github.io/TemplateMatching.jl/dev/)
[![Build Status](https://github.com/mleseach/TemplateMatching.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/mleseach/TemplateMatching.jl/actions/workflows/CI.yml?query=branch%3Amaster)

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

| TemplateMatching.jl             | Mask                | OpenCV equivalent      | 
|:--------------------------------|:-------------------:|:-----------------------|
| `SquareDiff`                      | Not yet supported   | `TM_SQDIFF`            |
| `NormalizedSquareDiff`            | Not yet supported   | `TM_SQDIFF_NORMED`     |
| `CrossCorrelation`                | Not yet supported   | `TM_CCORR`             |
| `NormalizedCrossCorrelation`      | Not yet supported   | `TM_CCORR_NORMED`      |
| `CorrelationCoeff`                | Not yet supported   | `TM_CCOEFF`            |
| `NormalizedCorrelationCoeff`      | Not yet supported   | `TM_CCOEFF_NORMED`     |

[^1]: Up to 64 dimensions because of an implementation detail, but this shouldn't be a
problem in most cases.

## Installation

To install TemplateMatching, use the Julia package manager.
Open your Julia command-line interface and run:

```julia
using Pkg
Pkg.add("TemplateMatching")
```

## Usage

Almost everything you need is the function `match_template` and its inplace counterpart
`match_template!`.

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

## Documentation

For more detailed information on all the functions and their parameters, please refer to
the full [documentation](https://mleseach.github.io/TemplateMatching.jl/stable/).

## Possible improvements
- [ ] Support for template mask (planned)
- [ ] Support for GPU
- [ ] Improve performances
- [ ] More tests and examples in documentation
- [ ] Better errors

## License

TemplateMatching is provided under the [MIT License](LICENSE). Feel free to use it in your
projects.
