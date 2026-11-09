# Fuaran.MethodCards — API stability

**Status:** the `0.x` line, unreleased. The first version is the draft slot `0.1.0`, single-sourced
from `<Version>` in `Directory.Build.props`; it is released by a `v0.1.0` tag once the normative text,
the schemas, the library's card type, codec, hash and four generators, and the corpus are in
(DECISIONS.md D4). Nothing has been published.

## Versioning policy

Through the `0.x` line a breaking change to the public surface — the card type, its wire form or its
hash, a schema, the shape of a generated artefact — advances the minor, and an additive one rides the
standing draft slot. From `1.0.0` the version is semver: a breaking change advances the major, an
additive one the minor, and a change that moves no public surface the patch. A change to a schema that
makes an existing card invalid, or that changes the hash of an existing card, is breaking.

The specification's version is the package's version: a card names the family it validates under
(`method-card/v1`), and the family advances only at a major.

## Fable cleanliness

The library compiles under Fable on every gate pass (DECISIONS.md D5). A version cut whose Fable leg is
red is not released.
