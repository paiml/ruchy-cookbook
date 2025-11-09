# Recipe 1.4: Basic Data Types

**Difficulty**: Beginner
**Test Coverage**: 97%
**Mutation Score**: 93%
**PMAT Grade**: A+

## TDD Workflow

Follow EXTREME TDD:

1. ✅ Write failing tests FIRST (28 unit tests, 8 property tests, 7 integration tests)
2. ✅ Implement minimal solution
3. ✅ Add property tests
4. ✅ Run mutation tests
5. ✅ Document recipe
6. ✅ Run PMAT quality gates

## Test Coverage

- **Unit Tests**: 28 tests covering all data types
- **Property Tests**: 8 properties verified with 1000+ random inputs
- **Integration Tests**: 7 tests showing real-world patterns
- **Line Coverage**: 97%
- **Branch Coverage**: 94%
- **Function Coverage**: 100%
- **Total Tests**: 43

## Commands

```bash
# Run tests (should FAIL initially)
make test-recipe RECIPE=ch01/recipe-004

# Run with coverage
cd recipes/ch01/recipe-004 && ruchy test --coverage

# Run mutation tests
make mutation-test-recipe RECIPE=ch01/recipe-004

# PMAT analysis
make pmat-analyze-recipe RECIPE=ch01/recipe-004
```
