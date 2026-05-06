# yeshivish-spinner

Adds 25 Yeshivish words to the Claude Code spinner animation.

Instead of "Thinking…" or "Crunching…", you might see "Davening…", "Shteiging…", or "Farbrengening…"

## Verbs

| Verb | Meaning |
|------|---------|
| Bentshing | Saying grace after meals |
| Chapping | Grasping / understanding |
| Chazering | Reviewing / going over material |
| Davening | Praying |
| Farbrengening | Celebrating at a farbrengen gathering |
| Farbissening | Being bitter / grumpy |
| Farginning | Not begrudging / being generous of spirit |
| Farkoching | Getting worked up / agitated |
| Farshimmeling | Getting moldy / confused |
| Farshlepping | Dragging along |
| Fressing | Eating heartily |
| Hocking | Bothering / talking incessantly |
| Kibitzing | Joking around / making wisecracks |
| Kvetching | Complaining |
| Laining | Reading the Torah portion |
| Lerning | Studying Torah |
| Nudging | Nudging / pestering |
| Paskening | Ruling on a halachic question |
| Schmoozing | Chatting / socializing |
| Shpritzing | Sprinkling / making jokes |
| Shteiging | Learning Torah intensely / growing spiritually |
| Shtelling | Raising a question (shtell a kasha) |
| Shuckling | Swaying during prayer |
| Toiveling | Ritually immersing in the mikveh |
| Tzuchapping | Grabbing / snatching |

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/ElimelekhPerl/yeshivish-spinner/refs/heads/master/install.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/ElimelekhPerl/yeshivish-spinner.git
cd yeshivish-spinner
bash install.sh
```

### Windows

```powershell
irm https://raw.githubusercontent.com/ElimelekhPerl/yeshivish-spinner/refs/heads/master/install.ps1 | iex
```

### Manual

Merge the contents of `spinner-verbs.json` into your `~/.claude/settings.json`:

```json
{
  "spinnerVerbs": {
    "mode": "append",
    "verbs": ["Davening", "Shteiging", "..."]
  }
}
```

Restart Claude Code after installing.

## Known issue

As of Claude Code v2.1.132, there is [an open bug](https://github.com/anthropics/claude-code/issues/23347) where `spinnerVerbs` in user-level settings (`~/.claude/settings.json`) may be silently ignored. If you don't see the new verbs after restarting, try adding the setting to your project-level `.claude/settings.json` instead.

## Customization

Set `"mode": "replace"` in `spinner-verbs.json` to use only Yeshivish verbs (no defaults). Set `"mode": "append"` (default) to add them alongside the built-in list.

## Contributing

PRs welcome. New verbs should be:
- Authentic Yeshivish / Yiddish-English blend
- A gerund (ending in -ing)
- Brief enough to read in a spinner
- Not mean-spirited or offensive

## License

MIT
