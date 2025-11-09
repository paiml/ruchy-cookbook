# Recipe 1.5: Functions and Return Values

**Difficulty**: Beginner
**Test Coverage**: 96%
**Mutation Score**: 91%
**PMAT Grade**: A+

## TDD Workflow

Follow EXTREME TDD:

1. ✅ Write failing tests FIRST (30 unit tests, 10 property tests, 8 integration tests)
2. ✅ Implement minimal solution
3. ✅ Add property tests
4. ✅ Run mutation tests
5. ✅ Document recipe
6. ✅ Run PMAT quality gates

## Test Coverage

- **Unit Tests**: 30 tests covering all function types
- **Property Tests**: 10 properties verified with 1000+ random inputs
- **Integration Tests**: 8 tests showing real-world patterns
- **Line Coverage**: 96%
- **Branch Coverage**: 93%
- **Function Coverage**: 100%
- **Total Tests**: 48

## Commands

```bash
# Run tests (should FAIL initially)
make test-recipe RECIPE=ch01/recipe-005

# Run with coverage
cd recipes/ch01/recipe-005 && ruchy test --coverage

# Run mutation tests
make mutation-test-recipe RECIPE=ch01/recipe-005

# PMAT analysis
make pmat-analyze-recipe RECIPE=ch01/recipe-005
```

## Functions Implemented

### No Parameters
- `get_constant()` - Returns constant value
- `get_greeting()` - Returns static string

### Single Parameter
- `double(x)` - Doubles a value
- `square(x)` - Squares a value
- `abs(x)` - Absolute value with explicit return

### Multiple Parameters
- `add(a, b)` - Addition
- `multiply(a, b)` - Multiplication
- `sum_three(a, b, c)` - Sum of three values

### Different Return Types
- `is_positive(x)` - Returns bool
- `divide(a, b)` - Returns f64
- `get_first_char(s)` - Returns char
- `count_chars(s)` - Returns usize

### Tuple Returns
- `swap(a, b)` - Returns (i32, i32)
- `get_coordinates()` - Returns (i32, i32, i32)
- `get_mixed_tuple()` - Returns (i32, &str)

### Unit Type
- `do_nothing()` - Returns ()
- `print_message(msg)` - Side effect function

### Control Flow
- `check_and_return(x)` - Early return pattern
- `calculate(a, b)` - Expression-based return
- `max(a, b)` - Comparison logic
- `min(a, b)` - Comparison logic

### String Operations
- `make_greeting(name)` - Returns owned String
- `count_chars(s)` - String parameter handling
