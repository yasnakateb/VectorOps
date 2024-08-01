library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FUIP_v1_0_S00_AXI is
	generic (
		C_S_AXI_DATA_WIDTH : integer := 32;
		C_S_AXI_ADDR_WIDTH : integer := 6
	);
	port (
		A_1 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		B_1 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		A_2 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		B_2 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		A_3 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		B_3 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		A_4 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		B_4 : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		ALU_Sel : out  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		ALU_Out_0 : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		ALU_Out_1 : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		ALU_Out_2 : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		ALU_Out_3 : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN : in std_logic;
		S_AXI_AWADDR : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT : in std_logic_vector(2 downto 0);
		S_AXI_AWVALID : in std_logic;
		S_AXI_AWREADY : out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID : in std_logic;
		S_AXI_WREADY : out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID : out std_logic;
		S_AXI_BREADY : in std_logic;
		S_AXI_ARADDR : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT : in std_logic_vector(2 downto 0);
		S_AXI_ARVALID : in std_logic;
		S_AXI_ARREADY : out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID : out std_logic;
		S_AXI_RREADY : in std_logic
	);
end FUIP_v1_0_S00_AXI;

architecture arch_imp of FUIP_v1_0_S00_AXI is

	signal axi_awaddr : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready : std_logic;
	signal axi_wready : std_logic;
	signal axi_bresp : std_logic_vector(1 downto 0);
	signal axi_bvalid : std_logic;
	signal axi_araddr : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready : std_logic;
	signal axi_rdata : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp : std_logic_vector(1 downto 0);
	signal axi_rvalid : std_logic;

	constant ADDR_LSB : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 3;
	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg8	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg9	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg10 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg11 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg12 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg13 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg14 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index : integer;
	signal aw_en : std_logic;

begin

	S_AXI_AWREADY <= axi_awready;
	S_AXI_WREADY <= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID <= axi_bvalid;
	S_AXI_ARREADY <= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID <= axi_rvalid;

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      aw_en <= '1';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	           axi_awready <= '1';
	           aw_en <= '0';
	        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
	           aw_en <= '1';
	           axi_awready <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      slv_reg0 <= (others => '0');
	      slv_reg1 <= (others => '0');
	      slv_reg2 <= (others => '0');
	      slv_reg3 <= (others => '0');
	      slv_reg4 <= (others => '0');
	      slv_reg5 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	      slv_reg8 <= (others => '0');
	      slv_reg9 <= (others => '0');
	      slv_reg10 <= (others => '0');
	      slv_reg11 <= (others => '0');
	      slv_reg12 <= (others => '0');
	      slv_reg13 <= (others => '0');
	      slv_reg14 <= (others => '0');
	    else
	    
	    slv_reg9 <= ALU_Out_0;
	    slv_reg10 <= ALU_Out_1;
	    slv_reg11 <= ALU_Out_2;
	    slv_reg12 <= ALU_Out_3;
	    
		loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
		if (slv_reg_wren = '1') then
		case loc_addr is
			when b"0000" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"0001" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"0010" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"0011" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"0100" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"0101" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"0110" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"0111" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"1000" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"1001" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"1010" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"1011" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"1100" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"1101" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
			when b"1110" =>
			for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
				if ( S_AXI_WSTRB(byte_index) = '1' ) then
				slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
				end if;
			end loop;
	          when others =>
	            slv_reg0 <= slv_reg0;
	            slv_reg1 <= slv_reg1;
	            slv_reg2 <= slv_reg2;
	            slv_reg3 <= slv_reg3;
	            slv_reg4 <= slv_reg4;
	            slv_reg5 <= slv_reg5;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	            slv_reg8 <= slv_reg8;
	            slv_reg9 <= slv_reg9;
	            slv_reg10 <= slv_reg10;
	            slv_reg11 <= slv_reg11;
	            slv_reg12 <= slv_reg12;
	            slv_reg13 <= slv_reg13;
	            slv_reg14 <= slv_reg14;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   
	        axi_bvalid <= '0';                                
	      end if;
	    end if;
	  end if;                   
	end process; 


	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        axi_arready <= '1';
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"0000" =>
	        reg_data_out <= slv_reg0;
	      when b"0001" =>
	        reg_data_out <= slv_reg1;
	      when b"0010" =>
	        reg_data_out <= slv_reg2;
	      when b"0011" =>
	        reg_data_out <= slv_reg3;
	      when b"0100" =>
	        reg_data_out <= slv_reg4;
	      when b"0101" =>
	        reg_data_out <= slv_reg5;
	      when b"0110" =>
	        reg_data_out <= slv_reg6;
	      when b"0111" =>
	        reg_data_out <= slv_reg7;
	      when b"1000" =>
	        reg_data_out <= slv_reg8;
	      when b"1001" =>
	        reg_data_out <= slv_reg9;
	      when b"1010" =>
	        reg_data_out <= slv_reg10;
	      when b"1011" =>
	        reg_data_out <= slv_reg11;
	      when b"1100" =>
	        reg_data_out <= slv_reg12;
	      when b"1101" =>
	        reg_data_out <= slv_reg13;
	      when b"1110" =>
	        reg_data_out <= slv_reg14;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	end process; 

	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	          axi_rdata <= reg_data_out;     
	      end if;   
	    end if;
	  end if;
	end process;

        A_1 <= slv_reg0 (C_S_AXI_DATA_WIDTH-1 downto 0);
	B_1 <= slv_reg1 (C_S_AXI_DATA_WIDTH-1 downto 0);
	A_2 <= slv_reg2 (C_S_AXI_DATA_WIDTH-1 downto 0);
	B_2 <= slv_reg3 (C_S_AXI_DATA_WIDTH-1 downto 0);
	A_3 <= slv_reg4 (C_S_AXI_DATA_WIDTH-1 downto 0);
	B_3 <= slv_reg5 (C_S_AXI_DATA_WIDTH-1 downto 0);
	A_4 <= slv_reg6 (C_S_AXI_DATA_WIDTH-1 downto 0);
	B_4 <= slv_reg7 (C_S_AXI_DATA_WIDTH-1 downto 0);
	ALU_Sel <= slv_reg8 (C_S_AXI_DATA_WIDTH-1 downto 0);


end arch_imp;
