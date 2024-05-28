import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.types import LogicArray, Range
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
    
    for test_value in range(2**4):
        dut.a.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = test_value >> 1
        expected_carry = test_value & 0b0001

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_right_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0001")
    dut.carries_received.value = LogicArray("11")
    
    for test_value in range(2**4):
        dut.a.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = (test_value >> 1) | 0b1000
        expected_carry = test_value & 0b0001

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_left_shift_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0010")
    
    for test_value in range(2**4):
        dut.a.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = (test_value << 1) & 0b00001111
        expected_carry = (test_value & 0b1000) >> 2

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_left_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0010")
    dut.carries_received.value = LogicArray("11")
    
    for test_value in range(2**4):
        dut.a.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = ((test_value << 1) & 0b00001111) | 0b0001
        expected_carry = (test_value & 0b1000) >> 2

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def b_right_shift_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0011")
    
    for test_value in range(2**4):
        dut.b.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = test_value >> 1
        expected_carry = test_value & 0b0001

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def b_right_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0011")
    dut.carries_received.value = LogicArray("11")
    
    for test_value in range(2**4):
        dut.b.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = (test_value >> 1) | 0b1000
        expected_carry = test_value & 0b0001

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def b_left_shift_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0100")
    
    for test_value in range(2**4):
        dut.b.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = (test_value << 1) & 0b00001111
        expected_carry = (test_value & 0b1000) >> 2

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def b_left_shift_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0100")
    dut.carries_received.value = LogicArray("11")
    
    for test_value in range(2**4):
        dut.b.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = ((test_value << 1) & 0b00001111) | 0b0001
        expected_carry = (test_value & 0b1000) >> 2

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_identity(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0101")
    
    for test_value in range(2**4):
        dut.a.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = test_value
        expected_carry = 0

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def b_identity(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0110")
    
    for test_value in range(2**4):
        dut.b.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = test_value
        expected_carry = 0

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def not_a(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("0111")
    
    for test_value in range(2**4):
        dut.a.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = ~test_value & 0b00001111
        expected_carry = 0

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def not_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1000")
    
    for test_value in range(2**4):
        dut.b.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut)

        expected_value = ~test_value & 0b00001111
        expected_carry = 0

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
            and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_and_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1001")
    
    for a in range(2**4):
        dut.a.value = LogicArray(a, Range(3, 'downto', 0))
        for b in range(2**4):
            dut.b.value = LogicArray(b, Range(3, 'downto', 0))
            await wait(dut)

            expected_value = a & b
            expected_carry = 0

            assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
                and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_or_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1010")
    
    for a in range(2**4):
        dut.a.value = LogicArray(a, Range(3, 'downto', 0))
        for b in range(2**4):
            dut.b.value = LogicArray(b, Range(3, 'downto', 0))
            await wait(dut)

            expected_value = a | b
            expected_carry = 0

            assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
                and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_xor_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1011")
    
    for a in range(2**4):
        dut.a.value = LogicArray(a, Range(3, 'downto', 0))
        for b in range(2**4):
            dut.b.value = LogicArray(b, Range(3, 'downto', 0))
            await wait(dut)

            expected_value = a ^ b
            expected_carry = 0

            assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
                and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_plus_b_with_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1100")
    
    for a in range(-8, 8):
        dut.a.value = LogicArray(a, Range(3, 'downto', 0))
        for b in range(-8, 8):
            dut.b.value = LogicArray(b, Range(3, 'downto', 0))
            for carry in range(1):
                dut.carries_received.value = LogicArray(carry, Range(1, 'downto', 0))
                await wait(dut)

                expected_value = a + b + carry
                expected_carry = 0

                assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
                    and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_plus_b_no_carry(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1101")
    
    for a in range(-8, 8):
        dut.a.value = LogicArray(a, Range(3, 'downto', 0))
        for b in range(-8, 8):
            dut.b.value = LogicArray(b, Range(3, 'downto', 0))

            await wait(dut)

            expected_value = a + b
            expected_carry = 0

            assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
                and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_minus_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1110")
    
    for a in range(-8, 8):
        dut.a.value = LogicArray(a, Range(3, 'downto', 0))
        for b in range(-8, 8):
            dut.b.value = LogicArray(b, Range(3, 'downto', 0))

            await wait(dut)

            expected_value = a - b
            expected_carry = 0

            assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
                and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))

@cocotb.test()
async def a_times_b(dut):
    set_default(dut)

    dut.function_selection.value = LogicArray("1111")
    
    for a in range(-8, 8):
        dut.a.value = LogicArray(a, Range(3, 'downto', 0))
        for b in range(-8, 8):
            dut.b.value = LogicArray(b, Range(3, 'downto', 0))

            await wait(dut)

            expected_value = a * b
            expected_carry = 0

            assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7, 'downto', 0))\
                and LogicArray(dut.carries_emitted.value) == LogicArray(expected_carry, Range(1, 'downto', 0))
