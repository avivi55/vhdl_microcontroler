import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.types import LogicArray
from cocotb.clock import Clock

async def wait(dut):
    await Timer(1, units="ns")

def set_default(dut):
    dut.a.value = LogicArray("0010")
    dut.b.value = LogicArray("1001")
    dut.function_selection.value = LogicArray("0000")
    dut.carries_received.value = LogicArray("00")


@cocotb.test()
async def nop(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0000")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000000")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_right_shift_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0001")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000001")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_right_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0001")
    dut.carries_received.value = LogicArray("11")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00001001")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_left_shift_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0010")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000100")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_left_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0010")
    dut.carries_received.value = LogicArray("11")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000101")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def b_right_shift_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0011")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000100")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("01")

@cocotb.test()
async def b_right_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0011")
    dut.carries_received.value = LogicArray("11")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00001100")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("01")

@cocotb.test()
async def b_left_shift_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0100")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000010")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("10")

@cocotb.test()
async def b_left_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0100")
    dut.carries_received.value = LogicArray("11")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000011")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("10")

@cocotb.test()
async def a_identity(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0101")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000010")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def b_identity(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0110")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("11111001")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def not_a(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0111")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00001101")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def not_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1000")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000110")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_and_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1001")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00000000")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_or_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1010")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00001011")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_xor_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1011")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00001011")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_plus_b_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1100")
    dut.carries_received.value = LogicArray("01")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("11111100")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_plus_b_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1101")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("11111011")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_minus_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1110")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("00001001")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")

@cocotb.test()
async def a_times_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1111")
    
    await wait(dut)

    assert LogicArray(dut.alu_output.value) == LogicArray("11110010")\
        and LogicArray(dut.carries_emitted.value) == LogicArray("00")
