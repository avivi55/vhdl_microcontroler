import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.types import LogicArray, Logic
from cocotb.clock import Clock

async def wait(dut):
    await Timer(1, units="ns")

def set_default(dut):
    dut.a_in.value = LogicArray("0001")
    dut.b_in.value = LogicArray("0010")
    dut.cache_1_received.value = LogicArray("10000101")
    dut.cache_2_received.value = LogicArray("01000110")
    dut.alu_output.value = LogicArray("00100111")


@cocotb.test()
async def a_in_buf_a(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0000")
    
    await wait(dut)

    assert LogicArray(dut.a_buffer.value)         == LogicArray("0001")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def b_in_buf_b(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0001")
    
    await wait(dut)

    assert LogicArray(dut.b_buffer.value)         == LogicArray("0010")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def alu_lsb_in_buf_a(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0010")
    
    await wait(dut)

    assert LogicArray(dut.a_buffer.value)         == LogicArray("0111")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def alu_msb_in_buf_a(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0011")
    
    await wait(dut)

    assert LogicArray(dut.a_buffer.value)         == LogicArray("0010")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def alu_lsb_in_buf_b(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0100")
    
    await wait(dut)

    assert  LogicArray(dut.b_buffer.value)         == LogicArray("0111")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def alu_msb_in_buf_b(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0101")
    
    await wait(dut)

    assert LogicArray(dut.b_buffer.value)         == LogicArray("0010")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def alu_in_cache_1(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0110")
    
    await wait(dut)

    assert LogicArray(dut.cache_1_emitted.value)  == LogicArray("00100111")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("1")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def alu_in_cache_2(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("0111")
    
    await wait(dut)

    assert LogicArray(dut.cache_2_emitted.value)  == LogicArray("00100111")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("1")

@cocotb.test()
async def cache_1_lsb_in_buf_a(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1000")
    
    await wait(dut)

    assert LogicArray(dut.a_buffer.value)         == LogicArray("0101")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def cache_1_msb_in_buf_a(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1001")
    
    await wait(dut)

    assert LogicArray(dut.a_buffer.value)         == LogicArray("1000")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def cache_1_lsb_in_buf_b(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1010")
    
    await wait(dut)

    assert LogicArray(dut.b_buffer.value)         == LogicArray("0101")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def cache_1_msb_in_buf_b(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1011")
    
    await wait(dut)

    assert LogicArray(dut.b_buffer.value)         == LogicArray("1000")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def cache_2_lsb_in_buf_a(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1100")
    
    await wait(dut)

    assert LogicArray(dut.a_buffer.value)         == LogicArray("0110")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def cache_2_msb_in_buf_a(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1101")
    
    await wait(dut)

    assert LogicArray(dut.a_buffer.value)         == LogicArray("0100")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def cache_2_lsb_in_buf_b(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1110")
    
    await wait(dut)

    assert LogicArray(dut.b_buffer.value)         == LogicArray("0110")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")

@cocotb.test()
async def cache_2_msb_in_buf_b(dut):
    set_default(dut)

    dut.routing_selection.value = LogicArray("1111")
    
    await wait(dut)

    assert LogicArray(dut.b_buffer.value)         == LogicArray("0100")\
        and LogicArray(dut.a_buffer_enable.value) == LogicArray("0")\
        and LogicArray(dut.b_buffer_enable.value) == LogicArray("1")\
        and LogicArray(dut.cache_1_enable.value)  == LogicArray("0")\
        and LogicArray(dut.cache_2_enable.value)  == LogicArray("0")


# OUTPUT SELECTION


@cocotb.test()
async def final_output_is_none(dut):
    set_default(dut)
    dut.outputting_selection.value = LogicArray("00")
    
    await wait(dut)
    assert LogicArray(dut.final_output.value) == LogicArray("00000000")

@cocotb.test()
async def final_output_is_cache_1(dut):
    set_default(dut)
    dut.outputting_selection.value = LogicArray("01")
    
    await wait(dut)
    assert LogicArray(dut.final_output.value) == LogicArray(dut.cache_1_received.value)

@cocotb.test()
async def final_output_is_cache_2(dut):
    set_default(dut)
    dut.outputting_selection.value = LogicArray("10")
    
    await wait(dut)
    assert LogicArray(dut.final_output.value) == LogicArray(dut.cache_2_received.value)

@cocotb.test()
async def final_output_is_alu_output(dut):
    set_default(dut)
    dut.outputting_selection.value = LogicArray("11")
    
    await wait(dut)
    assert LogicArray(dut.final_output.value) == LogicArray(dut.alu_output.value)