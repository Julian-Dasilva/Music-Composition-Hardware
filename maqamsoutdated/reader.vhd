----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:31:05 02/28/2015 
-- Design Name: 
-- Module Name:    reader - Behavioral 
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

entity reader is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           addr : out  STD_LOGIC_VECTOR(9 downto 0);
           din : in  STD_LOGIC_VECTOR(11 downto 0);
           dout : out  STD_LOGIC_VECTOR(11 downto 0));
end reader;

architecture Behavioral of reader is

signal addr_a : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
signal clkdiv : integer range 0 to 100000;
signal sclk : std_logic := '1';

begin
	
process (clk)
begin
if reset = '1' then
	addr_a <= (others => '0');
elsif rising_edge(clk) then	
	if addr_a = 999 then
		addr_a <= (others => '0');		
	else
		addr_a <= addr_a + 1;
	end if;
end if;
end process;

addr <= addr_a;
dout <= din;

end Behavioral;

