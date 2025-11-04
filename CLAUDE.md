# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Prime Directive

**Create a world-class Ruchy cookbook where EVERY recipe is test-driven, extensively validated, and guaranteed to work. This is a 1000-page physical book reference, not a tutorial.**

## Project Scope

**This is a LIVE PRODUCTION PROJECT**
- Site: https://interactive.paiml.com/cookbook
- Status: DEPLOYED and ACTIVE
- S3 Bucket: `interactive.paiml.com-production-mcb21d5j`
- CloudFront: Distribution ID `ELY820FVFXAFF`

**Deployment IS IN SCOPE:**
- Full production deployment to S3
- CloudFront cache invalidation
- AWS infrastructure (S3, CloudFront, Route 53)
- Production deployment via `make deploy`
- Post-deployment verification

## Core Principles (Toyota Way)

- **Kaizen (改善)**: Continuous incremental improvement - one recipe at a time
- **Genchi Genbutsu (現地現物)**: Go and see - test every recipe in REPL/compile before documenting
- **Jidoka (自働化)**: Quality at the source - automated quality gates prevent defects

## MANDATORY Development Approach (BLOCKING)

### A. EXTREME Test-Driven Development (TDD)
- **ALL recipes must be TDD**: Write tests FIRST, then implement recipe
- **NO exceptions**: Tests must pass before writing recipe documentation
- **Test-first workflow**: Tests → Implementation → Documentation (in that order)

### B. PMAT Quality Control (RUTHLESS)
- **PMAT controls EVERYTHING**: Quality gates, roadmap, issue tracking
- **Quality score requirement**: Minimum A+ grade on all recipes
- **BLOCKING gate**: No commits allowed without PMAT approval
- **Pre-commit hooks**: PMAT-managed, automatically enforced

### C. 85%+ Coverage Mandatory
- **Minimum 85% coverage**: Line, branch, and function coverage
- **Mutation testing**: 80% mutation kill rate required
- **Property-based testing**: Required for complex recipes
- **No partial recipes**: All recipes must be complete, working solutions

### D. Cookbook vs Tutorial Book

**This is NOT ruchy-book**:
```
ruchy-book (Tutorial):
- Sequential learning narrative
- Progressive concept introduction
- Chapter-by-chapter dependency
- 400-600 pages tutorial format
- Teaching methodology focus

ruchy-cookbook (Reference):
- Random-access problem/solution format
- Self-contained recipes (15-20 per chapter)
- Minimal cross-dependencies
- 1000 pages comprehensive reference
- Practical application focus
```

## Absolute Rules

1. **NEVER Document Unimplemented Features**: Zero tolerance for vaporware. If recipe doesn't work with current `ruchy`, it doesn't go in the cookbook.

2. **ALWAYS Test Recipes First**:
   ```bash
   # BEFORE writing ANY recipe documentation:
   echo 'recipe_code_here' | ruchy repl
   # MUST see expected output before documenting
   ```

3. **NEVER Leave SATD Comments**: No TODO, FIXME, HACK comments. File GitHub issues via PMAT instead:
   ```bash
   pmat ticket create "Improve error handling in Recipe 5.23" \
       --recipe ch05/recipe-023 \
       --priority medium
   ```

4. **ALWAYS Use Exact Version Pinning**:
   ```toml
   ruchy = "=3.194.0"  # EXACT version, no ranges
   ```

5. **Recipe Format is MANDATORY**: Every recipe follows exact format:
   - Problem Statement
   - Solution (complete working code)
   - Discussion (how it works, why it works)
   - Variations (alternative approaches)
   - See Also (cross-references)
   - Tests (comprehensive test suite)

6. **Zero Cruft Tolerance**: No temporary files, no debug artifacts. Clean workspace always.

7. **Trunk-Based Development**: Always work off `main`/`master`. NO branching.

## Repository Structure

```
ruchy-cookbook/
├── .github/
│   └── workflows/           # CI/CD pipelines (test, quality-gates, deploy)
├── .pmat/                   # PMAT configuration and hooks
│   ├── config.toml          # Quality standards configuration
│   ├── hooks/               # Pre-commit hooks (PMAT-managed)
│   └── roadmap.yaml         # PMAT-managed roadmap
├── book.toml                # mdBook configuration
├── src/                     # Book content (markdown, 30-40 chapters)
│   ├── SUMMARY.md
│   ├── ch01-foundations.md
│   ├── ch02-text-processing.md
│   └── [30-40 chapters total]
├── recipes/                 # Testable recipe implementations
│   ├── ch01/
│   │   ├── recipe-001/
│   │   │   ├── src/main.ruchy
│   │   │   ├── tests/
│   │   │   │   ├── unit_tests.ruchy
│   │   │   │   ├── property_tests.ruchy
│   │   │   │   └── integration_tests.ruchy
│   │   │   ├── Cargo.toml
│   │   │   └── coverage.json
│   │   └── recipe-002/
│   └── ch02/
├── tests/                   # Comprehensive test suite
├── scripts/                 # Build and automation scripts
├── docs/
│   └── specifications/
│       └── ruchy-cookbook-book.md  # Complete specification
└── Makefile                 # Build automation
```

## Development Commands

### Recipe Development Workflow (TDD - MANDATORY)

```bash
# Step 1: Create recipe skeleton
scripts/create-recipe.sh ch05 "Parse JSON with Error Handling"

# Step 2: Write failing tests FIRST
vim recipes/ch05/recipe-023/tests/unit_tests.ruchy
make test-recipe RECIPE=ch05/023  # MUST fail

# Step 3: Implement minimal solution
vim recipes/ch05/recipe-023/src/main.ruchy
make test-recipe RECIPE=ch05/023  # MUST pass

# Step 4: Add property tests
vim recipes/ch05/recipe-023/tests/property_tests.ruchy
make test-recipe RECIPE=ch05/023  # MUST pass

# Step 5: Run mutation testing
make mutation-test-recipe RECIPE=ch05/023  # MUST achieve 80%+

# Step 6: Document the recipe (ONLY NOW)
vim src/ch05-json-processing.md

# Step 7: Run PMAT quality gates
make pmat-analyze-recipe RECIPE=ch05/023  # MUST achieve A+

# Step 8: Commit
git add recipes/ch05/recipe-023/ src/ch05-json-processing.md
git commit -m "feat: Add Recipe 5.23 - Parse JSON with Error Handling

- Test coverage: 92%
- Mutation score: 85%
- PMAT grade: A+
- All quality gates passed"
```

### Essential Build Commands

```bash
# Build cookbook
make build              # mdBook build with validation

# Local development
make serve              # Local preview with auto-reload

# Testing
make test               # Test all recipes compile and run
make test-recipe RECIPE=ch05/023  # Test specific recipe
make coverage           # Generate coverage reports
make mutation-test      # Run mutation testing (80%+ required)

# Quality Gates
make quality-gates      # Run ALL quality gates (BLOCKING)
make pmat-analyze       # PMAT analysis (A+ grade required)
make lint               # Check for SATD/vaporware

# Deployment
make deploy             # Deploy to S3/CloudFront (production)
make verify-deployment  # Verify deployment success

# Cleanup
make clean              # Remove all build artifacts
```

### PMAT Integration

```bash
# Create ticket (REQUIRED before work)
pmat ticket create "Add Recipe: Async JSON Parsing" \
    --chapter ch05 \
    --type enhancement

# List tickets
pmat ticket list --status open

# Verify roadmap compliance
pmat roadmap verify

# Run quality analysis
pmat analyze --min-grade A+

# Close ticket (with quality verification)
pmat ticket close COOKBOOK-042 \
    --verify-tests \
    --verify-coverage \
    --verify-mutation
```

## Recipe Development Architecture

### Recipe Structure (MANDATORY)

Every recipe MUST follow this exact format:

```markdown
## Recipe 5.23: Parse JSON with Error Handling

**Difficulty**: Intermediate
**Coverage**: 92%
**Mutation Score**: 85%
**PMAT Grade**: A+

### Problem

[Clear description of problem solved]

### Solution

\`\`\`ruchy
// Complete, working code
fun parse_json(input: String) -> Result<Data, JsonError> {
    // Implementation
}
\`\`\`

### Discussion

[How it works, why it works, performance characteristics]

### Variations

**Variation 1: Custom Error Types**
\`\`\`ruchy
// Alternative approach
\`\`\`

**Variation 2: Async Parsing**
\`\`\`ruchy
// Async variant
\`\`\`

### See Also

- Recipe 5.22: Serialize Data to JSON
- Recipe 5.24: JSON Schema Validation
- Chapter 7: Error Handling Patterns

### Tests

[Link to comprehensive test suite]
```

### Test Requirements (BLOCKING)

Every recipe MUST include:

1. **Unit Tests**: 10-15 tests covering success/failure cases
2. **Property Tests**: 3-5 properties verified with 1000+ random inputs
3. **Integration Tests**: 1-2 tests showing real-world usage
4. **Mutation Tests**: 80%+ mutation kill rate

```ruchy
// Unit tests
#[test]
fun test_parse_valid_json() {
    let json = r#"{"name": "Alice", "age": 30}"#;
    let result = parse_json(json);
    assert!(result.is_ok());
}

// Property-based tests
#[proptest]
fun test_json_roundtrip(data: JsonValue) {
    let serialized = to_json(&data);
    let deserialized = from_json(&serialized);
    assert_eq!(deserialized, data);
}
```

## Quality Standards (ALL BLOCKING)

### Pre-commit Quality Gates

```bash
# These gates run automatically on EVERY commit:
1. Test Compilation      # All recipes must compile
2. Test Coverage         # ≥85% coverage required
3. Mutation Testing      # ≥80% mutation score required
4. Complexity Check      # ≤20 cyclomatic complexity
5. SATD Detection        # Zero SATD comments allowed
6. Code Quality          # A+ PMAT grade required
7. Documentation Check   # All recipes properly documented
8. Roadmap Verification  # Work must be assigned to ticket
```

**To bypass (EMERGENCY ONLY)**:
```bash
git commit --no-verify
```

**NEVER bypass except for**:
- Emergency hotfixes
- Documentation-only changes (no code)
- Hook infrastructure fixes

### Coverage Targets (MANDATORY)

```
Line Coverage:     ≥85% (BLOCKING)
Branch Coverage:   ≥80% (BLOCKING)
Function Coverage: ≥90% (BLOCKING)
Mutation Score:    ≥80% (BLOCKING)
SATD Count:        0    (BLOCKING)
PMAT Grade:        A+   (BLOCKING)
Complexity:        ≤20  (BLOCKING)
```

## Git Workflow

### Trunk-Based Development (NO BRANCHING)

```bash
# ALWAYS work off main
git pull origin main  # Primary method (ALWAYS try first)

# Fallback if git pull fails in agentic coding
cargo fetch origin main:main 2>/dev/null || git pull origin main

# Make changes
make test
make quality-gates

# Commit with descriptive message
git commit -m "feat: Add Recipe 5.23 - Parse JSON

- Test coverage: 92%
- Mutation score: 85%
- PMAT grade: A+
- All quality gates passed

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push directly to main
git push origin main
```

## Chapter Organization (30-40 Chapters)

### Proposed Structure

**Foundation (Chapters 1-5)**: Basic recipes
- Chapter 1: Basic Syntax & Common Patterns
- Chapter 2: String & Text Processing
- Chapter 3: Collections & Data Structures
- Chapter 4: Error Handling Patterns
- Chapter 5: JSON & Serialization

**Core Functionality (Chapters 6-15)**: Common programming tasks
- Chapters 6-10: File I/O, CLI, Regex, Date/Time, Math
- Chapters 11-15: Async, Network, HTTP, Database, Testing

**Intermediate (Chapters 16-25)**: Advanced recipes
- Chapters 16-20: Concurrency, Actors, Streams, DataFrames, Crypto
- Chapters 21-25: Compression, Parsing, Compiler, Web Scraping, Templates

**Advanced (Chapters 26-35)**: Systems programming
- Chapters 26-30: Unsafe, FFI, WASM, Performance, Memory
- Chapters 31-35: Lock-Free, SIMD, GPU, Embedded, OS Integration

**Expert (Chapters 36-40)**: Mastery topics
- Chapters 36-40: Custom Allocators, Compiler Plugins, Reflection, Meta-programming, Language Internals

## Success Criteria

### Book Completion Metrics

```
Total Chapters:    30-40
Total Recipes:     500-600
Total Examples:    2000-3000
Total Exercises:   300-400

Average Coverage:  ≥85%
Average Mutation:  ≥80%
PMAT Grade:        A+ (all recipes)

Recipe Success:    100% (every recipe works)
Compilation Rate:  100%
Zero SATD:         True
Production Deploy: True
```

### Quality Dashboard

When user asks "what's the status?":
```
📊 Ruchy Cookbook Status
========================
🧪 Test Results: X/Y recipes passing (Z%)
🔧 Coverage: Average X%
🧬 Mutation Score: Average Y%
🏆 PMAT Grade: A+
📚 Recipes Complete: X/600
📖 Chapters Complete: Y/40
✅ All quality gates: PASSING
```

## Important Differences from ruchy-book

1. **Format**: 1000-page physical reference book, not 400-600 page tutorial
2. **Structure**: Self-contained recipes, not sequential chapters
3. **Reading**: Random-access lookup, not linear progression
4. **Audience**: Experienced programmers, not beginners
5. **Focus**: Problem-solving recipes, not concept teaching
6. **Testing**: EXTREME TDD with 85%+ coverage and 80%+ mutation score
7. **Quality**: PMAT ruthlessly enforces all standards

## PMAT Control (RUTHLESS)

**PMAT controls**:
- Quality standards (A+ grade required)
- Roadmap management (all work via tickets)
- Issue tracking (GitHub issues via PMAT only)
- Pre-commit hooks (PMAT-managed, auto-enforced)
- Code review (PMAT analyzes before merge)

**NO work allowed without**:
1. Ticket assignment from PMAT roadmap
2. Passing all quality gates (8 gates)
3. A+ PMAT grade
4. Pre-commit hooks passing

## Remember

**Test-first cookbook**: Every recipe is test-driven, extensively validated, and guaranteed to work. This is the Toyota Way applied to technical publishing.

- **If it isn't tested, it isn't in the cookbook**
- **If it isn't automated, it's broken**
- **If PMAT rejects it, fix the root cause**
- **If coverage is below 85%, add more tests**
- **If mutation score is below 80%, improve test quality**
- **Zero tolerance for defects**
