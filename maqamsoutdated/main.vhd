----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:20:30 02/28/2015 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           SPI_MISO : in  STD_LOGIC;
           SPI_SCK : out  STD_LOGIC;
           SPI_MOSI : out  STD_LOGIC;
           DAC_CS : out  STD_LOGIC;
           DAC_CLR : out  STD_LOGIC;
			  SW : in STD_LOGIC_VECTOR(3 downto 0));
end main;

architecture Behavioral of main is

signal mem_data		: STD_LOGIC_VECTOR (11 downto 0);
signal mem_addr  		: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
signal dac_data	   : STD_LOGIC_VECTOR(11 downto 0);
signal clk_25     	: STD_LOGIC;
signal mclk		     	: STD_LOGIC;
signal counter			: integer := 0;
signal delay			: integer;

COMPONENT mem
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

component DAC is
    Port ( 
      clk : in  STD_LOGIC;
		reset : in STD_LOGIC;
		delay : in integer;
		din  : in STD_LOGIC_VECTOR(11 downto 0);
		SPI_MISO : in STD_LOGIC;
		addr : out STD_LOGIC_VECTOR(9 downto 0);
		SPI_MOSI : out STD_LOGIC;
		SPI_SCK : out STD_LOGIC;
		DAC_CS : out STD_LOGIC;
		DAC_CLR : out STD_LOGIC
		);
end component;

begin

process (clk)
begin
	if rising_edge(clk) then
		clk_25 <= not clk_25;
	end if;
end process;

cosine : mem
  PORT MAP (
    clka => clk_25,
    addra => mem_addr,
    douta => mem_data
  );

DAC_1: DAC
    Port map ( clk      => clk_25,
					reset		=> reset,
					delay		=> delay,
					din		=> mem_data,
					SPI_MISO => SPI_MISO,
					addr 		=> mem_addr,
					SPI_MOSI => SPI_MOSI,
					SPI_SCK  => SPI_SCK,
					DAC_CS  	=> DAC_CS,
					DAC_CLR  => DAC_CLR);

delay <= 203 when SW = "0000" else
			496 when SW = "0001" else --Finished Correct B Flat strong	
			466 when SW = "0011" else --Finished correct B weak
			438 when SW = "0010" else --Finished Correct C weak
			410 when SW = "0110" else --Finished C# weak
			388 when SW = "0111" else --Finished D weak
			360 when SW = "0101" else --Finished correct E flat strong
			340 when SW = "0100" else --Finished Correct E Strong
			321 when SW = "1100" else -- brought up 3
			300 when SW = "1101" else -- Finished F sharp strong
			280 when SW = "1111" else -- Finished G strong
			260 when SW = "1110" else --brought down 8
			240 when SW = "1010" else -- brought down 12
			234 when SW = "1011" else
			220 when SW = "1001" else
			250;

--delay <= 421 when SW = "0000" else
--			395 when SW = "0001" else
--			371 when SW = "0011" else
--			348 when SW = "0010" else
--			327 when SW = "0110" else
--			307 when SW = "0111" else
--			287 when SW = "0101" else
--			269 when SW = "0100" else
--			252 when SW = "1100" else
--			236 when SW = "1101" else
--			221 when SW = "1111" else
--			207 when SW = "1110" else
--			193 when SW = "1010" else
--			181 when SW = "1011" else
--			168 when SW = "1001" else
--			157;
						
end Behavioral;

