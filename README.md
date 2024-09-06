# Inspector A11y

This is a proof of concept to export Accessibility Overviews from Xcode.
Why? The European Accessiblity Act 2025 requires us to make Apps accessible.
I wanted a tool to export on a view basis what I'm missing.

| Input    | Output  |
| -------- | ------- |
| ![Input](/Documents/input.png)  | ![Output](/Documents/output.jpg)    |

The idea is that you pass in a view, and it generates another view showing the accessible data for the view.


## Ramblings below


How do I want to use it?

```
This would mean that we'd have to go through all files and append the extra modifiers at runtime.

#Preview {
  TestView()
    .inspectorA11y(generate: true, [.accessibilityIdentifiers, .tabOrder], rendering: [.transparent], folder: "", fileNamePrefix: "testview")
}

I guess this would only work when the user previewed, default parameters could be used. - maybe thats a good thing?
```

or

```
swift run InspectorA11y

Takes a snapshot
Finds all elements like `Text()` `Image()` `.accessibilityIdentifiers`.
adds an additional modifier after it.
It then takes those views
runs them through the generator
saves the images to disk
revert changes

what should it return?

- A list of images?
```

or

```
Is this ran as part of tests?
```


## Accessibility Renderables
- dark mode light mode
- rotation
- larger font sizes
- color invert mode
- button shapes
- device type
- device sizes
- tab order


## Rendering options
- transparency
- watermark as configration


## Technical
- how do we inject render/configurations



- how do i set the full image size?
- save as image mode
-- file location
-- file naming
- realtime mode? - render as a preview with custom size?
- tile results mode?
- CI generation and asset upload
- do i return errors on the image?
- do I make a swift run command?
