---
schema_version: "1.0"
kind: spec
entrypoints: [src, book.toml, recipes]
contract_count: 1
---
<!-- CONTRACT_COUNT_START -->1<!-- CONTRACT_COUNT_END -->

# Ruchy Cookbook

A test-driven cookbook for the [Ruchy programming language](https://github.com/paiml/ruchy):
recipes organized by chapter under `src/`, each backed by a runnable example under
`recipes/`, built into a book with [mdBook](https://rust-lang.github.io/mdBook/) and
published to [interactive.paiml.com/cookbook](https://interactive.paiml.com/cookbook/).

## What's here

- **`src/`** — the book's chapters (`ch01-foundations.md` … and appendices on testing,
  quality, and PMAT), each `.md` page is a chapter of recipes.
- **`recipes/`** — one directory per recipe (`ch01/001`, `ch02/003`, …), each a runnable
  Ruchy program the corresponding chapter page cites.
- **`scripts/`** — recipe scaffolding and quality-check helpers the `Makefile` wraps.
- **`.pmat/`** — PMAT quality-gate configuration (`.pmat/config.toml`).

## Installation

```text
cargo install mdbook
git clone https://github.com/paiml/ruchy-cookbook.git
cd ruchy-cookbook
```

## Usage

```bash
mdbook build
```

The committed CI (`.github/workflows/build.yml`) runs this exact command on every push
and pull request to build `book/html/` from `src/` and verify every chapter link and
recipe reference resolves; the command above is the literal claim this README makes,
not an illustration of it.

```text
make serve              # preview locally with auto-reload
make test                # test all recipes compile and run
make test-recipe RECIPE=ch01/001   # test one recipe
make coverage            # recipe coverage reports
make mutation-test       # mutation testing (80%+ required)
make pmat-analyze        # PMAT quality analysis (A+ required)
make quality-gates        # ALL quality gates, blocking
```

## Contributing

Every recipe is test-driven: write the recipe under `recipes/<chapter>/<nnn>/`, verify it
compiles and runs (`make test-recipe RECIPE=<chapter>/<nnn>`), then document it in the
matching `src/<chapter>.md` page. `make create-recipe CHAPTER=ch01 TITLE="..."` scaffolds
a new one. `make quality-gates` (tests, coverage, mutation score, PMAT analysis) is what
CI enforces on every PR via `.github/workflows/quality-gates.yml` and `test.yml`.

## pv-readme Contract

This README carries frontmatter (`schema_version`, `kind`, `entrypoints`,
`contract_count`) and is graded by `contracts/readme-root.yaml` against the
`pv-readme` SHACL shape (`readme:Readme`, #10).

- **One local claim available**: `.github/workflows/build.yml`'s `build` job runs
  `mdbook build` as a literal `run:` line on every push and pull request to `main`, which
  this README's Usage fence claims verbatim. The `make`-wrapped commands (`test`,
  `coverage`, `mutation-test`, `pmat-analyze`, `quality-gates`) describe real, runnable
  developer commands that `quality-gates.yml`/`test.yml` exercise through their own
  longer inline shell blocks rather than a bare `make <target>` line, so those fences
  stay `text`.
- **Entrypoints**: `src`, `book.toml`, `recipes`.
- **Contract count**: `1` (`contracts/census.json`; `readme-root.yaml` is the only file
  in this repo's `contracts/` directory).
- **Falsifier**: `tests/readme-shape-falsifier.sh`, 6 cases proving the check can fail
  (an unrun claim, a dropped `kind:`, a missing entrypoint, a wrong contract count) as
  well as pass.
- **LAB, not GATE** (C324): `.github/workflows/readme-shape-lab.yml` runs nightly plus
  `workflow_dispatch`, never on the PR path.

Part of paiml/ruchy-cookbook#10.

## License

Same license terms as the [Ruchy](https://github.com/paiml/ruchy) project.
