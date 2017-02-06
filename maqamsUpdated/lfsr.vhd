----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:14:16 03/19/2015 
-- Design Name: 
-- Module Name:    lfsr - Behavioral 
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

entity lfsr is
	 Generic (constant N : integer := 15);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           lfsr_out : out  STD_LOGIC_VECTOR (1 downto 0);
           dir : out  STD_LOGIC);
end lfsr;

architecture Behavioral of lfsr is

constant mask : STD_LOGIC_VECTOR(N downto 0) := "1011010000000000";
signal lfsr_temp : STD_LOGIC_VECTOR(N downto 0) := "0101010101010101";

begin

process(clk, reset)
begin
	if reset = '1' then
		lfsr_temp <= "0101010101010101";
	elsif rising_edge(clk) then
		if lfsr_temp(0) = '0' then
			lfsr_temp <= '0' & lfsr_temp(N downto 1);
		else
			lfsr_temp <= ('0' & lfsr_temp(N downto 1)) xor mask;
		end if;
	end if;
end process;

lfsr_out <= lfsr_temp(1 downto 0);
dir <= lfsr_temp(2);

end Behavioral;

