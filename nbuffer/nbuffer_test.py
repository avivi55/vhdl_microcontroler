import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.types import LogicArray
from cocotb.clock import Clock

async def cycle(dut):
    dut.clock.value = 0
    await Timer(10, units="ns")
    dut.clock.value = 1
    await Timer(10, units="ns")


@cocotb.test()
async def reset(dut):
    dut.e1.value = LogicArray("0011")
    dut.enable.value = 1
    dut.reset.value = 1

    await cycle(dut)

    assert LogicArray(dut.s1.value) == LogicArray("0000"), "Reset does not reset properly !"

@cocotb.test()
async def enable_on(dut):
    dut.e1.value = LogicArray("1110")
    dut.reset.value = 0
    dut.enable.value = 1

    await cycle(dut)

    assert LogicArray(dut.s1.value) == LogicArray("1110"), "Output does not match input when enable is on !"

@cocotb.test()
async def enable_off(dut):
    dut.reset.value = 0
    dut.enable.value = 1 
    dut.e1.value = LogicArray("0110")

    await cycle(dut)

    dut.enable.value = 0
    await cycle(dut)

    dut.e1.value = LogicArray("1111")
    await cycle(dut)

    assert LogicArray(dut.s1.value) == LogicArray("0110"), "Output matchs input even tho enable is off !"

@cocotb.test()
async def enable_on_edge(dut):
    dut.e1.value = LogicArray("1110")
    dut.reset.value = 0
    dut.enable.value = 1

    await cocotb.start(Clock(dut.clock, 10, 'ns').start())

    await RisingEdge(dut.clock)
    assert LogicArray(dut.s1.value) != LogicArray("1110"), "Output matches input on rising edge"
    
    await FallingEdge(dut.clock)
    assert LogicArray(dut.s1.value) == LogicArray("1110"), "Output doesn't match input on falling edge"