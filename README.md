# Fuaran.MethodCards

The method card specification, and a library that turns a card into the four things an assistant
needs to call the method it describes.

A **method card** is a versioned, hashed, machine-readable description of one analytical method, in
eight parts: **identity** (the id, version and definition hash of the routine or kernel it binds to,
the owning package, its exactness and determinism class), **meaning** (what question the method
answers, in a paragraph a non-statistician can read, and its assumptions), **applicability** (the
preconditions on the data, when it does not apply, the alternatives, and whether the choice is
mechanical or a judgement), **signature** (typed inputs as a JSON schema, the data contract as
roles, the typed refusals), **outputs** (every result table and column with its meaning, the
diagnostics with their healthy ranges), **interpretation** (reading rules and templates: what may
be said and what must not be claimed), **presentation** (the default blocks and the base card) and
**examples** (worked input → output pairs). A card is shipped by the package that implements the
method; from it this library generates the method's **tool definition**, its **prompt fragment**,
its **call validator** and its **result envelope**. No card, no tool.

F# 10 / .NET 10. `FSharp.Core` at runtime, with `Fable.Core` so the prompt fragment and the validator
compile for a browser host. Apache-2.0.

## Status

Cut 2026-11-09 as a baseline: the gate, the tool pins, the schema manifest and the corpus directory
are in place; the normative text (`METHOD_CARD.md`), the schemas under `schemas/v1/`, the library's
card type, codec, hash and four generators, and the corpus under `card-fixtures/` follow. Nothing is
published until they are in and a `v*` tag is pushed ([STABILITY.md](STABILITY.md)).

## Layout

```
METHOD_CARD.md                  the normative text (to come)
schemas/v1/                     one JSON schema per family, named by manifest.json
card-fixtures/                  the corpus: one directory per card with its generated artefacts
src/Fuaran.MethodCards/         the library
tests/Fuaran.MethodCards.Tests/ the Expecto suite: schema validation, corpus byte-equality
gates/                          the publication-boundary sweep and its hashed term list
```

## The gate

```
pwsh ./run.ps1
```

Tool restore, Fantomas, the build, the Expecto suite, the Fable leg (the library compiled for a
browser host), then the publication-boundary sweep over every tracked file and every commit message.
`verify.ps1` is a pass-through to the full pass. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Binding by citation

A card binds to the thing it describes by reference and never restates it: a registered routine's
identity (id, version, definition hash), a kernel's exactness, a result's method field, the content
address its hash is computed through. This repository depends on none of the packages that ship
cards or consume them; they take it. The library will take at most the public wire and
content-address packages it cites and the public Fact package for the result envelope.

## Licence

Apache-2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE). Decisions are in
[DECISIONS.md](DECISIONS.md).
