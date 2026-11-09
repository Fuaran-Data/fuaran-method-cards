// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 Diametrical Ltd

module Fuaran.MethodCards.Tests.Program

open Expecto

let all =
    testList "Fuaran.MethodCards" [ SpecificationTests.tests; SchemaTests.tests; CorpusTests.tests ]

[<EntryPoint>]
let main argv = runTestsWithCLIArgs [] argv all
