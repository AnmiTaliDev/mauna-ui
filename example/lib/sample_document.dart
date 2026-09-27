const String sampleDocument = '''# Principles

**Text first.** Panels stay active while they are in use. When attention moves to writing, panel contrast and saturation drop, without animation.

**Flat surfaces.** Fills are flat. Lines are `0.5px` thick. No gradients. No soft shadows, except one case described in Components.

**One accent color.** The accent color goes to the caret, the active selection and one action button at a time. Everything else uses shades of gray and ochre.

**Separate typography.** The document is set in a monospace font. The interface is set in a humanist sans. The difference reads without looking at labels.

# Components

The component system is a set of drawing functions on top of its own canvas, not a widget tree.

## Toolbar

Height `40px`. Background `mauna.bg.chrome`. Bottom border `mauna.line`. Outline icons without captions. In focus mode the toolbar slides up out of the canvas over `mauna.motion.slow`.

## Sidebar

A list of document scenes and headings. It collapses to `0px`. Default width is 170 to 200px and fixed. When the window is resized, only the document canvas stretches.

## Status bar

Height `28px`. Text `12px` in `mauna.text.secondary`. Contents: word count and page number.

# Voice and tone

Buttons use the imperative: "Save". Errors state the problem and the action: "Could not open the file. Check the path." Fields give a direct instruction: "Enter a document title".
''';
