library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RAM is
	generic(
		AB_size: integer := 2;
		DB_size: integer := 8
	);
	
	port(
		CLK: in std_logic;
		WR: in std_logic;
		AB: in std_logic_vector(AB_size-1 downto 0);
		DB: inout std_logic_vector(DB_size-1 downto 0)
	);
end RAM;

architecture Beh of RAM is
	subtype WORD is std_logic_vector(DB_size-1 downto 0);
	type TRAM is array (0 to 2**AB_size-1) of WORD;
	
	signal sRAM: TRAM;
	signal address: integer range 0 to 2**AB_size-1;
begin
	address<=CONV_INTEGER(AB);

	WRP: process(WR, CLK, address, DB)
	begin
		if WR = '0' then
			if rising_edge(CLK) then
				sRAM(address)<=DB;
			end if;
		end if;
	end process;
	
	RDP: process(WR, address, sRAM)
	begin
		if WR = '1' then
			DB<=sRAM(address);
		else
			DB<=(others => 'Z');
		end if;
	end process;
end Beh;
