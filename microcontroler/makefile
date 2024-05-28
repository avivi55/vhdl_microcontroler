VHDL=ghdl
VHDL_PRE_FLAGS=-fexplicit --ieee=synopsys --std=08
VHDL_FILES= ./microcontroler_wave.vhd $(filter-out $(wildcard ../*/*_wave.vhd), $(wildcard ../*/*.vhd))
VHDL_POST_FLAGS=--vpi=$(shell cocotb-config --lib-name-path vpi ghdl) --ieee-asserts=disable-at-0

COMPONENT=microcontroler
COMPONENTS=alu nbuffer dbus instructions

.PHONY: all
ifdef VHDL_PYTEST
all: work pytest wave clean
else
all: work vhdtest wave clean
endif


work:
	$(VHDL) -a -g $(VHDL_PRE_FLAGS) $(VHDL_FILES)

vhdtest:
	@echo "=========================================GLOBAL TEST========================================="
	@echo ""
	@$(foreach comp,\
		$(COMPONENTS),\
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~START $(comp)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";\
		$(MAKE) work vhdtest clean -C ../$(comp);\
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END $(comp)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";\
		echo "";\
	)
	@echo ""
	@echo "=========================================END GLOBAL TEST========================================="
	@echo ""


pytest:
	@echo "=========================================GLOBAL TEST========================================="
	@MODULE=$(COMPONENT)_test \
	LIBPYTHON_LOC=$(shell cocotb-config --libpython) \
	$(VHDL) -r $(VHDL_PRE_FLAGS) $(COMPONENT) $(VHDL_POST_FLAGS) --wave=waves/test.ghw
	@MODULE=$(COMPONENT)_test \
	LIBPYTHON_LOC=$(shell cocotb-config --libpython) \
	@$(foreach comp,\
		$(COMPONENTS),\
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~START $(comp)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";\
		$(MAKE) work pytest clean -C ../$(comp);\
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END $(comp)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";\
		echo "";\
	)
	@echo "=========================================END GLOBAL TEST========================================="
	@echo ""

wave:
	@echo "---------------------------WAVE---------------------------"
	$(VHDL) --elab-run $(VHDL_PRE_FLAGS) $(COMPONENT)_wave --wave=waves/wave.ghw
	@echo "---------------------------WAVE---------------------------"

clean:
	@rm *.cf
ifdef VHDL_PYTEST
	@rm -r ./__pycache__
	@rm *.xml
endif


