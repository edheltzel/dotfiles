import json
import os
from pathlib import Path
import pty
import select
import subprocess
import sys
import tempfile


adapter = Path(__file__).with_name("empryo.py")
with tempfile.TemporaryDirectory() as home:
  path = Path(home) / ".empryo/hooks.json"
  path.parent.mkdir()
  existing = {"hooks": {"Stop": [{"hooks": [{"type": "command", "command": "echo existing"}]}]}, "other": True}
  path.write_text(json.dumps(existing))
  env = {**os.environ, "HOME": home}
  subprocess.run([sys.executable, adapter, "--install"], env=env, check=True)
  installed = json.loads(path.read_text())
  assert installed["other"] is True
  assert installed["hooks"]["Stop"][0] == existing["hooks"]["Stop"][0]
  first = path.read_bytes()
  subprocess.run([sys.executable, adapter, "--install"], env=env, check=True)
  assert path.read_bytes() == first, "Repeated launches must not duplicate hooks"
  path.write_text("not valid json")
  result = subprocess.run([sys.executable, adapter, "--install"], env=env, capture_output=True)
  assert result.returncode != 0
  assert path.read_text() == "not valid json", "A malformed hook file must never be overwritten"
  env.pop("REX_SESSION", None)
  env.pop("REX_BLOCK", None)
  result = subprocess.run([sys.executable, adapter, "--hook"], input="", text=True, capture_output=True, env=env, check=True)
  assert result.stdout == "", "Outside Rex, hooks must stay inert"
print("PASS: hooks preserved, installation idempotent, malformed config protected, non-Rex launches inert")


master, slave = pty.openpty()
try:
  env = {**os.environ, "REX_SESSION": "test-session", "REX_BLOCK": "test-pane", "REX_TTY": os.ttyname(slave)}
  for event, detail, expected in (
    ("SessionStart", {}, "state=idle:app=empryo"),
    ("UserPromptSubmit", {}, "state=working:app=empryo"),
    ("Notification", {"notification_type": "permission_prompt"}, "state=blocked:app=empryo:kind=permission"),
    ("Stop", {}, "state=done:app=empryo"),
    ("StopFailure", {}, "state=error:app=empryo"),
  ):
    result = subprocess.run(
      [sys.executable, adapter, "--hook"], input=json.dumps({"hook_event_name": event, **detail}),
      text=True, capture_output=True, env=env, check=True,
    )
    assert select.select([master], [], [], 1)[0], f"{event} did not reach the originating terminal"
    assert os.read(master, 4096) == f"\x1b]7501;{expected}\x1b\\".encode()
    if event == "SessionStart":
      context = json.loads(result.stdout)["hookSpecificOutput"]["additionalContext"]
      assert "test-session" in context and "test-pane" in context
finally:
  os.close(master)
  os.close(slave)
print("PASS: detached hooks report status to the originating terminal and supply Rex context")