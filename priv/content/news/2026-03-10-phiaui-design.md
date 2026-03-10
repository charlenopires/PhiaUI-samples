---
title: "Introducing PhiaUIDesign — Visual Editor for LiveView"
slug: phiaui-design
date: 2026-03-10
summary: "PhiaUIDesign is a visual design tool that lets you build Phoenix LiveView interfaces by dragging and dropping PhiaUI components — then exports clean HEEx code."
tags: tooling,design
icon: pencil
---

## PhiaUIDesign: Design LiveView UIs Visually

Building beautiful interfaces with PhiaUI has always been code-first. Now, with **PhiaUIDesign**, you can design visually and export production-ready HEEx templates.

### What is PhiaUIDesign?

PhiaUIDesign is a visual editor inspired by modern design tools. It understands PhiaUI's component library natively — every component, every variant, every prop.

Key capabilities:

- **Drag & drop** any of the 623 PhiaUI components onto a canvas
- **Live preview** with real dark mode, themes, and responsive breakpoints
- **Property panel** to configure component props without writing code
- **Export to HEEx** — generates clean, idiomatic Phoenix LiveView templates
- **Theme sync** — uses your project's `phia-themes.css` for accurate colors

### Design Workflow

1. **Start from a template** or blank canvas
2. **Add components** from the categorized sidebar
3. **Arrange and configure** using the visual editor
4. **Preview** at different breakpoints (mobile, tablet, desktop)
5. **Export** as a `.heex` file ready to drop into your Phoenix app

### Component Intelligence

PhiaUIDesign knows about component relationships. When you add a `Card`, it suggests `CardHeader`, `CardContent`, and `CardFooter` as children. When you create a form, it auto-generates proper `InputGroup` wrappers with labels and validation slots.

### Responsive by Default

Every layout you create starts mobile-first. The editor shows all three breakpoints simultaneously, and exported code includes proper Tailwind responsive classes (`sm:`, `md:`, `lg:`).

### Coming Soon

PhiaUIDesign is currently in private beta. Features on the roadmap:

- **Figma import** — convert Figma frames to PhiaUI components
- **AI assist** — describe a layout in natural language, get a starting point
- **Collaboration** — real-time multiplayer editing
- **Version history** — track changes and revert

Stay tuned for the public beta announcement.
