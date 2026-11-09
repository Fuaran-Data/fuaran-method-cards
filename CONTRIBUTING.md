# Contributing

Thanks for your interest. The surface is still moving, and the fastest way to have a change land
is to open an issue describing the problem before writing code.

## Ground rules

- **The text is normative; the schemas and the corpus are its checkable form.** A change to what a
  card is changes `METHOD_CARD.md`, the schema under `schemas/v1/` and the corpus under
  `card-fixtures/` in one commit, and a test holds that the three agree.
- **A card binds by citation.** It never restates a kernel's exactness, a routine's definition hash
  or a result's method field; it names them.
- **No new dependencies without a decision.** `FSharp.Core` and `Fable.Core` today; see
  DECISIONS.md D2 for what may be added and why.
- **Fable-clean.** The prompt fragment and the validator run in a browser host; the gate compiles
  the library under Fable on every pass.
- **No private names.** Nothing in this repository, or in a commit message, names a consumer, a
  client or a product other than this one. The gate's boundary sweep refuses them.

## Before you open a pull request

```
pwsh ./run.ps1
```

That runs the whole gate: `dotnet tool restore`, Fantomas over `src` and `tests`, the build, the
Expecto suite, the Fable leg and the publication-boundary sweep. All must be clean.

- **Fantomas is not optional.** Run it inside the repo so it picks up `.editorconfig`.
- **Changing the corpus** means changing the card, regenerating its artefacts through the library and
  committing both with the change that needed them.
- **New behaviour needs a test that can fail.** Where practical, confirm the test goes red against
  the unfixed code before relying on it going green.

## Licence

By contributing you agree that your contributions are licensed under Apache-2.0, matching the
project's [LICENSE](LICENSE).
