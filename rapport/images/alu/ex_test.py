@cocotb.test()
async def a_left_shift_with_carry(dut):
    dut.function_selection.value = LogicArray("0010")
    dut.carries_received.value = LogicArray("11")
    
    for test_value in range(2**4):
        dut.a.value = LogicArray(test_value, Range(3, 'downto', 0))
        await wait(dut) # 1ns
        expected_value = ((test_value << 1) & 0b00001111) | 0b0001
        expected_carry = (test_value & 0b1000) >> 2

        assert LogicArray(dut.alu_output.value) == LogicArray(expected_value, Range(7,'downto',0))\
        and LogicArray(dut.carries_emitted.value)==LogicArray(expected_carry, Range(1,'downto',0))