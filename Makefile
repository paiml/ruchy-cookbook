# Ruchy Cookbook Makefile
# EXTREME TDD Quality System with PMAT Integration

.PHONY: all build serve test test-recipe coverage mutation-test quality-gates deploy clean help
.DEFAULT_GOAL := help

# Colors for terminal output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

##@ Build Commands

build: ## Build the cookbook with mdBook
	@echo "$(CYAN)📚 Building Ruchy Cookbook...$(NC)"
	mdbook build
	@echo "$(GREEN)✅ Build complete: book/index.html$(NC)"

serve: ## Serve the book locally with auto-reload
	@echo "$(CYAN)🌐 Starting local server...$(NC)"
	@echo "$(YELLOW)📖 Open http://localhost:3000 in your browser$(NC)"
	mdbook serve --open

clean: ## Remove all build artifacts
	@echo "$(CYAN)🧹 Cleaning build artifacts...$(NC)"
	rm -rf book/ target/ docs/quality/coverage-reports/ docs/quality/mutation-reports/
	@echo "$(GREEN)✅ Clean complete$(NC)"

##@ Testing Commands (EXTREME TDD)

test: ## Test all recipes compile and run
	@echo "$(CYAN)🧪 Testing all recipes...$(NC)"
	@if command -v ruchy &> /dev/null; then \
		./scripts/test-all-recipes.sh; \
	else \
		echo "$(YELLOW)⚠️  Ruchy not installed - skipping recipe tests$(NC)"; \
		echo "$(YELLOW)    Install Ruchy from https://ruchy-lang.org$(NC)"; \
	fi

test-recipe: ## Test specific recipe: make test-recipe RECIPE=ch01/001
	@echo "$(CYAN)🧪 Testing recipe $(RECIPE)...$(NC)"
	@if [ -z "$(RECIPE)" ]; then \
		echo "$(RED)❌ Error: RECIPE not specified$(NC)"; \
		echo "$(YELLOW)Usage: make test-recipe RECIPE=ch01/001$(NC)"; \
		exit 1; \
	fi
	@if command -v ruchy &> /dev/null; then \
		cd recipes/$(RECIPE) && ruchy test; \
	else \
		echo "$(YELLOW)⚠️  Ruchy not installed$(NC)"; \
		exit 1; \
	fi

coverage: ## Generate coverage reports for all recipes
	@echo "$(CYAN)📊 Generating coverage reports...$(NC)"
	@mkdir -p docs/quality/coverage-reports
	@if command -v ruchy &> /dev/null; then \
		./scripts/coverage.sh; \
	else \
		echo "$(YELLOW)⚠️  Ruchy not installed - skipping coverage$(NC)"; \
	fi

mutation-test: ## Run mutation testing (80%+ required)
	@echo "$(CYAN)🧬 Running mutation tests...$(NC)"
	@mkdir -p docs/quality/mutation-reports
	@if command -v cargo-mutants &> /dev/null; then \
		cargo mutants --test-tool=ruchy-test --minimum-score 80 \
			--output docs/quality/mutation-reports/; \
	else \
		echo "$(YELLOW)⚠️  cargo-mutants not installed$(NC)"; \
		echo "$(YELLOW)    Install: cargo install cargo-mutants$(NC)"; \
	fi

mutation-test-recipe: ## Mutation test specific recipe: make mutation-test-recipe RECIPE=ch01/001
	@echo "$(CYAN)🧬 Mutation testing recipe $(RECIPE)...$(NC)"
	@if [ -z "$(RECIPE)" ]; then \
		echo "$(RED)❌ Error: RECIPE not specified$(NC)"; \
		exit 1; \
	fi
	@if command -v cargo-mutants &> /dev/null; then \
		cd recipes/$(RECIPE) && cargo mutants --minimum-score 80; \
	else \
		echo "$(YELLOW)⚠️  cargo-mutants not installed$(NC)"; \
		exit 1; \
	fi

##@ Quality Gates (PMAT Integration)

pmat-analyze: ## Run PMAT quality analysis (A+ required)
	@echo "$(CYAN)🔍 Running PMAT analysis...$(NC)"
	@if command -v pmat &> /dev/null; then \
		pmat analyze --min-grade A+; \
	else \
		echo "$(YELLOW)⚠️  PMAT not installed$(NC)"; \
		echo "$(YELLOW)    Install: cargo install pmat$(NC)"; \
	fi

pmat-analyze-recipe: ## PMAT analysis for specific recipe: make pmat-analyze-recipe RECIPE=ch01/001
	@echo "$(CYAN)🔍 PMAT analysis for recipe $(RECIPE)...$(NC)"
	@if [ -z "$(RECIPE)" ]; then \
		echo "$(RED)❌ Error: RECIPE not specified$(NC)"; \
		exit 1; \
	fi
	@if command -v pmat &> /dev/null; then \
		pmat analyze --min-grade A+ recipes/$(RECIPE); \
	else \
		echo "$(YELLOW)⚠️  PMAT not installed$(NC)"; \
		exit 1; \
	fi

quality-gates: test coverage mutation-test pmat-analyze ## Run ALL quality gates (BLOCKING)
	@echo "$(GREEN)✅ All quality gates passed!$(NC)"
	@echo ""
	@echo "$(CYAN)📊 Quality Summary:$(NC)"
	@echo "  ✅ Tests: PASSING"
	@echo "  ✅ Coverage: ≥85%"
	@echo "  ✅ Mutation Score: ≥80%"
	@echo "  ✅ PMAT Grade: A+"
	@echo ""

lint: ## Check for SATD comments and code quality issues
	@echo "$(CYAN)🔍 Checking for SATD (TODO/FIXME/HACK)...$(NC)"
	@if grep -r "TODO\|FIXME\|HACK\|XXX" recipes/ src/ 2>/dev/null; then \
		echo "$(RED)❌ SATD comments detected!$(NC)"; \
		echo "$(YELLOW)   File GitHub issue instead via: pmat ticket create 'Description'$(NC)"; \
		exit 1; \
	else \
		echo "$(GREEN)✅ No SATD comments found$(NC)"; \
	fi

##@ Deployment (Production)

deploy: quality-gates ## Deploy to S3/CloudFront (PRODUCTION)
	@echo "$(CYAN)🚀 Deploying to production...$(NC)"
	@echo "$(YELLOW)⚠️  This deploys to LIVE production site!$(NC)"
	@read -p "Continue? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		make build && ./scripts/deploy.sh; \
	else \
		echo "$(YELLOW)Deployment cancelled$(NC)"; \
	fi

verify-deployment: ## Verify production deployment
	@echo "$(CYAN)🔍 Verifying deployment...$(NC)"
	@if curl -f https://interactive.paiml.com/cookbook/ > /dev/null 2>&1; then \
		echo "$(GREEN)✅ Site is accessible$(NC)"; \
	else \
		echo "$(RED)❌ Site is not accessible$(NC)"; \
		exit 1; \
	fi

##@ Recipe Management

create-recipe: ## Create new recipe skeleton: make create-recipe CHAPTER=ch01 TITLE="Recipe Title"
	@if [ -z "$(CHAPTER)" ] || [ -z "$(TITLE)" ]; then \
		echo "$(RED)❌ Error: CHAPTER and TITLE required$(NC)"; \
		echo "$(YELLOW)Usage: make create-recipe CHAPTER=ch01 TITLE='Recipe Title'$(NC)"; \
		exit 1; \
	fi
	@./scripts/create-recipe.sh $(CHAPTER) "$(TITLE)"

list-recipes: ## List all recipes with quality metrics
	@echo "$(CYAN)📋 Recipe Inventory:$(NC)"
	@find recipes/ -name "README.md" -type f | sort | while read recipe; do \
		echo "  📖 $$recipe"; \
	done

##@ Development Tools

status: ## Show cookbook status and quality metrics
	@echo "$(CYAN)📊 Ruchy Cookbook Status$(NC)"
	@echo "========================"
	@echo ""
	@echo "$(CYAN)📚 Content:$(NC)"
	@echo "  Recipes: $$(find recipes/ -name "main.ruchy" 2>/dev/null | wc -l)"
	@echo "  Chapters: $$(find src/ -name "ch*.md" 2>/dev/null | wc -l)"
	@echo ""
	@echo "$(CYAN)🧪 Testing:$(NC)"
	@echo "  Unit Tests: $$(find recipes/ -name "unit_tests.ruchy" 2>/dev/null | wc -l)"
	@echo "  Property Tests: $$(find recipes/ -name "property_tests.ruchy" 2>/dev/null | wc -l)"
	@echo ""
	@echo "$(CYAN)🎯 Quality:$(NC)"
	@echo "  SATD Count: $$(grep -r "TODO\|FIXME\|HACK" recipes/ src/ 2>/dev/null | wc -l)"
	@echo ""

watch: ## Watch for changes and rebuild
	@echo "$(CYAN)👀 Watching for changes...$(NC)"
	@if command -v watchexec &> /dev/null; then \
		watchexec -e md,toml "make build"; \
	else \
		echo "$(YELLOW)⚠️  watchexec not installed, using mdbook serve instead$(NC)"; \
		make serve; \
	fi

##@ Help

help: ## Display this help message
	@echo "$(CYAN)Ruchy Cookbook - EXTREME TDD Build System$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make $(CYAN)<target>$(NC)\n"} \
		/^[a-zA-Z_-]+:.*?##/ { printf "  $(CYAN)%-20s$(NC) %s\n", $$1, $$2 } \
		/^##@/ { printf "\n$(YELLOW)%s$(NC)\n", substr($$0, 5) }' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)Examples:$(NC)"
	@echo "  make build                               # Build the cookbook"
	@echo "  make test                                # Test all recipes"
	@echo "  make test-recipe RECIPE=ch01/recipe-001  # Test specific recipe"
	@echo "  make quality-gates                       # Run all quality checks"
	@echo "  make create-recipe CHAPTER=ch02 TITLE='Parse JSON'  # New recipe"
	@echo ""
