VHDL=ghdl
VHDL_PRE_FLAGS=-fexplicit --ieee=synopsys --std=08
VHDL_POST_FLAGS=--vpi=$(shell cocotb-config --lib-name-path vpi ghdl) --ieee-asserts=disable-at-0

VHDL_FILES=$(wildcard *.vhd)

.PHONY: all
ifdef VHDL_PYTEST
all: work pytest wave clean
else
all: work vhdtest wave clean
endif

work:
	$(VHDL) -a -g $(VHDL_PRE_FLAGS) $(VHDL_FILES)

vhdtest:
	@echo "===========================START $(COMPONENT) TEST==========================="
	@echo ""
	$(VHDL) --elab-run $(VHDL_PRE_FLAGS) $(COMPONENT)_test
	@echo ""
	@echo "===========================END $(COMPONENT) TEST==========================="
	@echo ""

pytest:
	@echo "===========================START $(COMPONENT) TEST==========================="
	@echo ""
	MODULE=$(COMPONENT)_test \
	LIBPYTHON_LOC=$(shell cocotb-config --libpython) \
	$(VHDL) -r $(VHDL_PRE_FLAGS) $(COMPONENT) $(VHDL_POST_FLAGS)
	@echo ""
	@echo "===========================END $(COMPONENT) TEST==========================="
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


