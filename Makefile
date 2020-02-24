.PHONY: docs help
.DEFAULT_GOAL := help
msg?='<your_commit_message>'
tag?='<your_release_tag>'

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

docs: ## generate Sphinx HTML documentation, including API docs
	rm -fr docs/_build/*
	$(MAKE) -C docs html

release: ## create a new git release. Options: msg=<your_commit_message>, tag=<your_release_tag>
	sed -i "s/^  - Git repository: .*/  - Git repository: "$(tag)"/g" README.rst
	sed -i "s/^  - Release: .*/  - Release: '"$(tag)"/g" README.rst

