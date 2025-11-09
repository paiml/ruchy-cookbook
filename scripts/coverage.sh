#!/usr/bin/env bash
# Generate coverage reports for all recipes
# Target: 85%+ coverage required

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${CYAN}📊 Generating Coverage Reports${NC}"
echo "=============================="
echo ""

mkdir -p docs/quality/coverage-reports

total_coverage=0
recipe_count=0
min_coverage=85

for recipe_dir in recipes/ch*/recipe-*/; do
    if [ ! -d "$recipe_dir" ]; then
        continue
    fi

    recipe_name=$(basename "$(dirname "$recipe_dir")")/$(basename "$recipe_dir")
    echo -e "${CYAN}Coverage for: $recipe_name${NC}"

    cd "$recipe_dir"

    if ruchy test --coverage > coverage_output.txt 2>&1; then
        # Extract coverage percentage (this will vary based on actual ruchy output)
        coverage=$(grep -oP '\d+\.\d+%' coverage_output.txt | head -1 | tr -d '%' || echo "0")

        if (( $(echo "$coverage >= $min_coverage" | bc -l) )); then
            echo -e "${GREEN}✅ Coverage: ${coverage}%${NC}"
        else
            echo -e "${YELLOW}⚠️  Coverage: ${coverage}% (below ${min_coverage}%)${NC}"
        fi

        total_coverage=$(echo "$total_coverage + $coverage" | bc)
        recipe_count=$((recipe_count + 1))

        # Save coverage report
        cp coverage_output.txt "../../docs/quality/coverage-reports/${recipe_name//\//-}.txt" || true
    else
        echo -e "${RED}❌ Coverage generation failed${NC}"
    fi

    cd - > /dev/null
    echo ""
done

# Calculate average
if [ $recipe_count -gt 0 ]; then
    avg_coverage=$(echo "scale=2; $total_coverage / $recipe_count" | bc)
    echo "=============================="
    echo -e "${CYAN}Coverage Summary${NC}"
    echo "=============================="
    echo "Average Coverage: ${avg_coverage}%"
    echo "Minimum Required: ${min_coverage}%"

    if (( $(echo "$avg_coverage >= $min_coverage" | bc -l) )); then
        echo -e "${GREEN}✅ Coverage requirement MET${NC}"
        exit 0
    else
        echo -e "${RED}❌ Coverage below requirement${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  No recipes found${NC}"
    exit 0
fi
