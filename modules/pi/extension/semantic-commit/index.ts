import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("commit", {
    description:
      "Read the current git diff and commit with a Conventional Commits / semantic message (loads the semantic-commit skill).",
    handler: async (_args, _ctx) => {
      pi.sendUserMessage("/skill:semantic-commit");
    },
  });
}