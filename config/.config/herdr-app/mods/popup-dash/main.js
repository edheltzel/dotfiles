// From the old herdr config's [[keys.command]] type = "popup" (see keys.json).
// A key opens this mod (mod.open:popup-dash). It starts CMD in a hidden core
// terminal in the focused pane's folder and machine, through the login shell
// so PATH matches, shows that terminal in a 90% dialog that closes when the
// program exits, then closes itself. Mods can't import from each other, so
// every popup-* folder carries this same file with its own CMD.
import { View, div } from "gpui-kit";
import { props, focused, spaces, hc, openOverlay, closeOverlay, notify } from "herdr";

const CMD = "gh dash"; // null: the machine's own login shell

export default class Popup extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      try {
        await open();
      } catch (err) {
        notify({ title: `Couldn't open ${CMD ?? "a shell"}`, body: String(err?.message ?? err), level: "error" });
      } finally {
        const overlay = props()?.overlay;
        if (overlay) closeOverlay(overlay);
      }
    });
  }

  render() {
    return div();
  }
}

async function open() {
  const f = focused();
  const machine = spaces().find((s) => s.id === f?.space)?.machine ?? null;
  const args = ["run", "--bg", "--json", "--rm", "--no-parent"];
  if (machine) args.push("--on", machine);
  if (f?.cwd) args.push("--cwd", f.cwd);
  if (CMD) args.push("--", "/bin/sh", "-c", 'exec "${SHELL:-/bin/sh}" -lic "$1"', "sh", CMD);
  const r = await hc(args);
  if (r.code !== 0) throw new Error(r.stderr.trim() || `hc run exited ${r.code}`);
  const { address } = JSON.parse(r.stdout);
  // Close this launcher popup first: closing it after the dialog opens hands the keyboard back to the pane underneath.
  const launcher = props()?.overlay;
  if (launcher) closeOverlay(launcher);
  openOverlay({ kind: "dialog", modal: true, width: 0.9, height: 0.9, layout: { type: "block", content: { terminal: address } } });
}
