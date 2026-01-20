# Review PR - 360-Degree Code Review

Run a comprehensive code review using specialized agents in parallel.

## Pre-fetch Context

```bash
# Get the diff for review
git diff main...HEAD
```

## Instructions

You are orchestrating a 360-degree code review. Run these three specialized review agents **in parallel** using the Task tool:

1. **review-architecture** - Structural organization, domain boundaries, file placement
2. **review-implementation** - Code quality, error handling, performance, security
3. **review-integration** - API contracts, type safety, GraphQL schemas, integrations

For each agent, provide the git diff output and ask them to review the changes.

### Launching Agents

Use the Task tool to launch all three agents simultaneously:

```
Task: review-architecture agent
Prompt: Review this diff for architectural concerns: [diff]

Task: review-implementation agent
Prompt: Review this diff for implementation quality: [diff]

Task: review-integration agent
Prompt: Review this diff for integration/API concerns: [diff]
```

### Synthesize Results

After all agents complete, synthesize their findings into a unified review:

## PR Review Summary

### Architecture
[summary from review-architecture]

### Implementation
[summary from review-implementation]

### Integration
[summary from review-integration]

### Final Verdict
- **APPROVED** - Ready to merge
- **APPROVED WITH COMMENTS** - Minor suggestions, can merge
- **CHANGES REQUESTED** - Issues must be addressed

### Action Items
1. [prioritized list of changes needed]
