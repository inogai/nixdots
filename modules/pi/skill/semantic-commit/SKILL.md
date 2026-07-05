---
name: semantic-commit
description: Reads the staged (and unstaged) git diff and creates a commit using a Conventional Commits / semantic commit message. Use when the user wants to commit current changes with a meaningful, conventional commit message.
---

# Semantic Commit

Create a git commit for the current changes using a **Conventional Commits** message
derived from the actual diff.

## Workflow

1. **Gather context about the repository.**
   ```bash
   git rev-parse --show-toplevel
   git status --porcelain
   ```

2. **Inspect the changes.**
   - Prefer staged changes:
     ```bash
     git diff --cached
     ```
   - If nothing is staged, fall back to unstaged changes:
     ```bash
     git diff
     ```
   - For a high-level summary of files changed:
     ```bash
     git diff --cached --stat
     git diff --stat
     ```
   - Include untracked files if present (they may need to be added):
     ```bash
     git ls-files --others --exclude-standard
     ```

3. **Analyze the diff to determine:**
   - The **type** of change (see types below).
   - The **scope** (optional, a short noun describing the module/area).
   - A concise **description** in imperative mood.
   - Whether a **body** or **footer** is warranted (breaking changes, issue refs).

4. **Compose the commit message** following Conventional Commits:

   ```
   <type>(<scope>): <description>

   <optional body>

   <optional footer>
   ```

   Rules:
   - Header must be <= 72 characters where practical; never exceed 100.
   - Use lowercase for type and scope.
   - Description: imperative mood, no trailing period, lowercase first word
     unless it's a proper noun.
   - For breaking changes add `!` after type/scope and a `BREAKING CHANGE:` footer.
   - Reference issues in footers, e.g. `Refs: #123` or `Closes: #123`.

   **Types:**
   | Type       | Use for                                                            |
   | `feat`     | A new feature                                                     |
   | `fix`      | A bug fix                                                         |
   | `docs`     | Documentation only changes                                        |
   | `style`    | Formatting, whitespace, semicolons, etc. (no code logic change)  |
   | `refactor`| Code change that neither fixes a bug nor adds a feature           |
   | `perf`     | A code change that improves performance                           |
   | `test`     | Adding or correcting tests                                        |
   | `build`   | Changes to build system or dependencies                           |
   | `ci`       | Changes to CI configuration files and scripts                     |
   | `chore`    | Other changes that don't modify src or test files                 |
   | `revert`   | Reverting a previous commit                                       |

5. **Stage and commit.**
   - If there are untracked files that are part of the change, stage them:
     ```bash
     git add <path>
     ```
   - If nothing is staged yet, stage the relevant changes:
     ```bash
     git add -A
     ```
     Only do this when the user has not explicitly staged a subset; respect an
     existing staged set when possible.
   - Commit using a multi-line message via `-F -` (or multiple `-m` flags):
     ```bash
     git commit -F - <<'EOF'
     feat(scope): add new thing

     Body explaining why and what.
     EOF
     ```

6. **Verify the commit.**
   ```bash
   git log -1 --stat
   git status
   ```

## Guidelines

- Base the message **only** on what the diff actually changes; do not invent scope
  or features not present in the diff.
- When the diff spans multiple unrelated concerns, mention it to the user and
  prefer splitting commits. If that is not possible, summarize the primary change
  in the header and list secondary changes in the body.
- Never commit secrets, `.env` files, or large generated artifacts. Warn the user
  if such files appear in the diff.
- Ask the user for confirmation before committing if the changes are large or
  ambiguous; otherwise proceed and report the result.
- Keep the final output concise: show the commit hash, the message header, and
  the list of files changed.