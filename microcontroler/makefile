VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
VHDL_FILES= ./microcontroler_wave.vhd $(filter-out $(wildcard ../*/*_wave.vhd), $(wildcard ../*/*.vhd))

COMPONENT=microcontroler
COMPONENTS=alu buffer dbus instructions 

.PHONY: all
all: work test wave clean

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(VHDL_FILES)

test:
	@echo "================================TEST================================"	
	@$(foreach comp,\
		$(COMPONENTS),\
		echo "#####$(comp)######";$(VHDL) --elab-run $(VHDLFLAGS) $(comp)_test; echo "################";\
	)
	@echo "================================TEST================================"
	@echo ""

wave:
	$(VHDL) --elab-run $(VHDLFLAGS) $(COMPONENT)_wave --wave=waves/wave.ghw

clean:
	rm *.cf

