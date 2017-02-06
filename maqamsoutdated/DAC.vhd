----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:41:56 02/28/2015 
-- Design Name: 
-- Module Name:    DAC - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DAC is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  delay : in integer;
           din : in  STD_LOGIC_VECTOR (11 downto 0);
           SPI_MISO : in  STD_LOGIC;
			  addr : out STD_LOGIC_VECTOR (9 downto 0);
           SPI_MOSI : out  STD_LOGIC;
           SPI_SCK : out  STD_LOGIC;
           DAC_CS : out  STD_LOGIC;
           DAC_CLR : out  STD_LOGIC);
end DAC;

architecture Behavioral of DAC is

type state_type is (idle, func, write);
signal state : state_type := idle;

signal data : STD_LOGIC_VECTOR(11 downto 0);
signal cnt : integer := 0;
signal newclk : STD_LOGIC := '0';
signal addr1 : STD_LOGIC_VECTOR (9 downto 0) := (others=>'0');
signal delay1 : integer := 0;
signal clkdiv : integer range 0 to 100000;
signal risingedge : std_logic := '1';

begin

DAC_CLR <= '1';
SPI_SCK <= newclk;
--SPI_SCK <= clk;

clock_divider: process(clk, reset)
begin
	if(reset = '1') then
		null;
	elsif rising_edge(clk) then
		if(clkdiv = 1) then
			risingedge <= risingedge xor '1';
			newclk <= newclk xor '1';
			clkdiv <= 0;
		else
			clkdiv <= clkdiv + 1;
		end if;
	end if;
end process clock_divider;
	
process(clk, reset)
begin
	if(reset = '1') then
		null;
		state <= idle;
	elsif rising_edge(clk) then
	--if(clkdiv = 1 and risingedge = '1') then
		case state is
			when idle =>
				DAC_CS <= '1';
				if(cnt < delay1) then
					cnt <= cnt + 1;
					state <= idle;
				else
					cnt <= 0;
					state <= func;
				end if;
			when func =>
				DAC_CS <= '1';
				cnt <= 0;
				data <= din;
				if(addr1 < 999) then
					addr1 <= addr1+10;
				else
					addr1<="0000000000";
				end if;
				state <= write;
			when write =>
				DAC_CS <= '0';				
				if(cnt < 10) then
					cnt <= cnt + 1;
					SPI_MOSI <= '0';
					state <= write;
				elsif(cnt < 12) then
					cnt <= cnt + 1;
					SPI_MOSI <= '1';
					state <= write;
				elsif(cnt < 16) then
					cnt <= cnt + 1;
					SPI_MOSI <= '1';
					state <= write;	
				elsif(cnt < 28) then
					cnt <= cnt + 1;
					SPI_MOSI <= data(27-cnt);
					state <= write;
				elsif(cnt < 32) then
					cnt <= cnt + 1;
					SPI_MOSI <= '0';
					state <= write;
				elsif(cnt = 32) then
					cnt <= 0;
					state <= idle;
					delay1 <= delay;
				end if;
		end case;
	  --end if;
	end if;
end process;

addr <= addr1;

end Behavioral;

