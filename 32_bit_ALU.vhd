---------------------------
-- Author : Perceptronium
-- Date : 23-11-2020
---------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ALU is
    port(
            Clk : in std_logic;
            Opcode : in std_logic_vector(3 downto 0);
            input_cond : in std_logic_vector(3 downto 0);
            output_cond : out std_logic_vector(3 downto 0);
            A_bus : in std_logic_vector(31 downto 0);
            Barrel_Shifter_input : in std_logic_vector(31 downto 0);
            ALU_bus : out std_logic_vector(31 downto 0)
        );
end ALU;

-- Opcodes :
-- 0000 AND
-- 0001 EOR
-- 0010 SUB
-- 0011 RSB
-- 0100 ADD
-- 0101 ADC
-- 0110 SBC
-- 0111 RSC
-- 1000 TST
-- 1001 TEQ
-- 1010 CMP
-- 1011 CMN
-- 1100 ORR
-- 1101 MOV
-- 1110 BIC
-- 1111 MVN

architecture archi of ALU is

-- input signals
signal s_OPCODE : std_logic_vector(3 downto 0) := Opcode; -- This will hold opcode to be executed
signal s_RN : std_logic_vector(31 downto 0) := A_bus; -- This will hold operand 1
signal s_OPERAND_2 : std_logic_vector(31 downto 0) := Barrel_Shifter_input; -- This will hold operand 2
signal s_OVERFLOW_in : std_logic := input_cond(0); -- This will hold incomming overflow flag
signal s_CARRY_in : std_logic := input_cond(1); -- This will hold incomming carry from barrel shifter
signal s_ZERO_in : std_logic := input_cond(2); -- This will hold incomming zero flag
signal s_NEGATIVE_in : std_logic := input_cond(3); -- This will hold incomming negative flag

-- output signals
signal s_OVERFLOW_out : std_logic;
signal s_CARRY_out : std_logic;
signal s_ZERO_out : std_logic;
signal s_NEGATIVE_out : std_logic;
signal s_RD : std_logic_vector(31 downto 0);

-- misc
signal s_isWritten : integer;
signal s_temp : std_logic_vector(32 downto 0);

begin

processing: process(Clk)
begin

s_isWritten <= 1;
s_temp <= (others => '0');
if rising_edge(Clk) then

        if s_OPCODE = "0000" then -- AND
            s_RD <= s_RN and s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;
            
        elsif s_OPCODE = "0001" then -- XOR
            s_RD <= s_RN xor s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;
            
        elsif s_OPCODE = "0010" then -- SUB
            s_temp <= s_RN - s_OPERAND_2;
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);

        elsif s_OPCODE = "0011" then -- RSB
            s_temp <= s_OPERAND_2 - s_RN; 
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);           

        elsif s_OPCODE = "0100" then -- ADD
            s_temp <= s_RN + s_OPERAND_2;
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);
                  
        elsif s_OPCODE = "0101" then -- ADC
            s_temp <= s_RN + s_OPERAND_2 + s_CARRY_in;
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);

        elsif s_OPCODE = "0110" then -- SBC
            s_temp <= s_RN - s_OPERAND_2 + s_CARRY_in - 1;
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);
            
        elsif s_OPCODE = "0111" then -- RSC
            s_temp <= s_OPERAND_2 - s_RN + s_CARRY_in - 1;
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);
                
        elsif s_OPCODE = "1000" then -- TST
            s_RD <= s_RN and s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;
            s_isWritten <= 0;
                
        elsif s_OPCODE = "1001" then -- TEQ
            s_RD <= s_RN xor s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;
            s_isWritten <= 0;

        elsif s_OPCODE = "1010" then -- CMP
            s_temp <= s_RN - s_OPERAND_2;
            s_isWritten <= 0;
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);

        elsif s_OPCODE = "1011" then -- CMN
            s_temp <= s_RN + s_OPERAND_2;
            s_isWritten <= 0;
            s_CARRY_out <= s_temp(32);
            s_OVERFLOW_out <= s_temp(32);
            s_RD <= s_temp(31 downto 0);

        elsif s_OPCODE = "1100" then -- ORR
            s_RD <= s_RN or s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;

        elsif s_OPCODE = "1101" then -- MOV
            s_RD <= s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;
                
        elsif s_OPCODE = "1110" then -- BIC
            s_RD <= s_RN and not s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;
                
        else -- 1111 MVN
            s_RD <= not s_OPERAND_2;
            s_CARRY_out <= s_CARRY_in;          
        end if;

-- Let's now set the ouputs
if s_isWritten = 1 then
    ALU_bus <= s_RD;
end if;

output_cond(3) <= s_NEGATIVE_out;
output_cond(2) <= s_ZERO_out;
output_cond(1) <= s_CARRY_out;
output_cond(0) <= s_OVERFLOW_out;
        
end if;        
end process;
end archi;