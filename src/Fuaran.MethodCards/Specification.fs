// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 Diametrical Ltd

namespace Fuaran.MethodCards

/// The specification's identity: the one name every artefact of this package validates under.
///
/// The card type, its codec and hash, and the four generators (tool definition, prompt fragment,
/// validator, result envelope) are written against `METHOD_CARD.md` and the schemas under
/// `schemas/v1/`; this module is the baseline they are added to.
[<RequireQualifiedAccess>]
module Specification =

    /// The schema family under `schemas/`. A card, and each artefact generated from one, names this
    /// family and validates against one of its members.
    [<Literal>]
    let Family = "method-card/v1"

    /// The eight parts of a card, in the order the normative text states them.
    let parts =
        [ "identity"
          "meaning"
          "applicability"
          "signature"
          "outputs"
          "interpretation"
          "presentation"
          "examples" ]
