library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sorter is
end tb_sorter;

architecture test of tb_sorter is
	signal clock   : std_logic := '0';
	signal resetn  : std_logic := '0';
	signal go      : std_logic := '0';
	signal wrinit  : std_logic := '0';
	signal datain  : std_logic_vector(3 downto 0) := "0000";
	signal radd    : std_logic_vector(2 downto 0) := "000";
	signal dataout : std_logic_vector(3 downto 0);
	signal done    : std_logic;
	constant CLK_PERIOD : time := 12 ns;
begin

	uut: entity work.sorter
	port map (
		clock => clock, resetn => resetn, go => go, wrinit => wrinit,
		datain => datain, radd => radd, dataout => dataout, done => done
	);

	clock <= not clock after CLK_PERIOD / 2;

	process
	begin
		-- Reset asincrono
		resetn <= '0';
		wait for CLK_PERIOD * 2;
		resetn <= '1';

		-- Activar go='1' para modo inicializacion
		go <= '1';
		wait for CLK_PERIOD * 2;

		-- Escribir 8 valores desordenados: 5,3,7,1,6,2,8,4
		wrinit <= '1';
		radd <= "000"; datain <= "0101"; wait for CLK_PERIOD; -- R0=5
		radd <= "001"; datain <= "0011"; wait for CLK_PERIOD; -- R1=3
		radd <= "010"; datain <= "0111"; wait for CLK_PERIOD; -- R2=7
		radd <= "011"; datain <= "0001"; wait for CLK_PERIOD; -- R3=1
		radd <= "100"; datain <= "0110"; wait for CLK_PERIOD; -- R4=6
		radd <= "101"; datain <= "0010"; wait for CLK_PERIOD; -- R5=2
		radd <= "110"; datain <= "1000"; wait for CLK_PERIOD; -- R6=8
		radd <= "111"; datain <= "0100"; wait for CLK_PERIOD; -- R7=4
		wrinit <= '0';

		-- go='0' para iniciar ordenamiento
		go <= '0';

		-- Esperar a que done='1'
		wait until done = '1';
		wait for CLK_PERIOD * 2;

		-- Leer registros ordenados: deberian ser 1,2,3,4,5,6,7,8
		radd <= "000"; wait for CLK_PERIOD; -- R0=1
		radd <= "001"; wait for CLK_PERIOD; -- R1=2
		radd <= "010"; wait for CLK_PERIOD; -- R2=3
		radd <= "011"; wait for CLK_PERIOD; -- R3=4
		radd <= "100"; wait for CLK_PERIOD; -- R4=5
		radd <= "101"; wait for CLK_PERIOD; -- R5=6
		radd <= "110"; wait for CLK_PERIOD; -- R6=7
		radd <= "111"; wait for CLK_PERIOD; -- R7=8

		wait for CLK_PERIOD * 5;
		assert false report "Simulacion del sorter completa" severity note;
		wait;
	end process;
end test;
