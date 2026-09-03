# Who made this, and how carefully

*A [Rigor, Vouch, Stages](https://rigor.diaconou.com/) disclosure stamp. The format and vocabulary are specified at [rigor.diaconou.com/spec](https://rigor.diaconou.com/spec/), version 1.0.*

<!-- rigor:summary -->
**The idea was mine. Before LLMs, the plan was mine; the implementation was
written by me; it was reviewed for quality by me. Since LLMs, the plan and the
implementation have been reworked by me with an AI, and it has been reviewed for
quality and for security, and tested, all by an AI. The project is still
evolving. I have run and skimmed this code, but I have not read it properly. No
human has understood it line by line. This assessment is as of 2026-09-03. I am
specifically not recommending you depend on this. Why: it is incomplete, and I
am not sure I will ever finish it. Statement made by: Stephen Ierodiaconou.**
<!-- /rigor:summary -->

## Notes

decor began in 2018, inside a private project, alongside what became the
Vident gem. Vident was then a view component library of its own; decor was the
set of UI components built on it. The setup later moved onto GitHub's
view_component gem, and Vident was extracted and open-sourced as a Stimulus DSL
over view_component, later supporting Phlex too. All of that was before AI, and
the architecture and the original components are mine, written by hand.

After AI, decor was finally extracted into an open-source project of its own,
and then dramatically refactored alongside Vident, with an AI: new features,
updated DSLs, fixes, and proper tests. The visual design changed too: the
original components had their own CSS, and the current ones are an AI-led
design on Tailwind and daisyUI. Vident had a solid testing story from the
pre-AI days; decor never applied it well, so the tests it has now are the AI
era's work. The public history begins there; the stamp records both eras.

I have skimmed the refactored code rather than read it line by line, so
`comprehended` is `no` and the level is `skimmed`. Quality was reviewed by me
before LLMs and by an AI since; security review and testing are the AI's work.

decor is incomplete, and I am not sure I will ever finish it, so the vouch is
withheld. I use it in production myself and can work around its gaps. It is
still being worked on: `activity: active`, `scope: evolving`.

## Stamp

```yaml
spec: "1.0"
signed: "Stephen Ierodiaconou"
rigor: skimmed
vouch: {claim: withheld, why: "it is incomplete, and I am not sure I will ever finish it"}
checks:
  comprehended: no
  quality_reviewed: [human, ai]
  security_reviewed: ai
  tested: ai
stages:
  idea: {by: human}
  plan: {by: [human, human-with-ai]}
  implementation: {by: [human, human-with-ai]}
  maintenance: {by: human-with-ai, activity: active, scope: evolving}
assessed: 2026-09-03
```

<!--
checks: surface any subset; a done value names who did it.
  comprehended / quality_reviewed / security_reviewed / tested / owned:
    yes | human | ai | human-with-ai | no | not-applicable,
    or a pair [before LLMs, since LLMs] of actors.
  engineered and owned must surface the checks they imply; comprehended
  cannot be satisfied by an AI alone.
Run `rigor-md fmt RIGOR.md` after editing the stamp to refresh the summary.
-->