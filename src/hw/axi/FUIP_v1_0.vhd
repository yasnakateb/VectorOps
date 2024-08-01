library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FUIP_v1_0 is
    generic (
        C_S00_AXI_DATA_WIDTH : integer := 32;
        C_S00_AXI_ADDR_WIDTH : integer := 6
    );
    port (
        s00_axi_aclk : in std_logic;
        s00_axi_aresetn : in std_logic;
        s00_axi_awaddr : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_awprot : in std_logic_vector(2 downto 0);
        s00_axi_awvalid : in std_logic;
        s00_axi_awready : out std_logic;
        s00_axi_wdata : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_wstrb : in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        s00_axi_wvalid : in std_logic;
        s00_axi_wready : out std_logic;
        s00_axi_bresp : out std_logic_vector(1 downto 0);
        s00_axi_bvalid : out std_logic;
        s00_axi_bready : in std_logic;
        s00_axi_araddr : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_arprot : in std_logic_vector(2 downto 0);
        s00_axi_arvalid : in std_logic;
        s00_axi_arready : out std_logic;
        s00_axi_rdata : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_rresp : out std_logic_vector(1 downto 0);
        s00_axi_rvalid : out std_logic;
        s00_axi_rready : in std_logic
    );
end FUIP_v1_0;

architecture arch_imp of FUIP_v1_0 is
    component FUIP_v1_0_S00_AXI is
        generic (
            C_S_AXI_DATA_WIDTH : integer := 32;
            C_S_AXI_ADDR_WIDTH : integer := 6
        );
        port (
            A_1 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            B_1 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            A_2 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            B_2 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            A_3 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            B_3 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            A_4 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            B_4 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            ALU_Sel : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_0 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_1 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_2 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_3 : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_ACLK : in std_logic;
            S_AXI_ARESETN : in std_logic;
            S_AXI_AWADDR : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_AWPROT : in std_logic_vector(2 downto 0);
            S_AXI_AWVALID : in std_logic;
            S_AXI_AWREADY : out std_logic;
            S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            S_AXI_WVALID : in std_logic;
            S_AXI_WREADY : out std_logic;
            S_AXI_BRESP : out std_logic_vector(1 downto 0);
            S_AXI_BVALID : out std_logic;
            S_AXI_BREADY : in std_logic;
            S_AXI_ARADDR : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_ARPROT : in std_logic_vector(2 downto 0);
            S_AXI_ARVALID : in std_logic;
            S_AXI_ARREADY : out std_logic;
            S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_RRESP : out std_logic_vector(1 downto 0);
            S_AXI_RVALID : out std_logic;
            S_AXI_RREADY : in std_logic
        );
    end component FUIP_v1_0_S00_AXI;

    component FU is
        port (
            A_1 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            B_1 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            A_2 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            B_2 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            A_3 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            B_3 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            A_4 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            B_4 : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            ALU_Sel : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_0 : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_1 : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_2 : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            ALU_Out_3 : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0)
        );
    end component FU;

    signal A_1 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal B_1 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal A_2 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal B_2 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal A_3 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal B_3 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal A_4 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal B_4 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal ALU_Sel : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal ALU_Out_0 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal ALU_Out_1 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal ALU_Out_2 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal ALU_Out_3 : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);

begin
    FUIP_v1_0_S00_AXI_inst : FUIP_v1_0_S00_AXI
        generic map (
            C_S_AXI_DATA_WIDTH => C_S00_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH => C_S00_AXI_ADDR_WIDTH
        )
        port map (
            A_1 => A_1,
            B_1 => B_1,
            A_2 => A_2,
            B_2 => B_2,
            A_3 => A_3,
            B_3 => B_3,
            A_4 => A_4,
            B_4 => B_4,
            ALU_Sel => ALU_Sel,
            ALU_Out_0 => ALU_Out_0,
            ALU_Out_1 => ALU_Out_1,
            ALU_Out_2 => ALU_Out_2,
            ALU_Out_3 => ALU_Out_3,
            S_AXI_ACLK => s00_axi_aclk,
            S_AXI_ARESETN => s00_axi_aresetn,
            S_AXI_AWADDR => s00_axi_awaddr,
            S_AXI_AWPROT => s00_axi_awprot,
            S_AXI_AWVALID => s00_axi_awvalid,
            S_AXI_AWREADY => s00_axi_awready,
            S_AXI_WDATA => s00_axi_wdata,
            S_AXI_WSTRB => s00_axi_wstrb,
            S_AXI_WVALID => s00_axi_wvalid,
            S_AXI_WREADY => s00_axi_wready,
            S_AXI_BRESP => s00_axi_bresp,
            S_AXI_BVALID => s00_axi_bvalid,
            S_AXI_BREADY => s00_axi_bready,
            S_AXI_ARADDR => s00_axi_araddr,
            S_AXI_ARPROT => s00_axi_arprot,
            S_AXI_ARVALID => s00_axi_arvalid,
            S_AXI_ARREADY => s00_axi_arready,
            S_AXI_RDATA => s00_axi_rdata,
            S_AXI_RRESP => s00_axi_rresp,
            S_AXI_RVALID => s00_axi_rvalid,
            S_AXI_RREADY => s00_axi_rready
        );

    FU_IP : FU
        port map (
            A_1 => A_1,
            B_1 => B_1,
            A_2 => A_2,
            B_2 => B_2,
            A_3 => A_3,
            B_3 => B_3,
            A_4 => A_4,
            B_4 => B_4,
            ALU_Sel => ALU_Sel,
            ALU_Out_0 => ALU_Out_0,
            ALU_Out_1 => ALU_Out_1,
            ALU_Out_2 => ALU_Out_2,
            ALU_Out_3 => ALU_Out_3
        );
end arch_imp;