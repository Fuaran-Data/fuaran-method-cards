// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 Diametrical Ltd

/// Where the repository's schemas and corpus live, found by walking up from the test binary.
module Fuaran.MethodCards.Tests.Repo

open System
open System.IO

let root =
    let rec up (d: DirectoryInfo) =
        if isNull d then
            failwith "Fuaran.MethodCards.slnx was not found above the test binary."

        if File.Exists(Path.Combine(d.FullName, "Fuaran.MethodCards.slnx")) then
            d.FullName
        else
            up d.Parent

    up (DirectoryInfo AppContext.BaseDirectory)

let schemas = Path.Combine(root, "schemas", "v1")
let corpus = Path.Combine(root, "card-fixtures")
