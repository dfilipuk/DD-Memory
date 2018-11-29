library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Hamming7_4 is
	port(
		CLK: in std_logic;
		WR: in std_logic;
		AB: in std_logic_vector(1 downto 0);
		DB: inout std_logic_vector(3 downto 0);
		S: out std_logic_vector(2 downto 0);
		CLKram: out std_logic;
		WRram: out std_logic;
		ABram: out std_logic_vector(1 downto 0);
		DBram: inout std_logic_vector(3 downto 0)
	);
end Hamming7_4;

architecture Beh of Hamming7_4 is
	subtype CHECK_WORD is std_logic_vector(2 downto 0);
	type TCHECK_RAM is array (0 to 3) of CHECK_WORD;
	
	signal sCheckRam: TCHECK_RAM;
	signal address: integer range 0 to 3;
	signal check: std_logic_vector(2 downto 0);
begin
	address<=CONV_INTEGER(AB);

	WRP: process(WR, CLK, address, DB, check)
	begin
		if WR = '0' then
			if rising_edge(CLK) then
				DBram<=DB;	
				sCheckRam(address)<=check;
			end if;
		else
			DBram<=(others => 'Z');
		end if;
	end process;
	
	RDP: process(WR, address, DBram)
	begin
		if WR = '1' then
			DB<=DBram;
		else
			DB<=(others => 'Z');
		end if;
	end process;
	
	UPDS: process(WR, sCheckRam, address, DB, DBram)
		variable s1, s2, s3: std_logic;
	begin
		if WR = '0' then
			s1 := DB(0) xor DB(1) xor DB(2);
			s2 := DB(1) xor DB(2) xor DB(3);
			s3 := DB(0) xor DB(1) xor DB(3);
		elsif WR = '1' then
			s1 := DBram(0) xor DBram(1) xor DBram(2) xor sCheckRam(address)(0);
			s2 := DBram(1) xor DBram(2) xor DBram(3) xor sCheckRam(address)(1);
			s3 := DBram(0) xor DBram(1) xor DBram(3) xor sCheckRam(address)(2);
		end if;
		check<=s3 & s2 & s1;
	end process;
	
	CLKram<=CLK;
	WRram<=WR;
	ABram<=AB;
	S<=check;
end Beh;

