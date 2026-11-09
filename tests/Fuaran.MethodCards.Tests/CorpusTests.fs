// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 Diametrical Ltd

/// The corpus stage of the gate: every directory under card-fixtures is a card with its generated
/// artefacts committed beside it. The regeneration and byte-comparison of those artefacts is added with
/// the library's generators; until then this stage holds the corpus's shape and reports its size.
module Fuaran.MethodCards.Tests.CorpusTests

open System.IO
open Expecto

let tests =
    testList
        "Corpus"
        [ test "card-fixtures exists and every entry is a directory holding card.json" {
              Expect.isTrue (Directory.Exists Repo.corpus) $"card-fixtures exists ({Repo.corpus})"
              let dirs = Directory.GetDirectories Repo.corpus

              for d in dirs do
                  Expect.isTrue (File.Exists(Path.Combine(d, "card.json"))) $"{Path.GetFileName d}/card.json exists"

              printfn "corpus: %d card fixture(s)" dirs.Length
          } ]
