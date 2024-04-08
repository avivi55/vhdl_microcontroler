VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08

vhd_files=../buffer/buffer.vhd $(wildcard *.vhd)

.PHONY: all

all: work elaborate run

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(vhd_files)

elaborate:
	$(VHDL) -e $(VHDLFLAGS) dbus_out_test
	$(VHDL) -e $(VHDLFLAGS) dbus_route_test

run:
	$(VHDL) -r $(VHDLFLAGS) dbus_out_test --wave=res_out.ghw
	$(VHDL) -r $(VHDLFLAGS) dbus_route_test --wave=res_route.ghw