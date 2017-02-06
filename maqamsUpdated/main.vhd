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
use IEEE.STD_LOGIC_SIGNED.ALL;

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
			  led : out STD_LOGIC_VECTOR(7 downto 0);
			  SW : in STD_LOGIC_VECTOR(3 downto 0));
end main;

architecture Behavioral of main is

constant size			: integer := 7;
type delarray is array(0 to size) of integer;
--constant del			: delarray := (534,502,472,444,416,392,368,344,324,304,284,268,252,234,220);
constant del			: delarray := (534,472,444,392,344,324,284,252);
--constant del			: delarray := (534,486,444,392,356,324,284,252);	--husseini
--constant del			: delarray := (817,746,681,603,534,486,444,392,356,324,284,252);	--husseini
signal mem_data		: STD_LOGIC_VECTOR (11 downto 0);
signal mem_addr  		: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
signal dac_data	   : STD_LOGIC_VECTOR(11 downto 0);
signal clk_25     	: STD_LOGIC;
signal mclk		     	: STD_LOGIC;
signal counter			: integer := 0;
signal delay			: integer;

signal count : integer := 0;
signal index : integer := 0;
signal slow_clock : STD_LOGIC := '0';
signal offset : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal direction : STD_LOGIC := '0';

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

component lfsr is
    Port ( 
		clk : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		lfsr_out : out  STD_LOGIC_VECTOR (1 downto 0);
		dir : out  STD_LOGIC);
end component;

begin

delay <= del(index);

process(clk)
variable off_temp : integer;
begin
if rising_edge(clk) then
	if count =  16000000 then
		count <= 0;
		slow_clock <= not slow_clock;
		off_temp := conv_integer(offset);
		if direction = '1' then
			if index - off_temp < 0 then
				index <= 0;
			else
				index <= index - off_temp;
			end if;			
		else
			if index + off_temp > size then
				index <= size;
			else
				index <= index + off_temp;
			end if;					
		end if;
	else
		count <= count + 1;
	end if;
end if;
end process;

process (clk)
begin
	if rising_edge(clk) then
		clk_25 <= not clk_25;
	end if;
end process;

lfsr_1 : lfsr
	port map (
		clk => slow_clock,
      reset => reset,
      lfsr_out => offset,
      dir => direction
		);

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

led <= "00000" & direction & offset;

--delay <= 236 when SW = "0000" else
--			504 when SW = "0001" else
--			472 when SW = "0011" else
--			444 when SW = "0010" else
--			416 when SW = "0110" else
--			392 when SW = "0111" else
--			368 when SW = "0101" else
--			344 when SW = "0100" else
--			324 when SW = "1100" else
--			304 when SW = "1101" else
--			284 when SW = "1111" else
--			268 when SW = "1110" else
--			252 when SW = "1010" else
--			234 when SW = "1011" else
--			220 when SW = "1001" else
--			250;

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

