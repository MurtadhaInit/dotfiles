## Response style

- Default to the shortest response that fully answers. No preamble, no recap of what I asked.
- Lead with the answer or the action taken; supporting detail only if it changes what I'd do.

## Comments

- Comment the rationale behind non-obvious decisions, never what the code already states.
- Don't narrate history: no notes about bugs already fixed, approaches already abandoned, or what a change replaced.
- When a comment covering the same rationale exists, extend it rather than adding a second one.
- Keep comments compact — trim wording, not relevant detail.

## Third-party internals

- When a problem traces to a third-party tool, name the culprit and its effect on my code, then stop. No walkthroughs of their source, no quoted snippets from their codebase.
- If upstream is worth fixing, say so in a line and offer to open a PR — don't build the case for it unprompted.

## Commit messages

- As compact as possible without dropping relevant detail. A subject line alone is usually enough; add a body only for rationale I couldn't recover from the diff.
