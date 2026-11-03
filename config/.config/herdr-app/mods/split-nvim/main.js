// From the old herdr config's [[keys.command]] type = "pane" (see keys.json).
// A key opens this mod (mod.open:split-nvim); it splits the focused pane to
// the right with Neovim, then closes itself.
import { View, div } from "gpui-kit";
import { props, run, closeOverlay } from "herdr";

export default class SplitNvim extends View {
  init() {
    run("pane.split", { direction: "right", argv: ["nvim"] });
    const overlay = props()?.overlay;
    if (overlay) closeOverlay(overlay);
  }

  render() {
    return div();
  }
}
