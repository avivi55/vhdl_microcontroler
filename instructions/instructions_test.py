import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.types import LogicArray, Logic
from cocotb.clock import Clock

async def cycle(dut):
    dut.clock.value = 0
    await Timer(10, units="ns")
    dut.clock.value = 1
    await Timer(10, units="ns")


@cocotb.test()
async def program_1(dut):
    dut.program_choice.value = LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0000")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0001")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("1111")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0110")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0110")\
        and LogicArray(dut.output_selection.value)  == LogicArray("01")


@cocotb.test()
async def program_2(dut):
    dut.program_choice.value = LogicArray("01")

    await cycle(dut)
    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0000")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0001")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("1101")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0110")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0110")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("1010")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("1011")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0111")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0111")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("1100")\
        and LogicArray(dut.output_selection.value)  == LogicArray("00")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0111")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0110")\
        and LogicArray(dut.output_selection.value)  == LogicArray("11")

    await cycle(dut)

    assert LogicArray(dut.function_selection.value) == LogicArray("0000")\
        and LogicArray(dut.route_selection.value)   == LogicArray("0110")\
        and LogicArray(dut.output_selection.value)  == LogicArray("01")

