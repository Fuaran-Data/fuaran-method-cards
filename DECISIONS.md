# Decisions

Design decisions that shaped `Fuaran.MethodCards`, newest first, with the reasoning that would have
to change for them to be revisited.

## 2026-11-09 — D5: the Fable leg is a gate stage from the first commit

The prompt fragment and the validator run in a browser host, so the library must compile under Fable,
and a library that is Fable-clean by intention and not by check drifts the first time a .NET-only API
is convenient. `run.ps1` compiles the library with the pinned Fable tool into an ignored directory on
every pass. The leg compiles; it does not yet compare values between hosts, which is added with the
generators.

## 2026-11-09 — D4: publication is a tag, under Trusted Publishing; not a version cohort member

A `v*` tag push runs `.github/workflows/publish-packages.yml`: the gate, then `dotnet pack` of the one
project into a repository-local directory, then a push to nuget.org under Trusted Publishing (OIDC).
A branch push reaches nothing. The package id is guarded in the workflow: anything but
`Fuaran.MethodCards.*` refuses the whole push. The version is `<Version>` in `Directory.Build.props`
at the tagged commit. Registering the nuget.org policy and pushing the tag are deliberate acts taken
once the normative text, the schemas, the library and the corpus are in. The package versions on its
own line and is not a member of any cohort of packages that version together: a specification's
version says when the specification changed, nothing else.

## 2026-11-09 — D3: the publication-boundary sweep bans by digest, and sweeps commit messages

This repository is written inside a private body of work it must not describe, and it is public from
its first commit, so a gate that listed the banned vocabulary in clear would publish the one thing it
exists to withhold. `gates/banned-terms.sha256` holds SHA-256 digests of the lower-cased terms; the
sweep hashes every token of every tracked file (and each token's parts and prefixes) and refuses a
match. Two patterns that disclose nothing are matched in clear: a work-item reference and an absolute
developer path. Commit messages are swept with the same rules and are part of the verdict, because a
publication carries its history; a hit in an unpushed message is fixed by rewriting it before the push.

## 2026-11-09 — D2: no dependency at the cut; at most the public wire, content-address and Fact packages later

The library is `FSharp.Core` plus `Fable.Core`. Nothing that ships a card or consumes one is a
dependency of this repository at build time, in either direction of the arrow a reader might expect:
the packages that implement methods take this one. When the card type's hash and the result envelope
are written, the library may take the public wire and content-address packages it cites (so a card's
hash is the content address of its canonical wire form, computed by the one implementation rather than
restated) and the public Fact package (so a result envelope's `method` is a Fact's method field when
the output is a Fact), and nothing else.

## 2026-11-09 — D1: a public repository of its own, Apache-2.0 from the first commit

The specification is its own repository rather than a document inside the package that first needed
it, because more than one package ships cards and they cannot depend on each other. It is public and
Apache-2.0 from its first commit and uses generic vocabulary only: it names no consumer, client or
product, and its worked example is a k-means card over generic data. The baseline from the first commit
is the one every new repository here starts with: `global.json` at SDK 10.0.203 rolling forward by
feature, every project on `net10.0`, Fantomas and Fable pinned in the tool manifest, `.editorconfig`,
`run.ps1` and `verify.ps1`, and `gate-reads.json` naming the schemas and the corpus.
