# Share one ssh-agent across all interactive shells.
# Agent env is persisted to ~/.ssh/agent/env.fish so future shells
# (including herdr panes spawned after a Ghostty restart) reuse it
# instead of spawning fresh agents.

if status is-interactive
    set -l env_file ~/.ssh/agent/env.fish

    # Inherit a persisted agent if this shell didn't already get one.
    if test -z "$SSH_AUTH_SOCK"; and test -r $env_file
        source $env_file
    end

    # ssh-add -l exit codes: 0 = keys listed, 1 = agent reachable but empty,
    # 2 = agent unreachable. Only 2 means we need a fresh agent.
    ssh-add -l >/dev/null 2>&1
    if test $status -eq 2
        eval (ssh-agent -c) >/dev/null
        mkdir -p (dirname $env_file)
        printf 'set -gx SSH_AUTH_SOCK %s\nset -gx SSH_AGENT_PID %s\n' \
            $SSH_AUTH_SOCK $SSH_AGENT_PID >$env_file
    end

    # Load the auth key once (no-op if already loaded).
    set -l fp (ssh-keygen -lf ~/.ssh/id_ed25519.pub 2>/dev/null | awk '{print $2}')
    if not ssh-add -l 2>/dev/null | string match -q "*$fp*"
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
    end
end
