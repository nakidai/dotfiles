.PHONY: all
all clean:
	@echo this Makefile is not supposed to build anything :3

README: README.7
	mandoc -Tascii README.7 | col -b > $@
