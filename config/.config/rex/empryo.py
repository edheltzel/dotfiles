import json
import os
from pathlib import Path
import sys
import tempfile


HOOK_COMMAND = 'python3 "${XDG_CONFIG_HOME:-$HOME/.config}/rex/empryo.py" --hook'
STATES = {
  "SessionStart": "idle",
  "UserPromptSubmit": "working",
  "PreToolUse": "working",
  "Notification": "blocked",
  "Stop": "done",
  "StopFailure": "error",
  "SessionEnd": "clear",
}


def install_hooks():
  path = Path.home() / ".empryo/hooks.json"
  config = json.loads(path.read_text()) if path.exists() else {}
  hooks = config.setdefault("hooks", {})
  changed = False
  for event in STATES:
    rules = hooks.setdefault(event, [])
    if not any(hook.get("command") == HOOK_COMMAND for rule in rules for hook in rule.get("hooks", [])):
      rules.append({"hooks": [{"type": "command", "command": HOOK_COMMAND, "timeout": 5}]})
      changed = True
  if changed:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as output:
      json.dump(config, output, indent=2)
      output.write("\n")
    os.replace(output.name, path)


def on_hook():
  session, block = os.environ.get("REX_SESSION"), os.environ.get("REX_BLOCK")
  if not session or not block:
    return
  payload = json.load(sys.stdin)
  event = payload.get("hook_event_name")
  state = STATES.get(event)
  if state is None:
    return
  report = f"state={state}:app=empryo"
  if event == "Notification":
    kind = "permission" if payload.get("notification_type") == "permission_prompt" else "question"
    report += f":kind={kind}"
  try:
    with open(os.environ.get("REX_TTY", "/dev/tty"), "w") as tty:
      tty.write(f"\x1b]7501;{report}\x1b\\")
  except OSError as error:
    print(f"Rex status unavailable: {error}", file=sys.stderr)
  if event == "SessionStart":
    context = (
      f"You are running in Rex session {session}, terminal pane {block}. "
      "Use these IDs for requests about this session or pane. "
      "Run `rex __internal skill` and follow its guide when controlling Rex."
    )
    print(json.dumps({"hookSpecificOutput": {"hookEventName": event, "additionalContext": context}}))


def main():
  if sys.argv[1:] == ["--hook"]:
    on_hook()
    return
  install_hooks()
  if sys.argv[1:] == ["--install"]:
    return
  os.environ["EMPRYO_HOOK_ENV"] = (os.environ.get("EMPRYO_HOOK_ENV", "") + " REX_* XDG_CONFIG_HOME").strip()
  # ponytail: detached engines keep their launch pane; per-client hooks would allow rebinding.
  if sys.stdout.isatty():
    os.environ["REX_TTY"] = os.ttyname(sys.stdout.fileno())
  os.execvp("empryo", ["empryo", "--skill", "rex", *sys.argv[1:]])


if __name__ == "__main__":
  main()
