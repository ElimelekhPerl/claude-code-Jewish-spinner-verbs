# claude-code-Jewish-spinner-verbs

Adds Jewish-flavored spinner verbs to Claude Code. Instead of "Thinking…" or "Crunching…", you might see "Davening…", "Twirling tzitzis…", or "Yalla-ing…"

Two packages available: **Yeshivish** (beis medrash slang) and **Israeli** (Israeli/Hebrew slang in English). Install one or both.

---

## Packages

### Yeshivish

| Verb | Meaning |
|------|---------|
| Bentshing | Saying grace after meals |
| Chapping | Grasping / understanding |
| Chapping the inyan | Getting the point |
| Chazering | Reviewing material |
| Checking Artscroll | Looking up the translation |
| Checking the eiruv | Verifying the weekly eiruv status |
| Curling peyos | Twirling the sidelocks |
| Davening | Praying |
| Farbrengening | Celebrating at a farbrengen gathering |
| Farbissening | Being bitter / grumpy |
| Farginning | Not begrudging / being generous of spirit |
| Farkoching | Getting worked up / agitated |
| Farshimmeling | Getting moldy / confused |
| Farshlepping | Dragging along |
| Fressing | Eating heartily |
| Fressing on kugel | Self-explanatory |
| Getting the pshat | Understanding the plain meaning |
| Hocking | Bothering / talking incessantly |
| Kibitzing | Joking around |
| Kvetching | Complaining |
| Laining | Reading the Torah portion |
| Learning a blatt | Studying a page of Talmud |
| Lerning | Studying Torah |
| Losing the place | Classic shul experience |
| Making a kiddush | Sanctifying Shabbos over wine |
| Making a l'chaim | Toasting |
| Making a siyum | Completing a tractate |
| Nudging | Pestering |
| Paskening | Ruling on a halachic question |
| Running to minyan | Racing to make the prayer quorum |
| Saying a vort | Sharing a Torah thought |
| Schmoozing | Chatting |
| Schmoozing in shul | During davening, naturally |
| Shlepping a sefer | Carrying a religious book |
| Shpritzing | Making jokes |
| Shteiging | Learning Torah intensely / growing spiritually |
| Shtelling | Raising a question (shtell a kasha) |
| Shuckling | Swaying during prayer |
| Singing zemiros | Shabbos table songs |
| Stroking the beard | Thinking deeply |
| Toiveling | Ritually immersing in the mikveh |
| Twirling tzitzis | Absentmindedly spinning the fringes |
| Tzuchapping | Grabbing / snatching |

### Israeli

| Verb | Meaning |
|------|---------|
| Arguing politics | A national pastime |
| Balagan-ing | Creating chaos |
| Calling ima | Checking in with mom |
| Davka-ing | Doing something specifically / despite |
| Doing miluim | Serving in the reserves |
| Dugri-ing | Being blunt / direct |
| Eating at the shuk | Grabbing food at the market |
| Eating falafel | Essential |
| Eating shawarma | Also essential |
| Finding parking in Tel Aviv | Mythical |
| Frier-ing | Being a sucker |
| Making aliyah | Moving to Israel |
| Making hummus | A serious endeavor |
| Missing the egged bus | By seconds, always |
| Paying arnona | Municipal tax season |
| Protektzia-ing | Using connections to get things done |
| Sababa-ing | Everything is cool / great |
| Speaking Hebrish | Hebrew-English mix |
| Tachles-ing | Getting to the point |
| Waiting for the sherut | Shared taxi, departure TBD |
| Walla-ing | Expressing genuine surprise |
| Yalla-ing | Let's go / hurry up |

---

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/ElimelekhPerl/claude-code-Jewish-spinner-verbs/refs/heads/main/install.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/ElimelekhPerl/claude-code-Jewish-spinner-verbs.git
cd claude-code-Jewish-spinner-verbs
bash install.sh
```

The installer will ask:
1. **Package** — Yeshivish / Israeli / Both
2. **Mode** — Append (add to built-ins) or Replace (only your verbs)
3. **Existing settings** — Merge, Overwrite, or Cancel

### Windows

```powershell
irm https://raw.githubusercontent.com/ElimelekhPerl/claude-code-Jewish-spinner-verbs/refs/heads/main/install.ps1 | iex
```

### Manual

Copy the relevant package(s) from `packages/` and add to `~/.claude/settings.json`:

```json
{
  "spinnerVerbs": {
    "mode": "append",
    "verbs": ["Davening", "Shteiging", "Yalla-ing", "..."]
  }
}
```

Restart Claude Code after installing.

---

## Known issue

There is [an open bug](https://github.com/anthropics/claude-code/issues/23347) where `spinnerVerbs` in user-level settings (`~/.claude/settings.json`) may be silently ignored. If you don't see new verbs after restarting, try adding the `spinnerVerbs` block to your project-level `.claude/settings.json` instead.

---

## Contributing

PRs welcome. New verbs should be:
- Authentic Yeshivish/Yiddish-English or Israeli slang
- A gerund form (ending in -ing, or a short phrase)
- Brief enough to read in a spinner
- Not mean-spirited or offensive

## License

MIT
