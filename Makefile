.PHONY: all
all:
	vim -c "Vitalize . --name=gonosen System.Filepath Process Underscore" -c q

.PHONY: clean
clean:
	/bin/rm -rf autoload/vital*
