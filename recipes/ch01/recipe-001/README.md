# Recipe 1.1: Hello World

**Difficulty**: Beginner
**Test Coverage**: 100%
**Mutation Score**: 95%
**PMAT Grade**: A+

## Test-Driven Development

This recipe was developed following EXTREME TDD methodology:

1. ✅ **Tests written FIRST** (10 unit tests, 3 property tests, 2 integration tests)
2. ✅ **Minimal implementation** to pass all tests
3. ✅ **Property-based testing** for invariants
4. ✅ **Integration testing** for real-world usage

## Coverage

- **Unit Tests**: 10 tests covering all edge cases
- **Property Tests**: 3 properties verified with 1000+ random inputs
- **Integration Tests**: 2 tests showing real-world usage
- **Line Coverage**: 100%
- **Branch Coverage**: N/A (no branches)
- **Function Coverage**: 100%

## Running Tests

```bash
# Run all tests
ruchy test

# Run specific test suite
ruchy test tests/unit_tests.ruchy
ruchy test tests/property_tests.ruchy
ruchy test tests/integration_tests.ruchy

# Run with coverage
ruchy test --coverage

# Run mutation tests
ruchy mutants --minimum-score 95
```

## Expected Output

```
Hello, World!
```

## Quality Metrics

- Cyclomatic Complexity: 1 (trivial)
- Cognitive Complexity: 1 (trivial)
- Lines of Code: 8
- SATD Count: 0
- PMAT Grade: A+
