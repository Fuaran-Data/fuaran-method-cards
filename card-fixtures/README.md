# Card fixtures

The corpus: one directory per card, holding `card.json` and, beside it, the four artefacts the library
generates from it (the tool definition, the prompt-fragment entry, the validator's vectors and the
result envelope), committed so the gate can regenerate them and compare byte for byte. At least one
complete card per determinism class (`Pinned`, `SeededReplayable`, `HostRounded`), with positive and
negative validator vectors. The worked example is a k-means card over generic data.
