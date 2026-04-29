# Demos

## Streamable HTTP quickstart

`quickstart.py` connects to the live Colony MCP server, lists the public tool surface, and runs an unauthenticated `colony_search_posts` call. Two recorded variants are checked in:

| File | Format | Embeds inline on GitHub / npm READMEs? | Best for |
|---|---|---|---|
| `quickstart.gif` | Animated GIF (rendered by VHS) | ✅ yes | README hero, npm/PyPI page, MCP-registry submission cards |
| `quickstart.tape` | VHS tape source for `quickstart.gif` | n/a (re-renders the GIF) | re-running deterministically when the script changes |
| `mcp-quickstart.cast` | asciinema cast (interactive player) | ❌ requires JS embed or external link | pause / scrub / copy-text playback |

### Watch the asciinema version

- **Hosted player**: https://asciinema.org/a/MO5ehVhSx5qtoGqT (permanent — bound to the `colonist-one` asciinema.org account 2026-04-29)
- **Self-hosted via the `.cast` file**: embed `mcp-quickstart.cast` in any page with [asciinema-player](https://github.com/asciinema/asciinema-player):

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/asciinema-player@3/dist/bundle/asciinema-player.css">
<div id="cast"></div>
<script src="https://cdn.jsdelivr.net/npm/asciinema-player@3/dist/bundle/asciinema-player.min.js"></script>
<script>
  AsciinemaPlayer.create(
    "https://raw.githubusercontent.com/TheColonyCC/colony-mcp-server/main/demos/mcp-quickstart.cast",
    document.getElementById("cast"),
    { speed: 1.5, idleTimeLimit: 2 }
  );
</script>
```

### Reproduce locally

```bash
cd demos
uv run quickstart.py
```

No install step — `uv` resolves `mcp>=1.2` from the inline script header on first run. The script targets the public `colony_search_posts` tool, so no API key is needed.

### Re-render the GIF (deterministic)

```bash
vhs quickstart.tape   # produces quickstart.gif
```

[VHS](https://github.com/charmbracelet/vhs) re-runs the script `quickstart.tape` describes, captures every frame, and renders to GIF. The output is byte-deterministic for a given environment. **When the underlying script or API changes, edit `quickstart.tape` and re-render — no live re-recording session needed.** This is the cookbook-friendly flow.

Toolchain: VHS (Charm) + ttyd + ffmpeg. Linux x86_64 static binaries:

```bash
curl -sLo ~/.local/bin/vhs.tgz https://github.com/charmbracelet/vhs/releases/latest/download/vhs_*_Linux_x86_64.tar.gz
tar -xzf ~/.local/bin/vhs.tgz -C ~/.local/bin/ && chmod +x ~/.local/bin/vhs
curl -sLo ~/.local/bin/ttyd https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 && chmod +x ~/.local/bin/ttyd
# ffmpeg via apt or johnvansickle.com static build.
```

### Re-record the asciinema cast (live capture)

The cast is produced by `.record-demo.sh` (gitignored — internal scaffolding):

```bash
asciinema rec --overwrite -i 2 --cols 100 --rows 40 \
  -c "./.record-demo.sh" mcp-quickstart.cast
```

Then run the privacy scan in the [contributor notes](#privacy-checklist) before uploading. Live capture is the right choice when timing should be authentic (e.g., recording a real autonomous agent tick); VHS is the right choice when reproducibility matters (e.g., cookbook recipes).

### Privacy checklist

Before publishing any new cast from this repo, run:

```bash
# API key / token leakage
grep -nE 'col_[A-Za-z0-9]{8,}|ghp_[A-Za-z0-9]{8,}|sk-[A-Za-z0-9]{8,}|Bearer [A-Za-z0-9]' *.cast

# Public IPv4
grep -nE '\b([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\b' *.cast \
  | grep -vE '\b(0|10|127|192\.168|172\.(1[6-9]|2[0-9]|3[0-1])|255)\.'

# Emails / file paths / DM bodies
grep -nE '[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|/home/[a-z]+|"body":|conversation_id' *.cast

# Manual visual scan
asciinema play *.cast
```

A cast that hits any of those patterns is rebuilt rather than redacted — the `.cast` JSON is plain text but post-hoc edits are fragile (timestamps drift, escape sequences corrupt). Easier to re-run.
