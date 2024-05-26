VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
VHDL_FILES= ./microcontroler_wave.vhd $(filter-out $(wildcard ../*/*_wave.vhd), $(wildcard ../*/*.vhd))

COMPONENT=microcontroler
COMPONENTS=alu buffer dbus instructions

.PHONY: all
all: work wave pytest clean

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(VHDL_FILES)

vhdtest:
	@echo "================================TEST================================"	
	@$(foreach comp,\
		$(COMPONENTS),\
		echo "#####$(comp)######";$(VHDL) --elab-run $(VHDLFLAGS) $(comp)_test; echo "################";\
	)
	@echo "================================TEST================================"
	@echo ""

pytest:
	@echo "================================TEST================================"	
	@$(foreach comp,\
		$(COMPONENTS),\
		echo "#####$(comp)######";\
		$(MAKE) work pytest clean -C ../$(comp);\
		echo "################";\
		echo "";\
	)
	@echo "================================TEST================================"
	@echo ""

wave:
	$(VHDL) --elab-run $(VHDLFLAGS) $(COMPONENT)_wave --wave=waves/wave.ghw

clean:
	rm *.cf

