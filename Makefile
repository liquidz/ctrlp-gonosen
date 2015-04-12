VITAL_MODULES = System.Filepath \
				Process \
				Underscore

.PHONY: all
all:
	vim -c "Vitalize . --name=gonosen $(VITAL_MODULES)" -c q

.PHONY: test
test:
	themis

.PHONY: doc
doc:
	vimdoc .

.PHONY: clean
clean:
	/bin/rm -rf autoload/vital*

