# XML-XSLT UI Generation Pipeline for AI

A powerful, deterministic pipeline for getting AI agents to accurately generate and iterate on User Interfaces without breaking styling.

---

## The Problem

When asking an AI to design or modify a UI using raw HTML and CSS (especially with complex design systems or grid frameworks), the AI often breaks the layout. HTML and CSS are structurally flexible and visually ambiguous to an AI — it's hard for the model to perfectly "see" how its code maps to the visual output, leading to cascading layout errors during iteration.

## The Inspiration

Based on an insight from [Mark Essien's tweet](https://x.com/markessien/status/2028716745150673334?s=20):

> *"This is incredible. It looks like a simple screenshot of an app, but it's not. It's XML with XSLT, an almost deprecated technology, but this is how you can get AI to see how your pages look... I made it first generate a bunch of XML files fully describing the UI and what it sees in there. XML is deterministic — it's not like CSS or HTML... And I found out today that there is this old tech called XSLT that allows you render the XML in a browser, so you can also view it."*

## The Solution

Instead of forcing the AI to write HTML/CSS, we ask it to generate XML. XML is strict, formal, and highly deterministic. We then map those logical XML elements to our complex HTML/CSS rules using an XSLT (eXtensible Stylesheet Language Transformations) file.

## How it Works

1. **Define the structure in XML** — the AI writes logical representations of the data and structure (e.g. `<AvatarRow>`, `<Card time="9am">`).
2. **Link the XSLT Renderer** — the XML file includes an `<?xml-stylesheet?>` directive pointing to `ui-renderer.xslt`.
3. **Native Browser Transformation** — when you open the XML file in a browser, the browser's native engine applies the XSLT stylesheet and renders the intended HTML/CSS UI in real-time. No build step needed.

## Benefits

**Perfect AI iteration** — the AI can iterate strictly on the deterministic XML data structure (e.g. adding a new `<User>`) without ever touching — and risking breaking — the CSS grid or design tokens.

**Formal verification** — once the logical XML structure is perfected through iteration, you can then (if you choose) formalize the adoption into your actual frontend code (React, Vue, etc).

---

## Demo

This repository contains a simple proof-of-concept.

**Files:**

| File | Role |
|------|------|
| `ui.xml` | The strict, AI-friendly UI representation |
| `ui-renderer.xslt` | The stylesheet mapping custom XML tags into standard HTML and CSS |
| `preview.html` | A simple wrapper iframe to view the result, simulating an app view |

**How to run:**

1. Clone this repository
2. Start a local web server in the directory:
   ```
   python3 -m http.server
   ```
   > Note: Opening via `file://` directly may be blocked by browser CORS constraints when loading the external XSLT file.
3. Open `http://localhost:8000/preview.html` or `http://localhost:8000/ui.xml` in your browser

---

## Using with Claude

A Claude skill is included in the `claude-skill/` folder. It encodes the component vocabulary, design token system, and XSLT patterns for this pipeline — so you can build and iterate on the UI using plain language, and Claude will get the files right the first time.

**How it works:**

Without the skill, Claude has no idea your project uses an XML-first pipeline, what components exist, or that there's a design token system to respect. It has to guess — and it often gets things mostly right but with subtle mistakes, like hardcoding `#3b82f6` instead of `var(--color-terra)`.

The skill fixes this by front-loading Claude with exactly what it needs to know before it starts:

```
You type:  "Add a Recent Messages section"
               ↓
Claude sees: "this is an xslt-ui-pipeline task"
               ↓
Skill loads: component vocabulary, design tokens,
             current ui.xml, XSLT patterns
               ↓
Claude edits: ui.xml and/or ui-renderer.xslt
              correctly, first time
```

**Install:**

1. Download [`claude-skill/xslt-ui-pipeline.skill`](claude-skill/xslt-ui-pipeline.skill)
2. Double-click it — Claude desktop installs it automatically
3. [Claude desktop](https://claude.ai/download) with **Cowork mode** is required (currently in beta)

**Then just describe what you want:**

> *"Add a Recent Messages section — sender name, short preview, and time sent"*

> *"Change the accent color from blue to warm coral"*

> *"Add stat boxes for steps, calories, and sleep"*

Claude produces correctly structured XML and XSLT — new components use `var(--color-terra)` and the existing design tokens rather than hardcoding values, keeping the design system intact as you iterate.

See [`claude-skill/README.md`](claude-skill/README.md) for full details, component vocabulary, and instructions for adapting the skill to your own pipeline.

---

## License

MIT
