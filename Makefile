# Python Specification
PYTHON ?= python3

all: build 


clean:
	@echo " ---------- clean workspace -----------------------------------------------"
	@rm -rf venv
	@rm -rf build
	@rm -rf dist
	@rm -rf h2o_autodoc.egg-info
	@rm -rf .pytest_cache
	@rm -rf pytest_summaries.egg-info
	@find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete



venv: ## Install dependencies
	@echo " ---------- make new virtual env for $* -----------------------------------"
	@echo "Using $(shell ${PYTHON} --version)"
	${PYTHON} -m venv venv
	venv/bin/python3 -m pip install --upgrade pip
	venv/bin/python3 -m pip install -r requirements.txt


dist:
	@echo " ---------- creates distributables locally --------------------------------"
	@dist -d venv || $(MAKE) venv
	venv/bin/python3 setup.py bdist_wheel


editable_dist:
	@echo " ---------- creates editable distribution locally --------------------------------"
	@editable_dist -d venv || $(MAKE) venv
	venv/bin/python3 -m pip install --editable .

test:
	@test -d venv || $(MAKE) venv
	@test -d dist || $(MAKE) dist
	venv/bin/python -m pytest --color=yes -s -v --show-capture=no tests
