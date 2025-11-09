# Recipe 1.6: Control Flow and Conditionals

**Difficulty**: Beginner
**Test Coverage**: 98%
**Mutation Score**: 94%
**PMAT Grade**: A+

## TDD Workflow

Follow EXTREME TDD:

1. ✅ Write failing tests FIRST (37 unit tests, 12 property tests, 10 integration tests)
2. ✅ Implement minimal solution
3. ✅ Add property tests
4. ✅ Run mutation tests
5. ✅ Document recipe
6. ✅ Run PMAT quality gates

## Test Coverage

- **Unit Tests**: 37 tests covering all control flow patterns
- **Property Tests**: 12 properties verified with 1000+ random inputs
- **Integration Tests**: 10 tests showing real-world scenarios
- **Line Coverage**: 98%
- **Branch Coverage**: 96%
- **Function Coverage**: 100%
- **Total Tests**: 59

## Commands

```bash
# Run tests (should FAIL initially)
make test-recipe RECIPE=ch01/recipe-006

# Run with coverage
cd recipes/ch01/recipe-006 && ruchy test --coverage

# Run mutation tests
make mutation-test-recipe RECIPE=ch01/recipe-006

# PMAT analysis
make pmat-analyze-recipe RECIPE=ch01/recipe-006
```

## Functions Implemented

### Basic Conditionals
- `check_sign(n)` - Classify as positive/negative/zero
- `is_greater(a, b)` - Comparison operator
- `is_equal(a, b)` - Equality check
- `is_in_range(value, min, max)` - Range validation

### Logical Operators
- `logical_and(a, b)` - Boolean AND
- `logical_or(a, b)` - Boolean OR
- `logical_not(a)` - Boolean NOT

### Match Expressions
- `match_number(n)` - Match specific values
- `match_range(n)` - Match with ranges
- `calculate_letter_grade(score)` - Grade calculator using match

### Nested Conditionals
- `classify_number(n)` - Sign and parity classification
- `max_of_three(a, b, c)` - Maximum with nested conditions

### Guard Clauses
- `process_age(age)` - Age processing with guards
- `validate_input(input)` - Input validation with early returns

### Multiple Conditions
- `check_all_conditions(a, b, c)` - All must be true
- `check_any_condition(a, b, c)` - Any can be true

### Real-World Examples
- `can_access(age, auth, role)` - Access control
- `calculate_shipping(weight)` - Shipping calculator
- `calculate_discount(amount, member, years)` - Discount logic
- `fizzbuzz(n)` - Classic FizzBuzz pattern
- `password_strength(password)` - Password validator
- `next_traffic_light(current)` - State machine
- `bmi_category(weight, height)` - BMI calculator
- `tax_bracket(income)` - Tax bracket logic
- `validate_user_input(user, pass, age)` - Multi-check validation

### Utilities
- `abs_value(n)` - Absolute value
- `unwrap_or_default(opt)` - Option handling with if let
