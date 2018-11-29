library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGn is
	generic(
		INITREG: std_logic_vector := "0000"
	);
	
	port(
		INIT: in std_logic;
		CLK: in std_logic;
		EN: in std_logic;
		OE: in std_logic;
		Din: in std_logic_vector(INITREG'range);
		Dout: out std_logic_vector(INITREG'range)
	);
end REGn;

architecture Beh of REGn is
	constant NO_OUT: std_logic_vector(INITREG'range) := (others => 'Z');
	
	signal reg: std_logic_vector(INITREG'range);
begin
	Main: process(INIT, CLK, EN, Din)
	begin
		if INIT = '1' then
			reg<=INITREG;
		elsif EN = '1' then
			if rising_edge(CLK) then
				reg<=Din;
			end if;
		end if;
	end process;

	Dout<=reg when OE = '1' else NO_OUT;
end Beh;

