# Bedrock 26.52 investigation

Status: runtime compatibility unverified. No supported-version claims or native
dependency constraints have been changed.

## Verified on 2026-10-27

- Installed Windows package: Microsoft.MinecraftUWP 1.26.5203.0, x64.
- Upstream LaminaSort v0.1.0 builds against LeviLamina Client 26.51.3;
  its package dependency allows LeviLamina Client 26.51.*.
- The current LeviLamina client version database maps 1.26.51.01 to
  26.51.0 through 26.51.9. It contains no mapping for 1.26.52.03.
- LeviLamina 26.51.9 requires bedrock-runtime-data 26.51.1-client.12.
- Existing SortPlannerTest and SortKeyTest suites compiled with MSVC
  14.51.36231 and passed. Run `tests\run-standalone.cmd` to reproduce without
  downloading the game SDK. These tests validate synthetic sorting logic,
  not Minecraft ABI compatibility or real container transactions.

## Runtime test blockers

An isolated game-directory copy was attempted outside the Store installation.
Windows denied reading Minecraft.Windows.exe. The same copy failed after the
Minecraft process had exited, ruling out the running game as a sufficient
explanation. Other game files copied, but this is not a runnable clone.

An alternate isolated installation through LeviLauncher was investigated.
Automatic approval review rejected the download-and-launch command with
"blocked by policy". A separate download succeeded; the launcher was not run.
No existing worlds or installed game files were modified.

## Required next validation

1. Obtain a runnable, licensed 26.52 isolated installation with separate saves.
2. Verify loader startup and native symbol resolution against the actual 26.52
   executable. Inspect native class layouts and hooks before allowing sorting;
   changing package version strings alone is not a compatibility fix.
3. Test a disposable world: partial-stack consolidation, single/double chests,
   barrels, shulkers, named/enchanted/damaged items, excluded special slots,
   cursor-held items, text-field input, repeated sorts, and close/reopen.
4. Verify item counts and metadata survive saving/reloading and inspect logs
   for rejected transactions or crashes. Test remote-server behavior separately.

## Upstream references

- https://github.com/amatouhake/LaminaSort
- https://github.com/LiteLDev/LeviLamina/blob/main/tooth.json
- https://github.com/LiteLDev/levilamina-client-version-db/blob/main/v2/version-db.json
- https://github.com/LiteLDev/LeviLauncher
