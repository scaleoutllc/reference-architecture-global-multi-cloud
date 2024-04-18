# Help Helper matches comments at the start of the task block so make help gives users information about each task
.PHONY: help
help: ## Displays information about available make tasks
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-clusters: ## Build all clusters in parallel.
	parallel --ungroup --halt soon,done=100% --term-seq INT,600000 \
	  './bin/cluster up' ::: team-dev-aws-us team-dev-aws-au

destroy-clusters: ## Tear down all clusters in parallel.
	parallel --ungroup --halt soon,done=100% --term-seq INT,600000 \
	  './bin/cluster down' ::: team-dev-aws-us team-dev-aws-au