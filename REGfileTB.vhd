library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGfileTB is
end REGfileTB;

architecture TB of REGfileTB is
	component REGfile is
		generic(
			INITREG: std_logic_vector;
			a: integer
		);
		
		port(
			INIT: in std_logic;
			WDP: in std_logic_vector(INITREG'range);
			WA: in std_logic_vector(a-1 downto 0);
			RA: in std_logic_vector(a-1 downto 0);
			WE: in std_logic;
			RDP: out std_logic_vector(INITREG'range)
		);
	end component;
	
	constant clock_period: time := 10ns;
	constant initreg: std_logic_vector := "0000";
	constant address_size: integer := 2;
	constant tests_count: integer := 4;
	
	type DATA_ARRAY is array (0 to tests_count-1) of std_logic_vector(initreg'range);
	type ADDRESS_ARRAY is array (0 to tests_count-1) of std_logic_vector(address_size-1 downto 0);
	
	constant data: DATA_ARRAY := ("0001", "0010", "0011", "0100");
	constant address: ADDRESS_ARRAY := ("00", "01", "10", "11");	
	
	signal write_address: std_logic_vector(address_size-1 downto 0);
	signal read_address: std_logic_vector(address_size-1 downto 0);
	signal write_data: std_logic_vector(initreg'range);
	signal read_data: std_logic_vector(initreg'range);
	signal CLK: std_logic := '0';
	signal init: std_logic := '0';
begin
	U1: REGfile generic map (INITREG => initreg, a => address_size)
					port map (
									INIT => init, 
									WDP => write_data, 
									WA => write_address, 
									RA => read_address,
									WE => CLK,
									RDP => read_data
								);
								
	WR: process
	begin
		init<='1';
		wait for clock_period;
		init<='0';
		
		for i in 0 to tests_count-1 loop
			write_address<=address(i);
			write_data<=data(i);
			wait for clock_period;
		end loop;
	end process;
	
	RD: process
	begin
		wait for clock_period;
		
		for i in 0 to tests_count-1 loop
			read_address<=address(i);
			wait for clock_period;
		end loop;
	end process;
	
	CLK<=not CLK after clock_period / 2;
end TB;

