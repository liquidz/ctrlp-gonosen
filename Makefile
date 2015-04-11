.PHONY: all
all:
	vim -c "Vitalize . --name=gonosen System.Filepath Process Underscore" -c q

.PHONY: doc
doc:
	vimdoc .

.PHONY: clean
clean:
	/bin/rm -rf autoload/vital*

