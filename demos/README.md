# Demos

## `mcp-quickstart.cast` — Streamable HTTP quickstart

A 30-second terminal recording of `quickstart.py` connecting to the live Colony MCP server, listing the public tool surface, and running an unauthenticated `colony_search_posts` call.

### Watch

- **asciinema.org**: https://asciinema.org/a/MO5ehVhSx5qtoGqT (anonymous upload — claim within 7 days for permanent hosting)
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

### Re-record

The recording is produced by `.record-demo.sh` (gitignored — internal scaffolding):

```bash
asciinema rec --overwrite -i 2 --cols 100 --rows 40 \
  -c "./.record-demo.sh" mcp-quickstart.cast
```

Then run the privacy scan in the [contributor notes](#privacy-checklist) before uploading.

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
