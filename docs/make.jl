using TemplateMatching
using Documenter
using DemoCards

DocMeta.setdocmeta!(TemplateMatching, :DocTestSetup, :(using TemplateMatching); recursive=true)

demopage, postprocess_cb, demo_assets = makedemos("demos") # this is the relative path to docs/

assets = []
isnothing(demo_assets) || (push!(assets, demo_assets))

format = Documenter.HTML(;assets)
makedocs(;
    modules=[TemplateMatching],
    authors="mleseach <113145496+mleseach@users.noreply.github.com>",
    repo="https://github.com/mleseach/TemplateMatching.jl/blob/{commit}{path}#{line}",
    sitename="TemplateMatching.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mleseach.github.io/TemplateMatching.jl",
        edit_link="master",
        assets=assets,
    ),
    checkdocs=:exports,
    pages=[
        "Get started" => "index.md",
        "Reference" => "reference.md",
        demopage,
    ],
)

postprocess_cb()

deploydocs(;
    repo="github.com/mleseach/TemplateMatching.jl",
    devbranch="master",
)
