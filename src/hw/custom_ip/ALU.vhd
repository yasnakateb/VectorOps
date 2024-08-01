library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        A : in std_logic_vector(31 downto 0);  
        B : in std_logic_vector(31 downto 0);  
        ALU_Sel : in std_logic_vector(7 downto 0); 
        ALU_Out : out std_logic_vector(31 downto 0) 
    );
end ALU; 

architecture Behavioral of ALU is
    signal ALU_Result : std_logic_vector(31 downto 0);
        begin
          process(A, B, ALU_Sel)
          begin
              case ALU_Sel is
                  when "00000000" => -- Addition
                    ALU_Result <= std_logic_vector(unsigned(A) + unsigned(B)); 
                  when "00000001" => -- Subtraction
                    ALU_Result <= std_logic_vector(unsigned(A) - unsigned(B));
                  when "00000010" => -- Multiplication
                    ALU_Result <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) * to_integer(unsigned(B)), 32));
                  when "00000011" => -- Logical OR
                    ALU_Result <= A or B;
                  when others => 
                    ALU_Result <= (others => '0'); -- Default case to handle undefined states
              end case;
          end process;
          ALU_Out <= ALU_Result; -- ALU out
end Behavioral;
