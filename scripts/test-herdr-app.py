import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent


class HerdrLinksTest(unittest.TestCase):
  def test_fresh_existing_relocated_and_repeated_install(self):
    with tempfile.TemporaryDirectory() as temporary:
      base = Path(temporary)
      repo = base / "clone with spaces"
      home = base / "home"
      source = repo / "config/.config/herdr-app"
      shutil.copytree(ROOT / "config/.config/herdr-app", source)
      (repo / "scripts").mkdir()
      shutil.copy2(ROOT / "scripts/link-herdr-app.sh", repo / "scripts/link-herdr-app.sh")
      shutil.copy2(ROOT / "config/.stow-local-ignore", repo / "config/.stow-local-ignore")
      target = home / ".config/herdr-app"
      target.mkdir(parents=True)
      (target / "keys.json").write_text('{"existing": true}\n')
      (target / "state.json").write_text("app-owned")
      (source / "mods/popup-but/gpui-kit.d.ts").write_text("generated")
      env = {**os.environ, "HOME": str(home), "XDG_CONFIG_HOME": str(home / ".config"), "XDG_STATE_HOME": str(home / ".local/state")}
      for iteration in range(2):
        subprocess.run(["bash", str(repo / "scripts/link-herdr-app.sh")], env=env, check=True)
        subprocess.run(["stow", "--restow", "--dir", str(repo), "--target", str(home), "config"], env=env, check=True)
        links = list(target.rglob("*"))
        links = [path for path in links if path.is_symlink()]
        self.assertEqual(len(links), 16 + len(list(source.glob("themes/*.json"))))
        for path in links:
          self.assertTrue(path.is_file(), str(path))
          self.assertEqual(path.resolve(), (source / path.relative_to(target)).resolve())
        self.assertFalse(target.is_symlink())
        self.assertFalse((target / "mods/popup-but").is_symlink())
        self.assertFalse((target / "mods/popup-but/gpui-kit.d.ts").exists())
        self.assertEqual((target / "state.json").read_text(), "app-owned")
      backups = list((home / ".local/state/dotfiles/herdr-app").rglob("keys.json"))
      self.assertEqual(len(backups), 1)
      self.assertEqual(backups[0].read_text(), '{"existing": true}\n')
      (target / "state.json").unlink()
      self.assertFalse((source / "state.json").exists())


  def test_first_install_and_folded_directory_guard(self):
    with tempfile.TemporaryDirectory() as temporary:
      home = Path(temporary)
      env = {**os.environ, "HOME": str(home), "XDG_CONFIG_HOME": str(home / ".config"), "XDG_STATE_HOME": str(home / ".local/state")}
      subprocess.run(["bash", str(ROOT / "scripts/link-herdr-app.sh")], env=env, check=True)
      target = home / ".config/herdr-app"
      self.assertTrue((target / "themes/eldritch-dusk.json").is_file())
      self.assertFalse((home / ".local/state/dotfiles/herdr-app").exists())
      folded = home / "folded"
      folded.mkdir()
      (folded / "herdr-app").symlink_to(ROOT / "config/.config/herdr-app", target_is_directory=True)
      env["XDG_CONFIG_HOME"] = str(folded)
      result = subprocess.run(["bash", str(ROOT / "scripts/link-herdr-app.sh")], env=env, capture_output=True, text=True)
      self.assertNotEqual(result.returncode, 0)
      self.assertIn("must be a real directory", result.stderr)

  def test_switcher_updates_theme_and_appearance_without_running_other_apps(self):
    with tempfile.TemporaryDirectory() as temporary:
      home = Path(temporary)
      source = home / "config/herdr-app"
      source.mkdir(parents=True)
      shutil.copytree(ROOT / "config/.config/herdr-app/themes", source / "themes")
      settings = source / "settings.json"
      settings.write_text('{"theme":"proxysoul","appearance":"dark","font":"keep-me"}')
      definitions = (ROOT / "config/.config/theme-switcher/theme-switcher.sh").read_text().split("# Parse arguments", 1)[0]
      commands = '''
CONFIG="$HOME/config"
CALLS="$HOME/calls"
is_installed() { return 0; }
herdr-app() { printf '%s\\n' "$*" >> "$CALLS"; }
update_herdr_app "$TEST_THEME"
'''
      env = {**os.environ, "HOME": str(home), "XDG_CONFIG_HOME": str(home / "config")}
      import json
      for theme, appearance in [("eldritch-dusk", "light"), ("eldritch", "dark"), ("proxysoul", "dark")]:
        env["TEST_THEME"] = theme
        subprocess.run(["bash", "-c", definitions + commands], env=env, check=True)
        actual = json.loads(settings.read_text())
        self.assertEqual(actual["theme"], theme)
        self.assertEqual(actual["appearance"], appearance)
        self.assertEqual(actual["font"], "keep-me")
        self.assertIn("do app.theme --name " + theme, (home / "calls").read_text())
      previous = settings.read_bytes()
      env["TEST_THEME"] = "tokyonight"
      subprocess.run(["bash", "-c", definitions + commands], env=env, check=True)
      self.assertEqual(settings.read_bytes(), previous)


if __name__ == "__main__":
  unittest.main()
