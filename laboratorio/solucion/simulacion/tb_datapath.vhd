library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_datapath is
end tb_datapath;

architecture test of tb_datapath is

	signal clock   : std_logic := '0';
	signal wrinit  : std_logic := '0';
	signal control : std_logic_vector(2 downto 0) := "000";
	signal i, j    : std_logic_vector(2 downto 0) := "000";
	signal datain  : std_logic_vector(3 downto 0) := "0000";
	signal radd    : std_logic_vector(2 downto 0) := "000";
	signal dataout : std_logic_vector(3 downto 0);

	constant CLK_PERIOD : time := 12 ns;

begin

	-- Instancia del datapath
	uut: entity work.datapath
	port map (
		clock   => clock,
		wrinit  => wrinit,
		control => control,
		i       => i,
		j       => j,
		datain  => datain,
		radd    => radd,
		dataout => dataout
	);

	-- Generador de reloj
	clock <= not clock after CLK_PERIOD / 2;

	-- Proceso de estimulos
	process
	begin
		-- =============================================
		-- PASO 1: Borrado sincrono (control = "001")
		-- =============================================
		control <= "001";
		wait for CLK_PERIOD;
		control <= "000";
		wait for CLK_PERIOD;

		-- =============================================
		-- PASO 2: Escribir valores en los 8 registros
		--   R0=5, R1=3, R2=7, R3=1, R4=6, R5=2, R6=8(=0), R7=4
		--   Nota: 4 bits, rango 0-15, usamos valores 1-7 y 4
		-- =============================================
		control <= "010";
		wrinit  <= '1';

		-- R0 = 5
		radd <= "000"; datain <= "0101";
		wait for CLK_PERIOD;

		-- R1 = 3
		radd <= "001"; datain <= "0011";
		wait for CLK_PERIOD;

		-- R2 = 7
		radd <= "010"; datain <= "0111";
		wait for CLK_PERIOD;

		-- R3 = 1
		radd <= "011"; datain <= "0001";
		wait for CLK_PERIOD;

		-- R4 = 6
		radd <= "100"; datain <= "0110";
		wait for CLK_PERIOD;

		-- R5 = 2
		radd <= "101"; datain <= "0010";
		wait for CLK_PERIOD;

		-- R6 = 8
		radd <= "110"; datain <= "1000";
		wait for CLK_PERIOD;

		-- R7 = 4
		radd <= "111"; datain <= "0100";
		wait for CLK_PERIOD;

		wrinit  <= '0';
		control <= "000";
		wait for CLK_PERIOD;

		-- =============================================
		-- PASO 3: Leer registros para verificar escritura
		-- =============================================
		radd <= "000"; wait for CLK_PERIOD;  -- dataout debe ser 5
		radd <= "001"; wait for CLK_PERIOD;  -- dataout debe ser 3
		radd <= "010"; wait for CLK_PERIOD;  -- dataout debe ser 7
		radd <= "011"; wait for CLK_PERIOD;  -- dataout debe ser 1

		-- =============================================
		-- PASO 4: Comparar e intercambiar (control = "100")
		--   R0=5 vs R1=3 => 5>3, deben intercambiarse
		-- =============================================
		i <= "000"; j <= "001";
		control <= "100";
		wait for CLK_PERIOD;
		control <= "000";
		wait for CLK_PERIOD;

		-- Verificar: R0 ahora debe ser 3, R1 debe ser 5
		radd <= "000"; wait for CLK_PERIOD;  -- dataout debe ser 3
		radd <= "001"; wait for CLK_PERIOD;  -- dataout debe ser 5

		-- =============================================
		-- PASO 5: Comparar sin intercambio (R0=3 vs R2=7 => 3<7, no swap)
		-- =============================================
		i <= "000"; j <= "010";
		control <= "100";
		wait for CLK_PERIOD;
		control <= "000";
		wait for CLK_PERIOD;

		-- Verificar: R0 sigue siendo 3, R2 sigue siendo 7
		radd <= "000"; wait for CLK_PERIOD;  -- dataout debe ser 3
		radd <= "010"; wait for CLK_PERIOD;  -- dataout debe ser 7

		wait for CLK_PERIOD * 5;
		assert false report "Simulacion de datapath finalizada" severity note;
		wait;
	end process;

end test;
