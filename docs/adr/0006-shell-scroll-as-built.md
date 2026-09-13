# ADR 0006: Shell Scroll As-Built

## Date
2026-09-13

## Context
During Phase B of the P7 redesign, we audited the shell scrolling behavior. A full-screen page scroll was implemented on desktop (where the shell owns one page scroll `Scroll > Center > ConstrainedBox(1200)` and nested scrolls are removed). The CTA was pinned and reachable. However, relocating the shell completely conflicted with locked R1 keys (tablet view). 

## Decision
We will keep the screen-level page scroll as-built (B done as-built). The shell owns the one page scroll, `shrinkWrap` is used for grids to prevent nested scrolling, and the desktop CTA remains pinned. We avoid a literal shell relocation that would cause conflicts.

## Status
Accepted

## Consequences
- Desktop whole-page scroll works elegantly without nested scrolling artifacts.
- The literal shell relocation is deferred.
- No code changes are required for the shell relocation conflict.
