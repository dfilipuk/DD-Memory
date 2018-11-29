library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity REGfile is
	generic(
		INITREG: std_logic_vector := "0000";
		a: integer := 2
	);
	
	port(
		INIT: in std_logic;
		WDP: in std_logic_vector(INITREG'range);
		WA: in std_logic_vector(a-1 downto 0);
		RA: in std_logic_vector(a-1 downto 0);
		WE: in std_logic;
		RDP: out std_logic_vector(INITREG'range)
	);
end REGfile;

architecture Beh of REGfile is
	component REGn is
		generic(
			INITREG: std_logic_vector
		);
		
		port(
			INIT: in std_logic;
			CLK: in std_logic;
			EN: in std_logic;
			OE: in std_logic;
			Din: in std_logic_vector(INITREG'range);
			Dout: out std_logic_vector(INITREG'range)
		);
	end component;
	
	signal wen: std_logic_vector(2**a-1 downto 0);
	signal ren: std_logic_vector(2**a-1 downto 0);
	signal dat: std_logic_vector(INITREG'range);
begin
	WAD: process(WA)
	begin
		for i in 0 to 2**a-1 loop
			if i = CONV_INTEGER(WA) then
				wen(i)<='1';
			else
				wen(i)<='0';
			end if;
		end loop;
	end process;

	RAD: process(RA)
	begin
		for i in 0 to 2**a-1 loop
			if i = CONV_INTEGER(RA) then
				ren(i)<='1';
			else
				ren(i)<='0';
			end if;
		end loop;
	end process;
	
	REGi: for i in 2**a-1 downto 0 generate
		REGi: REGn generic map (INITREG => INITREG)
					  port map (INIT => INIT, CLK => WE, EN => wen(i), OE => ren(i), Din => WDP, Dout => dat);
	end generate;
	
	RDP<=dat;
end Beh;

