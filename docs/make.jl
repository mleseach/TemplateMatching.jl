using TemplateMatching
using Documenter

DocMeta.setdocmeta!(TemplateMatching, :DocTestSetup, :(using TemplateMatching); recursive=true)

makedocs(;
    modules=[TemplateMatching],
    authors="mle-seach <113145496+mle-seach@users.noreply.github.com>",
    repo="https://github.com/mle-seach/TemplateMatching.jl/blob/{commit}{path}#{line}",
    sitename="TemplateMatching.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mle-seach.github.io/TemplateMatching.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mle-seach/TemplateMatching.jl",
    devbranch="master",
)
