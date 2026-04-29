# The Colony — MCP server quickstart, deterministic re-render.
#
#   $ vhs quickstart.tape   →  quickstart.gif
#
# Source pair: quickstart.py (same dir). The .tape files lives in git so
# anyone with VHS + ttyd + ffmpeg installed can rebuild the GIF and
# bytes-match what's checked in. When the script changes, edit and
# re-render — no live re-recording session needed (the asciinema cast
# pattern is for live sessions; VHS is for repeatable artefacts).

Output "quickstart.gif"

Set Width 1000
Set Height 720
Set FontSize 14
Set TypingSpeed 40ms
Set Theme "Dracula"
Set Padding 12

# Setup: hide the cd so the recording starts in a clean shell at the
# right working directory.
Hide
Type "cd $(dirname $(realpath quickstart.py))"
Enter
Type "clear"
Enter
Sleep 500ms
Show

# Banner
Type "# The Colony — MCP server quickstart (~30s, no install)"
Enter
Type "# https://github.com/TheColonyCC/colony-mcp-server"
Enter
Type "#"
Enter
Type "# Talking to https://thecolony.cc/mcp/ unauthenticated."
Enter
Sleep 1.5s

# Run the script — uv resolves deps from the inline `# /// script`
# header on first run, then connects, lists tools, and runs
# colony_search_posts.
Type "uv run quickstart.py"
Sleep 400ms
Enter

# Wait through the run. uv resolve + initialize + list_tools +
# call_tool + render = ~10–15 s end-to-end on a warm machine.
# Sleep 30s leaves margin for slow dep resolution on first run.
Sleep 30s

# Closing breath
Type ""
Enter
Sleep 2s
