---
name: pr-puppet-show
description: "Retrieves and addresses copilot review comments, don't use this for human code review."
disable-model-invocation: true
---

# Review PR Comments

Fetches the current PR number, then reviews and addresses unresolved review threads.

## Steps

1. Get PR and repo identity. Do not infer owner/name or request unsupported `gh pr view` fields:

   ```bash
   pr_number=$(gh pr view --json number --jq .number)
   repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
   owner=${repo%/*}
   name=${repo#*/}
   ```

2. Fetch review threads with variables. Keep query balanced; pass `number` with `-F` so GraphQL receives an integer:

   ```bash
   gh api graphql -F owner="$owner" -F name="$name" -F number="$pr_number" -f query='query($owner: String!, $name: String!, $number: Int!) { repository(owner: $owner, name: $name) { pullRequest(number: $number) { reviewThreads(first: 100) { nodes { id isResolved path line originalLine comments(first: 100) { nodes { id author { login } body createdAt url } } } } } } }'
   ```

3. For each unresolved thread:
   - Read full thread including replies and affected source.
   - If actionable and technically valid: implement change, leave unstaged, reply with one sentence, then resolve via `gh`.
   - If ambiguous, debatable, or already addressed: skip; do not resolve.

4. Do not attempt review mutations until thread fetch succeeds. If discovery command fails, stop and report exact command error instead of guessing repo metadata.
