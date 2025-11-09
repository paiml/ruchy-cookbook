# How to Use This Cookbook

## Reading Paths

### 🎯 Problem-Solver Path
**I have a specific problem to solve**

1. Use the table of contents to find relevant chapter
2. Scan recipe titles for your specific problem
3. Copy and adapt the solution code
4. Review variations for alternative approaches

**Time Investment**: 5-10 minutes per recipe

---

### 📚 Sequential Learner Path
**I want comprehensive mastery**

1. Start with Chapter 1: Foundation
2. Complete each recipe in order
3. Work through chapter exercises
4. Build understanding progressively

**Time Investment**: 2-3 weeks for foundation (Chapters 1-10)

---

### 🔬 Test-Driven Developer Path
**I want to understand quality practices**

1. Review each recipe's test suite
2. Study property-based tests
3. Examine mutation testing strategies
4. Apply patterns to your own code

**Time Investment**: 30 minutes per recipe (including test study)

---

## Recipe Difficulty Levels

Each recipe is tagged with a difficulty level:

- **Beginner**: Foundation recipes (Chapters 1-5)
- **Intermediate**: Common patterns (Chapters 6-15)
- **Advanced**: Complex techniques (Chapters 16-25)
- **Expert**: Systems programming (Chapters 26-40)

## Understanding Recipe Format

### Problem Statement
Clear description of what challenge we're solving.

### Solution
Complete, working code that you can copy and run immediately.

### Discussion
Detailed explanation of:
- **How it works**: Line-by-line breakdown
- **Why it works**: Design decisions and trade-offs
- **Performance**: Time/space complexity analysis
- **Safety**: Memory safety and error handling

### Variations
Alternative approaches for different scenarios:
- Performance-optimized versions
- Safety-focused versions
- Different API designs

### See Also
Cross-references to:
- Related recipes in other chapters
- Foundation concepts
- Advanced extensions

### Tests
Links to comprehensive test suite showing:
- Unit tests (10-15 per recipe)
- Property tests (3-5 per recipe)
- Integration tests (1-2 per recipe)
- Coverage metrics

## Quality Metrics Explained

Every recipe displays these metrics:

### Test Coverage
**Target: ≥85%**

Percentage of code lines executed during testing.

### Mutation Score
**Target: ≥80%**

Percentage of code mutations detected by tests. Higher scores indicate stronger test suites.

### PMAT Grade
**Target: A+**

Overall code quality grade from PMAT analysis, including:
- Code complexity
- Test quality
- Documentation completeness
- Best practices adherence

## Running Recipe Code

### Quick Test
```bash
# Run a single recipe
ruchy run recipes/ch01/recipe-001/src/main.ruchy
```

### With Tests
```bash
# Run recipe's test suite
cd recipes/ch01/recipe-001
ruchy test
```

### With Coverage
```bash
# Generate coverage report
cd recipes/ch01/recipe-001
ruchy test --coverage
```

## Chapter Exercises

Each chapter includes 10-15 exercises:

1. **Practice Problems**: Apply recipes to new scenarios
2. **Mini Projects**: Combine multiple recipes
3. **Challenge Problems**: Extend recipes in novel ways

**Recommended Approach**:
- Attempt exercise without looking at solution
- Write tests FIRST (following cookbook methodology)
- Implement minimal solution
- Compare with provided solution

## Navigation Tips

### Search by Problem Type
Use Ctrl+F (Cmd+F on Mac) to search for keywords:
- "parse JSON"
- "handle errors"
- "async"
- "performance"

### Cross-References
Follow "See Also" links to build deeper understanding of related topics.

### Progressive Complexity
Within each chapter, recipes progress from simple to complex. Don't skip ahead unless you're already familiar with earlier recipes.

## Contributing

Found an issue? Want to add a recipe?

All contributions must meet quality standards:
- ✅ Tests written FIRST
- ✅ 85%+ coverage
- ✅ 80%+ mutation score
- ✅ A+ PMAT grade

See [Appendix C: PMAT Integration](./appendix-c-pmat.md) for details.

---

**Ready to dive in?** Start with [Introduction](./introduction.md) or jump to [Chapter 1](./ch01-foundations.md)!
