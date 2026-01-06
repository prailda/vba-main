# DeepWiki Configuration

This directory contains configuration files for [DeepWiki](https://deepwiki.com) - an AI-powered documentation generation system that creates comprehensive Wiki content for repositories.

## Overview

DeepWiki uses a blueprint-based approach to generate Wiki documentation:

1. **Blueprint Definition** (`wiki.json`): Defines the Wiki structure and page hierarchy
2. **Generation Prompt** (`DeepWiki Prompt.md`): Instructions for the AI to generate content
3. **Content Source**: Repository files are indexed and synthesized into Wiki pages

## Files

### wiki.json

The `wiki.json` file serves as the blueprint for Wiki generation. It defines:

```json
{
  "repo_notes": [
    {
      "content": "General context about the repository that applies to all Wiki pages"
    }
  ],
  "pages": [
    {
      "title": "Page Title",
      "purpose": "Description of what this page should cover",
      "parent": "Parent Page Title (optional)",
      "page_notes": [
        {
          "content": "Specific guidance for generating this page's content"
        }
      ]
    }
  ]
}
```

#### Structure Fields

| Field | Description | Required |
|-------|-------------|----------|
| `repo_notes` | Array of notes providing global context for the Wiki | Yes |
| `pages` | Array of Wiki page definitions | Yes |
| `title` | Page title (used as heading and navigation) | Yes |
| `purpose` | Description of the page's content and scope | Yes |
| `parent` | Title of the parent page (creates hierarchy) | No |
| `page_notes` | Array of specific guidance for content generation | No |

### DeepWiki Prompt.md

Contains instructions for the AI system (Devin) that generates Wiki content. The prompt covers:

- Repository indexing methodology
- How to use `wiki.json` as a blueprint
- Content generation guidelines
- Output format specifications
- Citation and diagram instructions

## Wiki Structure

The current Wiki structure follows a hierarchical layout:

```
SE Agent Engineering Guide (Root)
├── Prompt Design Fundamentals
│   ├── Persona and Role Definition
│   ├── Constraint and Rule Systems
│   └── Output Format Specifications
├── Architecture and Design Agents
│   ├── System Architecture Prompts
│   └── API and Data Flow Design
├── Planning and Task Decomposition
│   ├── Epic and Feature Breakdown
│   └── Implementation Planning
├── Code Implementation Agents
│   ├── Language-Specific Prompts
│   └── Test-Driven Development Agents
├── Analysis and Quality Assurance
│   ├── Code Review Agents
│   └── Debugging and Error Analysis
├── Documentation and Knowledge Transfer
│   └── Code Explanation Techniques
├── AI Agent Tool Ecosystem
│   ├── IDE Integrations
│   └── Standalone AI Agents
├── Research and Reasoning Agents
│   └── Advanced Reasoning Techniques
└── Safety and Responsible AI
```

## How Wiki Generation Works

1. **DeepWiki** reads the `wiki.json` blueprint
2. **Devin AI** indexes the repository content (`prompt-library/` files)
3. For each page in `wiki.json`:
   - AI finds relevant files based on `purpose` and `page_notes`
   - Content is synthesized from repository files
   - Output follows the format specified in `DeepWiki Prompt.md`
4. Pages are linked according to the `parent` relationships
5. Generated Wiki is hosted on DeepWiki platform

## Customizing the Wiki

### Adding a New Page

Add an entry to the `pages` array in `wiki.json`:

```json
{
  "title": "New Topic",
  "purpose": "Explain the new topic and what it covers",
  "parent": "Parent Section Name",
  "page_notes": [
    {
      "content": "Reference specific-file.md and related-file.md"
    }
  ]
}
```

### Modifying Page Content

1. Update the `purpose` field to change scope
2. Add specific guidance in `page_notes` to influence content
3. Reference new repository files that should be included

### Changing Hierarchy

Modify the `parent` field to reorganize pages:
- Set `parent` to another page's `title` to make it a child
- Remove `parent` to make it a top-level section
- Create new intermediate pages for deeper nesting

## Best Practices

1. **Be Specific in Purpose**: Clear purpose descriptions lead to better content
2. **Reference Files**: Use `page_notes` to point to specific repository files
3. **Maintain Hierarchy**: Keep the structure logical and navigable
4. **Update Regularly**: Sync `wiki.json` with repository changes
5. **Test Changes**: Regenerate Wiki after significant updates

## Related Files

- `README.md` - Main repository documentation
- `overview.md` - Repository overview

## Notes

- DeepWiki generates content on its platform; no local generation tools are needed
- The `wiki.json` file is read-only by DeepWiki; edits here control generation
- Content is synthesized from repository files, not invented by the AI
