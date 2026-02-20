# Mole shell completion
if status is-interactive; and command -q mole
    set -l output (mole completion fish 2>/dev/null)
    and echo "$output" | source
end
