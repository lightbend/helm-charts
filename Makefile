# Top-level Makefile for creating the index of helm charts.

# ALL CHARTS MUST:
# - Have a file layout as described at https://docs.helm.sh/developing_charts/
# - Have a Makefile with recipes for at least the three targets:
#     - 'lint':  Should do preliminary checks to confirm the project is ready for packaging.
#     - 'package':  Should create the chart tarball and push it up
#        to the helm-charts/docs directory.
#     - 'test':  Typically run by Travis to test the release.  That could be as simple
#        doing nothing, to firing up minikube and installing/running the package.
# 
# The 'common.mk' file can be used to provide these targets if desired.

# Collection of charts to process.
# These are subdirectories of helm-charts.  Add to the list as required.
#
# To package/test a subset, just define a value on the command line.
#    e.g. "make package CHARTS=sample-project"
CHARTS = enterprise-suite enterprise-suite-latest reactive-sandbox #sample-project


# These targets must be implemented by the individual chart Makefiles
COMMONTARGETS = lint package test


all: package docs/index.yaml

# Build the index.yaml file.
docs/index.yaml: init $(wildcard docs/*.tgz)
	helm repo index docs --url https://lightbend.github.io/helm-charts

init:
	@helm init -c > /dev/null

$(COMMONTARGETS): $(CHARTS)

$(CHARTS):
	$(info *** making $(MAKECMDGOALS) on $@)
	$(MAKE) -C $@ $(MAKECMDGOALS)

clean:
	rm docs/index.yaml

.PHONY: $(CHARTS) all lint test package init clean
