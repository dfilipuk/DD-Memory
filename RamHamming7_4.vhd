library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RamHamming7_4 is
	port(
		CLK: in std_logic;
		WR: in std_logic;
		AB: in std_logic_vector(1 downto 0);
		DB: inout std_logic_vector(3 downto 0);
		S: out std_logic_vector(2 downto 0)
	);
end RamHamming7_4;

architecture Struct of RamHamming7_4 is
	component Hamming7_4 is
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
	end component;
	
	component RAM is
		generic(
			AB_size: integer;
			DB_size: integer
		);
		
		port(
			CLK: in std_logic;
			WR: in std_logic;
			AB: in std_logic_vector(AB_size-1 downto 0);
			DB: inout std_logic_vector(DB_size-1 downto 0)
		);
	end component;
	
	constant address_size: integer := 2;
	constant data_size: integer := 4;
	
	signal CLKram, WRram: std_logic;
	signal ABram: std_logic_vector(address_size-1 downto 0);
	signal DBram: std_logic_vector(data_size-1 downto 0);
begin
	U1: Hamming7_4	port map (
										CLK => CLK,
										WR => WR,
										AB => AB,
										DB => DB,
										S => S,
										CLKram => CLKram,
										WRram => WRram,
										ABram => ABram,
										DBram => DBram
									);
	
	U2: RAM	generic map (AB_size => address_size, DB_size => data_size)
				port map (
								CLK => CLKram,
								WR => WRram,
								AB => ABram,
								DB => DBram
							);
end Struct;

