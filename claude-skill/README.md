# Claude Skill: XSLT UI Pipeline

A Claude skill that lets you build and edit the ai-ui-xslt-pipeline UI using plain language. Describe what you want — Claude figures out the correct XML structure, XSLT templates, and CSS, all within the existing design system.

---

## How it works

When you open Claude and describe a change to your UI, Claude normally has no idea that your project uses an XML-first pipeline, what components exist, or that there's a design token system it should respect. It has to guess — and it often gets things mostly right but with subtle mistakes, like hardcoding `#3b82f6` instead of `var(--color-terra)`.

A skill fixes this by front-loading Claude with exactly what it needs to know about your project before it starts working. Here's the flow:

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

The skill is a small Markdown file bundled as a `.skill` archive. It contains:

- The full list of XML components and their attributes
- The CSS custom property system (`--color-terra`, `--font-mono`, etc.)
- A copy of the current `ui.xml` as a baseline
- Rules for which file to edit depending on the type of change
- XSLT 1.0 patterns for building new component types

The skill triggers automatically whenever your message relates to the pipeline — you don't have to invoke it manually.

---

## Installing

You need [Claude desktop](https://claude.ai/download) with **Cowork mode** enabled (currently in beta).

1. Download `xslt-ui-pipeline.skill`
2. Double-click it — Claude installs it automatically
3. That's it. The skill is now active for all future sessions.

---

## Using it

Just describe what you want in plain language. Claude will open the right files and make the right changes.

**Adding content** (edits `ui.xml` only):
> *"Add a 2pm gym session to the appointments"*
> *"Add two more users to the avatar row — Marcus and Priya"*

**Changing the visual design** (edits `ui-renderer.xslt` only):
> *"Change the accent color from blue to warm coral"*
> *"Make the card borders thicker and rounder"*

**Adding a new component type** (edits both files):
> *"Add a Recent Messages section. Each message should show a sender name, a preview, and the time sent."*
> *"Add stat boxes for steps walked, calories, and sleep"*

---

## Component vocabulary

These are the XML building blocks currently supported by the renderer:

| Element | What it renders |
|---------|----------------|
| `<Screen title="...">` | Root wrapper for a screen |
| `<AvatarRow>` | Horizontally scrollable user avatar row |
| `<User name="..." avatarUrl="..." notification="true/false">` | Single avatar with optional red notification dot |
| `<Section title="..." action="...">` | Content section with optional "View all"-style action link |
| `<CardList>` | Vertical list container |
| `<Card time="..." title="..." location="...">` | Individual card item |

New components can be added by extending both `ui.xml` and `ui-renderer.xslt` — the skill knows how to do this correctly.

---

## Design tokens

All visual styling flows through CSS custom properties defined in `ui-renderer.xslt`. The skill ensures new components always use these rather than hardcoding values:

```css
--color-terra: #3b82f6      /* accent — card borders, avatar rings, links */
--color-bg: #ffffff
--color-ink: #6b7280        /* muted text */
--color-ink-dark: #374151   /* body text */
--color-ink-darkest: #111827 /* headings */
--font-primary: 'Inter'
--font-mono: ui-monospace   /* labels, timestamps, uppercase tags */
```

Keeping new components anchored to these tokens means a single color change in `:root` updates everything at once.

---

## Adapting for your own XSLT pipeline

The `.skill` file is just a zip. To fork it for a different project:

1. Rename `xslt-ui-pipeline.skill` → `xslt-ui-pipeline.zip` and unzip it
2. Edit `SKILL.md`:
   - Update the component vocabulary table
   - Update the design token list
   - Replace the "Current ui.xml" section with your own baseline
3. Zip the folder back up and rename to `your-project.skill`
4. Double-click to install

---

## How it was built

Created using Claude's skill-creator, tested against three scenarios: adding a new component type, a visual-only color change, and a stats row requiring design system compliance. The skill scored 100% on all assertions vs 91.7% without it — the main difference was design token adherence in new components (the no-skill run hardcoded hex values in a gradient instead of using `var(--color-terra)`).
