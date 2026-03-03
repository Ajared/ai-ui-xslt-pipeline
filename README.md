# Claude Skill: XSLT UI Pipeline

This folder contains a Claude skill that lets you build and edit this site using natural language — just describe what you want and Claude handles the XML and XSLT changes correctly.

## What is a Claude skill?

A skill is a small knowledge bundle that gets loaded into Claude's context when you're working on a relevant task. This one teaches Claude about the ai-ui-xslt-pipeline architecture: the component vocabulary, the design token system, which file to edit for which kind of change, and how to extend the renderer with new components. Without it, Claude will usually produce working output but may bypass the design system (e.g. hardcoding colors instead of using `var(--color-terra)`).

## Installing the skill

You need [Claude desktop](https://claude.ai/download) with **Cowork mode** enabled (currently in beta).

1. Download `xslt-ui-pipeline.skill`
2. Double-click it — Claude installs it automatically
3. That's it

## Using the skill

Once installed, the skill triggers automatically whenever you're working on the pipeline. Just describe what you want in plain language:

> *"Add a Recent Messages section to the dashboard. Each message should show a sender name, a short preview, and the time."*

> *"Change the accent color from blue to warm coral"*

> *"Add a row of stat boxes showing steps, calories, and sleep"*

Claude will produce the correctly updated `ui.xml` and/or `ui-renderer.xslt` — with proper XML structure, new XSLT templates, and CSS that uses the existing design tokens.

## What the skill knows

**Component vocabulary** — all the XML building blocks:

| Element | What it renders |
|---------|----------------|
| `<Screen title="...">` | Root wrapper for a screen |
| `<AvatarRow>` | Horizontally scrollable user avatar row |
| `<User name="..." avatarUrl="..." notification="true/false">` | Single avatar with optional notification dot |
| `<Section title="..." action="...">` | Content section with optional action link |
| `<CardList>` | Vertical list container for cards |
| `<Card time="..." title="..." location="...">` | Individual card item |

**Design tokens** — the CSS custom properties that control the visual system:

```css
--color-terra: #3b82f6      /* accent color — borders, links, dots */
--color-bg: #ffffff
--color-ink: #6b7280        /* muted text */
--color-ink-dark: #374151   /* body text */
--color-ink-darkest: #111827 /* headings */
--font-primary: 'Inter'
--font-mono: ui-monospace   /* labels, times, uppercase tags */
```

**Which file to edit:**
- Content changes → `ui.xml` only
- Visual/style changes → `ui-renderer.xslt` only
- New component types → both files

**XSLT 1.0 patterns** for adding new components (conditionals, dynamic attributes, child iteration, conditional class names).

## How it was built

The skill was created using [Claude's skill-creator tool](https://claude.ai). It was tested against three scenarios:

1. **Adding a new component type** (Recent Messages section) — verifying it preserves the XML processing instruction, creates proper XSLT templates, and adds matching CSS
2. **Visual-only changes** (accent color swap) — verifying it touches only the XSLT and uses the single `--color-terra` variable
3. **New component with design system compliance** (Stats row) — verifying new CSS uses `var(--color-terra)` and `var(--font-mono)` rather than hardcoded values

The skill scored 100% on all assertions vs 91.7% without it, with the key difference being design token adherence in new components.

## Adapting the skill for your own pipeline

The skill is open — you can read and edit `SKILL.md` inside the `.skill` file (it's just a zip). To fork it for your own XSLT pipeline:

1. Unzip the `.skill` file
2. Update the component vocabulary table in `SKILL.md` to match your elements
3. Update the design token list
4. Update the "Current ui.xml" section with your baseline file
5. Re-zip and rename to `your-skill-name.skill`
