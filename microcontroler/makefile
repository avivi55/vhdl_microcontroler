VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
ARCHITECTURE=microcontroler_test
vhd_files= $(filter-out $(wildcard ../*/*_test.vhd), $(wildcard ../*/*.vhd))

.PHONY: all
all: work elaborate run clean

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(vhd_files)

elaborate:
	$(VHDL) -e $(VHDLFLAGS) $(ARCHITECTURE)

run:
	$(VHDL) -r $(VHDLFLAGS) $(ARCHITECTURE) --wave=waves/wave.ghw

clean:
	rm *.cf

