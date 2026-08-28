# duti — default app / file associations

## Purpose

Sets default applications for file types and URL schemes via `duti`. Not a stow package; invoked by `install.sh`.

## Ownership

- `duti.sh` — applies the associations
- One settings file per app bundle id (e.g. `dev.zed.Zed`, `com.apple.Preview`, `cc.ffitch.shottr`)

## Local Contracts

- Run `duti.sh` to apply associations.
- Add an association by creating a file named for the target app's bundle id.

## Work Guidance

(none)

## Verification

`duti -x <ext>` confirms the handler after applying.

## Child DOX Index

No children.
