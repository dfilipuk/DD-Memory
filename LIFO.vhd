library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LIFO is
	generic(
		AB_size: integer := 2;
		DB_size: integer := 8
	);
	
	port(
		CLK: in std_logic;
		WR: in std_logic;
		DB: inout std_logic_vector(DB_size-1 downto 0)
	);
end LIFO;

architecture Beh of LIFO is
	constant min_address: integer := 0;
	constant max_address: integer := 2**AB_size-1;
	
	subtype WORD is std_logic_vector(DB_size-1 downto 0);
	type TRAM is array (min_address to max_address) of WORD;
	
	signal sRAM: TRAM;
	signal read_address: integer := min_address-1;
	signal write_address: integer := min_address;
begin
	WRP: process(WR, CLK, DB)
	begin
		if WR = '0' then
			if write_address <= max_address then
				if rising_edge(CLK) then
					sRAM(write_address)<=DB;
				end if;
			end if;
		end if;
	end process;
	
	RDP: process(WR, sRAM, CLK)
	begin
		if WR = '1' then
			if read_address >= min_address then
				if rising_edge(CLK) then
					DB<=sRAM(read_address);
				end if;	
			else
				DB<=(others => 'Z');
			end if;
		else
			DB<=(others => 'Z');
		end if;
	end process;
	
	UPDADDR: process(WR, CLK)
	begin
		if rising_edge(CLK) then
			if WR = '0' then
				if write_address <= max_address then
					write_address<=write_address+1;
					read_address<=read_address+1;
				end if;
			elsif WR = '1' then
				if read_address >= min_address then
					write_address<=write_address-1;
					read_address<=read_address-1;
				end if;
			end if;
		end if;
	end process;
end Beh;
