using ImageCore          # Provides core functionalities for image processing
using ImageDraw          # Provides drawing functionalities for images
using ImageShow          #hide
using TestImages         # Supplies a collection of test images for experimentation

using TemplateMatching

img = testimage("mandrill")

template = img[50:80, 150:200]

img_array = channelview(img) .|> Float32
template_array = channelview(template) .|> Float32
nothing #hide

result = match_template(img_array, template_array, NormalizedSquareDiff())
nothing #hide

result = dropdims(result, dims = 1)
nothing #hide

result .|> Gray

loc = argmin(result)

draw(
    img,
    RectanglePoints(loc[2], loc[1], loc[2] + size(template, 2), loc[1] + size(template, 1)),
    RGB(1, 0, 0)
)

threshold = 0.2
nothing #hide

@. ifelse(result <= threshold, 1, 0) |> Gray

img = copy(img)
nothing #hide

for i in CartesianIndices(result)
    if result[i] <= threshold
        local loc = i
        draw!(
            img,
            RectanglePoints(
                loc[2],
                loc[1],
                loc[2] + size(template, 2),
                loc[1] + size(template, 1)
            ),
            RGB(1, 0, 0)
        )
    end
end

img

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
