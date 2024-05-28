import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.types import LogicArray, Logic, Range
from cocotb.clock import Clock

async def n_cycles(dut, n):
    for _ in range(n):
        dut.clock.value = 0
        await Timer(10, units="ns")
        dut.clock.value = 1
        await Timer(10, units="ns")
        
def reset(dut):
    dut.a_in.value = 0
    dut.b_in.value = 0
    dut.carries_received.value = 0

@cocotb.test()
async def program_1(dut):
    dut.program_choice.value = LogicArray("00")

    for a in range(-8, 8):
        for b in range(-8, 8):
            reset(dut)

            dut.a_in.value = LogicArray(a, Range(3, 'downto', 0))
            dut.b_in.value = LogicArray(b, Range(3, 'downto', 0))

            await n_cycles(dut, 10)

            assert LogicArray(dut.final_output.value) == LogicArray(a * b, Range(7,'downto',0))


            dut.program_choice.value = LogicArray("01")
            await n_cycles(dut, 1)
            dut.program_choice.value = LogicArray("00")

@cocotb.test()
async def program_2(dut):
    dut.program_choice.value = LogicArray("01")

    for a in range(2**4):
        for b in range(2**4):
            reset(dut)

            dut.a_in.value = LogicArray(a, Range(3, 'downto', 0))
            dut.b_in.value = LogicArray(b, Range(3, 'downto', 0))

            await n_cycles(dut, 15)
    
            expected_value = dut.a_in.value + dut.b_in.value # a + b
            expected_value ^= dut.a_in.value # xor a
            expected_value = ~expected_value # not
            expected_value &= 0b00001111 # we keep only the first 4 bits

            assert LogicArray(dut.final_output.value) == LogicArray(expected_value, Range(7,'downto',0))

            dut.program_choice.value = LogicArray("00")
            await n_cycles(dut, 1)
            dut.program_choice.value = LogicArray("01")


@cocotb.test()
async def program_3(dut):
    dut.program_choice.value = LogicArray("10")

    for a in range(4):
        for b in range(4):
            reset(dut)

            dut.a_in.value = LogicArray(a, Range(3, 'downto', 0))
            dut.b_in.value = LogicArray(b, Range(3, 'downto', 0))

            await n_cycles(dut, 60)
            
            expected_value = LogicArray(dut.a_in.value)[0] & LogicArray(dut.b_in.value)[1]
            expected_value |= LogicArray(dut.a_in.value)[1] & LogicArray(dut.b_in.value)[0]

            assert LogicArray(dut.final_output.value) == LogicArray(int(expected_value), Range(7,'downto',0))

            dut.program_choice.value = LogicArray("00")
            await n_cycles(dut, 1)
            dut.program_choice.value = LogicArray("10")

    


