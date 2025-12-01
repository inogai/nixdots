#!/usr/bin/env deno run --allow-run --allow-write

function parseWindowId(input: string): string {
  return input.split(" | ")[0];
}

function focusWindow(windowId: string) {
  const proc = new Deno.Command("bash", {
    // HACK: avoid MacOS stealing focus after the term window closes
    // Hardcoded delay is geneally an anti-pattern, but this works for now
    args: ["-c", `sleep 0.2; aerospace focus --window-id '${windowId}'`],
    stdout: "null",
    stderr: "null",
    detached: true,
  })
    .spawn();
  proc.unref();
}

function main() {
  if (Deno.args.length !== 1) {
    console.log(
      "Usage: deno run focus-window.ts '<window_id> | <app_name> | <title>'",
    );
    Deno.exit(1);
  }

  const input = Deno.args[0];
  const windowId = parseWindowId(input);

  focusWindow(windowId);
}

if (import.meta.main) {
  main();
}
