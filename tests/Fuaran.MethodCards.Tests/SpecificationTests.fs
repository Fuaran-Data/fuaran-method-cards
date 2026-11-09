// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 Diametrical Ltd

module Fuaran.MethodCards.Tests.SpecificationTests

open Expecto
open Fuaran.MethodCards

let tests =
    testList
        "Specification"
        [ test "the schema family is method-card/v1" { Expect.equal Specification.Family "method-card/v1" "family" }

          test "a card has eight parts, identity first and examples last" {
              Expect.equal Specification.parts.Length 8 "eight parts"
              Expect.equal (List.head Specification.parts) "identity" "first"
              Expect.equal (List.last Specification.parts) "examples" "last"
              Expect.equal (List.distinct Specification.parts) Specification.parts "no part twice"
          } ]
