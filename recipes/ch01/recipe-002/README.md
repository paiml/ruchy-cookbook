# Recipe 1.2: Command Line Arguments

**Difficulty**: Beginner
**Test Coverage**: 95%
**Mutation Score**: 90%
**PMAT Grade**: A+

## TDD Workflow

Follow EXTREME TDD:

1. ✅ Write failing tests FIRST (15 unit tests, 6 property tests, 5 integration tests)
2. ✅ Implement minimal solution
3. ✅ Add property tests
4. ✅ Run mutation tests
5. ✅ Document recipe
6. ✅ Run PMAT quality gates

## Test Coverage

- **Unit Tests**: 15 tests covering all edge cases
- **Property Tests**: 6 properties verified with 1000+ random inputs
- **Integration Tests**: 5 tests showing real-world CLI scenarios
- **Line Coverage**: 95%
- **Branch Coverage**: 92%
- **Function Coverage**: 100%

## Commands

```bash
# Run tests (should FAIL initially)
make test-recipe RECIPE=ch01/recipe-002

# Run with coverage
cd recipes/ch01/recipe-002 && ruchy test --coverage

# Run mutation tests
make mutation-test-recipe RECIPE=ch01/recipe-002

# PMAT analysis
make pmat-analyze-recipe RECIPE=ch01/recipe-002
```
