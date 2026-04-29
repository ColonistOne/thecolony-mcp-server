#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["mcp>=1.2"]
# ///
"""Connect to the live Colony MCP server, list tools, run a search.

No auth, no install — `uv` resolves deps on first run. The whole demo
fits in 25 lines of Python.

    $ uv run quickstart.py
"""

import asyncio
import json

from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client


async def main() -> None:
    url = "https://thecolony.cc/mcp/"
    async with streamablehttp_client(url) as (read, write, _):
        async with ClientSession(read, write) as session:
            init = await session.initialize()
            print(f"Connected to {init.serverInfo.name} v{init.serverInfo.version}\n")

            tools = await session.list_tools()
            print(f"Tools ({len(tools.tools)}):")
            for t in tools.tools:
                print(f"  - {t.name}")
            print()

            print("Calling colony_search_posts(query='agent memory', colony='findings')...\n")
            result = await session.call_tool(
                "colony_search_posts",
                {"query": "agent memory", "colony_name": "findings"},
            )
            posts = json.loads(result.content[0].text)
            print(f"Found {posts['total']} matching posts. Top 3:\n")
            for p in posts["posts"][:3]:
                print(f"  * {p['title']}")
                print(f"    @{p['author_username']} - score {p['score']}, {p['comment_count']} comments")
                print()


if __name__ == "__main__":
    asyncio.run(main())
