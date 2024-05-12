GARBAGE_FILES= $(wildcard ./*/*.cf) $(wildcard ./*.cf)

clean:
	rm $(GARBAGE_FILES)
