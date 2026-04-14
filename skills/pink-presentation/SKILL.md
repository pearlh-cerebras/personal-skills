---
name: pink-presentation
description: Generates a self-contained HTML slide deck on any topic, styled in Claude's clean aesthetic with a pink color palette.
---

# Pink Presentation Generator

When the user invokes this skill, ask for a topic if one wasn't provided. Then generate a complete, self-contained HTML file that works as a slide deck.

## What to produce

A single `.html` file saved to the current working directory (e.g. `presentation.html`) containing a polished slide deck on the requested topic.

## Slide structure

Plan the content first, then write the HTML. A good deck has:

- **Title slide** — topic name, a one-line subtitle, and a byline
- **3–7 content slides** — each with a clear heading and tight, scannable content (bullet points, a key stat, a short quote, or a simple diagram built from HTML/CSS)
- **Closing slide** — key takeaway or call to action

Use your judgment about how many slides fit the topic. Quality over quantity.

## Design spec — pink Claude aesthetic

The visual style is Claude's clean, editorial look translated into a warm pink palette.

**Typography**
- Font stack: `'Inter', system-ui, -apple-system, sans-serif` (load Inter from Google Fonts)
- Headings: `font-weight: 600`, tight letter-spacing (`-0.02em`)
- Body: `font-weight: 400`, `line-height: 1.6`
- No decorative fonts

**Color palette**
```
--bg:           #fff0f5   /* warm blush white — slide background */
--surface:      #fce4ec   /* slightly deeper pink — cards, code blocks */
--accent:       #e91e8c   /* vivid pink — headings, highlights, progress bar */
--accent-light: #f48fb1   /* soft pink — secondary accents, borders */
--text:         #2d1b25   /* deep plum-black — primary text */
--text-muted:   #7b4f62   /* muted mauve — captions, secondary text */
--white:        #ffffff
```

**Layout**
- Slides are `100vw × 100vh`, one visible at a time
- Content is centered and constrained to ~`max-width: 820px`
- Generous padding: `60px` horizontal, `48px` vertical on content slides
- Title slide: vertically and horizontally centered, more padding
- Slide number shown bottom-right in `--text-muted`

**Decorative touches (Claude-ish)**
- A thin `3px` top border on each slide in `--accent`
- Subtle drop shadow on the content container: `box-shadow: 0 2px 24px rgba(233,30,140,0.07)`
- Bullet points replaced with a `▸` character in `--accent`
- Code/key terms in a pill: `background: --surface`, `border-radius: 6px`, `padding: 2px 8px`
- No stock gradients, no heavy drop shadows, no clip-art icons

## Navigation

- Arrow keys (← →) and click to advance/retreat
- A thin progress bar at the very bottom of the viewport tracks position
- Keyboard hint shown on the title slide, fades after first keypress

## HTML template structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Topic] — Presentation</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* CSS custom properties, reset, slide system, typography, components */
  </style>
</head>
<body>
  <!-- One <section class="slide"> per slide -->
  <!-- Title slide gets class="slide slide--title" -->
  <div class="progress-bar" id="progress"></div>
  <script>
    /* Slide navigation logic, progress bar updates, keyboard hint fade */
  </script>
</body>
</html>
```

## JavaScript requirements

- Track `currentSlide` index (0-based)
- Show only the active slide (`display: flex` / `display: none`)
- Update progress bar width as a percentage
- Bind `keydown` for ArrowLeft / ArrowRight
- Bind `click` on slide to advance (but not on links)
- Do not use any external JS libraries

## Writing the content

- Write tight, specific, useful content — not filler
- Match the depth to the topic: technical topics get precise language, conceptual topics get crisp analogies
- Vary slide formats: not every slide should be a bullet list
- Lead each bullet with the key insight, not a prelude

## Output

1. Write the complete HTML file to disk using the Write tool
2. Tell the user the filename and how to open it (`open presentation.html` on Mac)
3. Briefly describe how many slides you made and the structure
