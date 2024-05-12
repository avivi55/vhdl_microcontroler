VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
COMPONENT=instructions

VHD_FILES=$(wildcard *.vhd)

.PHONY: all

all: work test wave clean

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(VHD_FILES)

test:
	@echo "================================TEST================================"
	$(VHDL) --elab-run $(VHDLFLAGS) $(COMPONENT)_test 
	@echo "================================TEST================================"
	@echo ""

wave:
	@echo "--------------------------------WAVE--------------------------------"
	$(VHDL) --elab-run $(VHDLFLAGS) $(COMPONENT)_wave --wave=waves/wave.ghw
	@echo "--------------------------------WAVE--------------------------------"

clean:
	rm *.cf
