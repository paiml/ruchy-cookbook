#!/usr/bin/env bash
# Test all recipes in the cookbook
# Part of EXTREME TDD quality system

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}🧪 Testing All Recipes${NC}"
echo "======================="
echo ""

total=0
passed=0
failed=0

# Find all recipe directories
for recipe_dir in recipes/ch*/recipe-*/; do
    if [ ! -d "$recipe_dir" ]; then
        continue
    fi

    total=$((total + 1))
    recipe_name=$(basename "$(dirname "$recipe_dir")")/$(basename "$recipe_dir")

    echo -e "${CYAN}Testing: $recipe_name${NC}"

    if cd "$recipe_dir" && ruchy test 2>&1 | grep -q "test result: ok"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        passed=$((passed + 1))
    else
        echo -e "${RED}❌ FAILED${NC}"
        failed=$((failed + 1))
    fi

    cd - > /dev/null
    echo ""
done

# Summary
echo "======================="
echo -e "${CYAN}Test Summary${NC}"
echo "======================="
echo "Total:  $total"
echo -e "${GREEN}Passed: $passed${NC}"

if [ $failed -gt 0 ]; then
    echo -e "${RED}Failed: $failed${NC}"
    exit 1
else
    echo -e "${GREEN}Failed: 0${NC}"
    echo ""
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
fi
