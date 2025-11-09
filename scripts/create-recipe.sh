#!/usr/bin/env bash
# Create new recipe skeleton with TDD structure
# Usage: ./create-recipe.sh ch05 "Parse JSON with Error Handling"

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ $# -ne 2 ]; then
    echo -e "${RED}Usage: $0 CHAPTER TITLE${NC}"
    echo -e "Example: $0 ch05 'Parse JSON with Error Handling'"
    exit 1
fi

CHAPTER=$1
TITLE=$2

# Find next recipe number in chapter
CHAPTER_DIR="recipes/$CHAPTER"
mkdir -p "$CHAPTER_DIR"

NEXT_NUM=1
for dir in "$CHAPTER_DIR"/recipe-*/; do
    if [ -d "$dir" ]; then
        num=$(basename "$dir" | sed 's/recipe-//')
        if [ "$num" -ge "$NEXT_NUM" ]; then
            NEXT_NUM=$((num + 1))
        fi
    fi
done

RECIPE_NUM=$(printf "%03d" $NEXT_NUM)
RECIPE_DIR="$CHAPTER_DIR/recipe-$RECIPE_NUM"

echo -e "${CYAN}📝 Creating Recipe $CHAPTER.$RECIPE_NUM: $TITLE${NC}"
echo ""

# Create directory structure
mkdir -p "$RECIPE_DIR"/{src,tests,benches,examples}

# Create main source file (minimal implementation)
cat > "$RECIPE_DIR/src/main.ruchy" <<EOF
// Recipe $CHAPTER.$RECIPE_NUM: $TITLE
// TODO: Implement solution AFTER writing tests

pub fun solution() -> String {
    "TODO: Implement me!"
}

fun main() {
    println!("{}", solution());
}
EOF

# Create unit tests template
cat > "$RECIPE_DIR/tests/unit_tests.ruchy" <<EOF
// Unit tests for Recipe $CHAPTER.$RECIPE_NUM: $TITLE
// Write tests FIRST following EXTREME TDD

use std::testing::*;

#[test]
fun test_solution_basic() {
    // TODO: Write your tests FIRST
    let result = solution();
    assert!(!result.is_empty());
}

// TODO: Add 10-15 unit tests covering:
// - Success cases
// - Failure cases
// - Edge cases
// - Boundary conditions
EOF

# Create property tests template
cat > "$RECIPE_DIR/tests/property_tests.ruchy" <<EOF
// Property-based tests for Recipe $CHAPTER.$RECIPE_NUM: $TITLE

use std::testing::proptest::*;

#[proptest]
fun test_solution_properties(input: String) {
    // TODO: Define invariant properties
    let result = solution();
    // Property tests verify invariants across random inputs
}

// TODO: Add 3-5 property tests
EOF

# Create integration tests template
cat > "$RECIPE_DIR/tests/integration_tests.ruchy" <<EOF
// Integration tests for Recipe $CHAPTER.$RECIPE_NUM: $TITLE

use std::testing::*;

#[test]
fun test_integration() {
    // TODO: Test real-world usage scenarios
}
EOF

# Create Cargo.toml
cat > "$RECIPE_DIR/Cargo.toml" <<EOF
[package]
name = "recipe-$RECIPE_NUM-$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
version = "0.1.0"
edition = "2024"

[dependencies]
ruchy = "=3.194.0"

[dev-dependencies]
proptest = "1.4.0"

[[bin]]
name = "$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
path = "src/main.ruchy"
EOF

# Create README
cat > "$RECIPE_DIR/README.md" <<EOF
# Recipe $CHAPTER.$RECIPE_NUM: $TITLE

**Difficulty**: TODO
**Test Coverage**: TODO%
**Mutation Score**: TODO%
**PMAT Grade**: TODO

## TDD Workflow

Follow EXTREME TDD:

1. ✅ Write failing tests FIRST
2. ⬜ Implement minimal solution
3. ⬜ Add property tests
4. ⬜ Run mutation tests
5. ⬜ Document recipe
6. ⬜ Run PMAT quality gates

## Commands

\`\`\`bash
# Run tests (should FAIL initially)
make test-recipe RECIPE=$CHAPTER/recipe-$RECIPE_NUM

# Run with coverage
cd $RECIPE_DIR && ruchy test --coverage

# Run mutation tests
make mutation-test-recipe RECIPE=$CHAPTER/recipe-$RECIPE_NUM

# PMAT analysis
make pmat-analyze-recipe RECIPE=$CHAPTER/recipe-$RECIPE_NUM
\`\`\`
EOF

echo -e "${GREEN}✅ Recipe skeleton created: $RECIPE_DIR${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. cd $RECIPE_DIR"
echo "  2. Edit tests/unit_tests.ruchy - Write tests FIRST"
echo "  3. make test-recipe RECIPE=$CHAPTER/recipe-$RECIPE_NUM - Should FAIL"
echo "  4. Edit src/main.ruchy - Implement minimal solution"
echo "  5. make test-recipe RECIPE=$CHAPTER/recipe-$RECIPE_NUM - Should PASS"
echo ""
