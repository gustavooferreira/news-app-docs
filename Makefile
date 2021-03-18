.PHONY: all
all: help


.PHONY: count-words
count-words: ## Count words in Markdown files
	@wc -w *.md


.PHONY: lint
lint: ## Run linters
	@yamllint openapi/*.yaml


.PHONY: clean
clean: ## Remove generate pdfs
	@rm -f README.pdf
	@rm -f DESIGN_DOC.pdf


.PHONY: generate-imgs
generate-imgs: ## Generate diagram images
	@echo "Generating PNG diagram:"
	@drawio -x -b 40 -s 1 -p 0 -o ./images/bin/logical_diagram.png ./images/src/diagrams.drawio
	@drawio -x -b 40 -s 1 -p 1 -o ./images/bin/ha.png ./images/src/diagrams.drawio


.PHONY: generate-pdfs
generate-pdf: ## Generates PDF docs
	@pandoc README.md -s -o README.pdf
	@pandoc DESIGN_DOC.md -s -o DESIGN_DOC.pdf


GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


.PHONY: help
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${YELLOW}%-18s${GREEN}%s${RESET}\n", $$1, $$2}' $(MAKEFILE_LIST)
