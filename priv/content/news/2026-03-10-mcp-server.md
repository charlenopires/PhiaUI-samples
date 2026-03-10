---
title: "PhiaUI MCP Server — AI-Powered LiveView Development"
slug: mcp-server
date: 2026-03-10
summary: "The PhiaUI MCP Server gives AI coding assistants deep knowledge of PhiaUI components, enabling smarter code generation and real-time documentation lookup."
tags: ai,tooling,mcp
icon: sparkles
---

## PhiaUI MCP Server for AI Assistants

Modern development increasingly involves AI coding assistants. The **PhiaUI MCP Server** bridges the gap between AI tools and the PhiaUI component library, enabling smarter, more accurate code generation.

### What is MCP?

The Model Context Protocol (MCP) is an open standard that lets AI assistants access specialized tools and data sources. Think of it as giving your AI assistant a direct line to PhiaUI's documentation and component API.

### What the PhiaUI MCP Server Provides

**Component Discovery**
- Browse all 623 components with descriptions
- Search by category, feature, or use case
- Get component props, slots, and examples

**Code Generation**
- Generate HEEx templates with correct component usage
- Auto-import the right modules in your `_web.ex`
- Respect your project's theme and dark mode setup

**Documentation Lookup**
- Real-time access to component docs
- Usage examples with common patterns
- Migration guides between versions

**Validation**
- Check if your component usage matches the API
- Suggest missing required props
- Warn about deprecated patterns

### Setup

Add the MCP server to your AI assistant's configuration:

```json
{
  "mcpServers": {
    "phiaui": {
      "command": "mix",
      "args": ["phia.mcp"],
      "cwd": "/path/to/your/project"
    }
  }
}
```

### Example Interaction

Ask your AI assistant:

> "Create a dashboard card grid showing revenue, users, and orders using PhiaUI components"

With the MCP server active, the AI knows to use `StatCard`, `MetricGrid`, proper icon names from Lucide, and the correct import paths — no hallucinated APIs.

### Supported AI Assistants

The MCP server works with any MCP-compatible client:

- **Claude Code** (CLI)
- **Claude Desktop**
- **VS Code** with MCP extensions
- **Cursor**

### Open Source

The PhiaUI MCP Server is open source and ships as part of the `phia_ui` Hex package. Enable it with a single mix task and start building faster with AI.
