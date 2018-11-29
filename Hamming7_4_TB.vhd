library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hamming7_4_TB is
end Hamming7_4_TB;

architecture TB of Hamming7_4_TB is
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
	
	constant clock_period: time := 10ns;
	constant address_size: integer := 2;
	constant data_size: integer := 4;
	constant check_size: integer := 3;
	constant tests_count: integer := 4;
	
	type DATA_ARRAY is array (0 to tests_count-1) of std_logic_vector(data_size-1 downto 0);
	type ADDRESS_ARRAY is array (0 to tests_count-1) of std_logic_vector(address_size-1 downto 0);
	
	constant writeData: DATA_ARRAY := ("0010", "0011", "0100", "0101");
	constant readData: DATA_ARRAY := ("0011", "0001", "0000", "1101");
	constant address: ADDRESS_ARRAY := ("00", "01", "10", "11");
	
	signal CLK: std_logic := '0';
	signal WR: std_logic;
	signal AB: std_logic_vector(address_size-1 downto 0);
	signal DB: std_logic_vector(data_size-1 downto 0);
	signal S: std_logic_vector(check_size-1 downto 0);
	signal CLKram: std_logic;
	signal WRram: std_logic;
	signal ABram: std_logic_vector(address_size-1 downto 0);
	signal DBram: std_logic_vector(data_size-1 downto 0);
begin
	U1: Hamming7_4	port map(
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
	Main: process
	begin
		DBram<=(others => 'Z');
		WR<='0';
		for i in 0 to tests_count-1 loop
			DB<=writeData(i);
			AB<=address(i);
			wait for clock_period;
		end loop;
		
		DB<=(others => 'Z');
		WR<='1';
		for i in 0 to tests_count-1 loop
			DBram<=readData(i);
			AB<=address(i);
			wait for clock_period;
		end loop;
	end process;

	CLK<=not CLK after clock_period / 2;
end TB;

