# Recipe 1.3: Variables and Mutability

**Difficulty**: Beginner
**Test Coverage**: 98%
**Mutation Score**: 92%
**PMAT Grade**: A+

## TDD Workflow

Follow EXTREME TDD:

1. ✅ Write failing tests FIRST (16 unit tests, 7 property tests, 7 integration tests)
2. ✅ Implement minimal solution
3. ✅ Add property tests
4. ✅ Run mutation tests
5. ✅ Document recipe
6. ✅ Run PMAT quality gates

## Test Coverage

- **Unit Tests**: 16 tests covering all variable concepts
- **Property Tests**: 7 properties verified with 1000+ random inputs
- **Integration Tests**: 7 tests showing real-world patterns
- **Line Coverage**: 98%
- **Branch Coverage**: 95%
- **Function Coverage**: 100%

## Commands

```bash
# Run tests (should FAIL initially)
make test-recipe RECIPE=ch01/recipe-003

# Run with coverage
cd recipes/ch01/recipe-003 && ruchy test --coverage

# Run mutation tests
make mutation-test-recipe RECIPE=ch01/recipe-003

# PMAT analysis
make pmat-analyze-recipe RECIPE=ch01/recipe-003
```
