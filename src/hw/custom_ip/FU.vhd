library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FU is
    port (
        A_1 : in  std_logic_vector(31 downto 0);  
        B_1 : in  std_logic_vector(31 downto 0);  
        A_2 : in  std_logic_vector(31 downto 0);  
        B_2 : in  std_logic_vector(31 downto 0);  
        A_3 : in  std_logic_vector(31 downto 0);  
        B_3 : in  std_logic_vector(31 downto 0);  
        A_4 : in  std_logic_vector(31 downto 0);  
        B_4 : in  std_logic_vector(31 downto 0);  
        ALU_Sel : in  std_logic_vector(31 downto 0);   
        ALU_Out_0  : out std_logic_vector(31 downto 0);
        ALU_Out_1  : out std_logic_vector(31 downto 0);
        ALU_Out_2  : out std_logic_vector(31 downto 0);
        ALU_Out_3  : out std_logic_vector(31 downto 0)
    );
end FU;

architecture Behavioral of FU is
    component ALU
        port (
            A, B     : in  std_logic_vector(31 downto 0);
            ALU_Sel  : in  std_logic_vector(7 downto 0);
            ALU_Out  : out  std_logic_vector(31 downto 0)
        );
    end component; 

begin
    ALU_inst_0 : ALU
        port map (
            A => A_1,
            B => B_1,
            ALU_Sel => ALU_Sel(7 downto 0),
            ALU_Out => ALU_Out_0
        );

    ALU_inst_1 : ALU
        port map (
            A => A_2,
            B => B_2,
            ALU_Sel => ALU_Sel(7 downto 0),
            ALU_Out => ALU_Out_1
        );

    ALU_inst_2 : ALU
        port map (
            A => A_3,
            B => B_3,
            ALU_Sel => ALU_Sel(7 downto 0),
            ALU_Out => ALU_Out_2
        );

    ALU_inst_3 : ALU
        port map (
            A => A_4,
            B => B_4,
            ALU_Sel => ALU_Sel(7 downto 0),
            ALU_Out => ALU_Out_3
        );

end Behavioral;
