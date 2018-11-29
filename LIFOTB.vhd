library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LIFOTB is
end LIFOTB;

architecture TB of LIFOTB is
	component LIFO is
		generic(
			AB_size: integer;
			DB_size: integer
		);
		
		port(
			CLK: in std_logic;
			WR: in std_logic;
			DB: inout std_logic_vector(DB_size-1 downto 0)
		);
	end component;
	
	constant clock_period: time := 10ns;
	constant address_size: integer := 2;
	constant data_size: integer := 4;
	constant tests_count: integer := 5;
	
	type DATA_ARRAY is array (0 to tests_count-1) of std_logic_vector(data_size-1 downto 0);
	
	constant data: DATA_ARRAY := ("0001", "0010", "0011", "0100", "0101");
	
	signal CLK: std_logic := '0';
	signal WR: std_logic;
	signal d: std_logic_vector (data_size-1 downto 0);
begin
	U1: LIFO	generic map (AB_size => address_size, DB_size => data_size)
				port map (
								CLK => CLK,
								WR => WR,
								DB => d
							); 

	Main: process
	begin
		WR<='0';
		for i in 0 to tests_count-1 loop
			d<=data(i);
			wait for clock_period;
		end loop;
		
		d<=(others => 'Z');
		WR<='1';
		for i in 0 to tests_count-1 loop
			wait for clock_period;
		end loop;
	end process;

	CLK<=not CLK after clock_period / 2;
end TB;

