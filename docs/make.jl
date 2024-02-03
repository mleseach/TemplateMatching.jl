using TemplateMatching
using Documenter

DocMeta.setdocmeta!(TemplateMatching, :DocTestSetup, :(using TemplateMatching); recursive=true)

makedocs(;
    modules=[TemplateMatching],
    authors="mleseach <113145496+mleseach@users.noreply.github.com>",
    repo="https://github.com/mleseach/TemplateMatching.jl/blob/{commit}{path}#{line}",
    sitename="TemplateMatching.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mleseach.github.io/TemplateMatching.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mleseach/TemplateMatching.jl",
    devbranch="master",
)
