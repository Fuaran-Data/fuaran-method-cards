// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 Diametrical Ltd

/// The schema stage of the gate: the manifest under schemas/v1 names every family, and every family it
/// names is a schema file beside it.
module Fuaran.MethodCards.Tests.SchemaTests

open System.IO
open System.Text.Json
open Expecto
open Fuaran.MethodCards

let private manifest () =
    let path = Path.Combine(Repo.schemas, "manifest.json")
    Expect.isTrue (File.Exists path) $"schemas/v1/manifest.json exists ({path})"
    JsonDocument.Parse(File.ReadAllText path).RootElement

let tests =
    testList
        "Schemas"
        [ test "the manifest names the specification's family and lists its schemas" {
              let m = manifest ()
              Expect.equal (m.GetProperty("family").GetString()) Specification.Family "family"
              Expect.equal (m.GetProperty("schemas").ValueKind) JsonValueKind.Array "schemas is a list"
          }

          test "every schema the manifest lists is a file beside it" {
              let m = manifest ()

              let listed =
                  [ for s in m.GetProperty("schemas").EnumerateArray() -> s.GetProperty("file").GetString() ]

              for file in listed do
                  Expect.isTrue (File.Exists(Path.Combine(Repo.schemas, file))) $"schemas/v1/{file} exists"

              printfn "schemas: %d listed in the manifest" listed.Length
          } ]
