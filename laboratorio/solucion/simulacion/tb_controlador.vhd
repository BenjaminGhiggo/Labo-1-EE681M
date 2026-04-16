library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_controlador is
end tb_controlador;

architecture test of tb_controlador is

	signal clock   : std_logic := '0';
	signal resetn  : std_logic := '0';
	signal go      : std_logic := '0';
	signal i, j    : std_logic_vector(2 downto 0);
	signal control : std_logic_vector(2 downto 0);
	signal done    : std_logic;

	constant CLK_PERIOD : time := 12 ns;

begin

	-- Instancia del controlador
	uut: entity work.controlador
	port map (
		clock   => clock,
		resetn  => resetn,
		go      => go,
		i       => i,
		j       => j,
		control => control,
		done    => done
	);

	-- Generador de reloj
	clock <= not clock after CLK_PERIOD / 2;

	-- Proceso de estimulos
	process
	begin
		-- =============================================
		-- PASO 1: Reset asincrono (resetn = '0')
		--   El controlador debe estar en S0
		--   control="000", done='0'
		-- =============================================
		resetn <= '0';
		wait for CLK_PERIOD * 2;

		-- =============================================
		-- PASO 2: Liberar reset, activar go='1'
		--   S0 -> S1 (borrado, control="001")
		--   S1 -> S2 (inicializacion, control="010")
		-- =============================================
		resetn <= '1';
		go     <= '1';
		wait for CLK_PERIOD;  -- S0 ve go='1', sig=S1
		wait for CLK_PERIOD;  -- S1: control="001", sig=S2
		wait for CLK_PERIOD;  -- S2: control="010", esperando go='0'

		-- =============================================
		-- PASO 3: Mantener go='1' unos ciclos
		--   Simula el tiempo que el usuario escribe registros
		--   El controlador se queda en S2 con control="010"
		-- =============================================
		wait for CLK_PERIOD * 5;

		-- =============================================
		-- PASO 4: go='0' => iniciar ordenamiento
		--   S2 -> S3 (preparar indices)
		--   S3 -> S4 (comparar, control="100")
		--   S4 -> S5 (incrementar j)
		--   S5 -> S6 (verificar j)
		--   ... ciclo hasta completar bubble sort
		-- =============================================
		go <= '0';

		-- Esperar suficientes ciclos para que complete todo el bubble sort
		-- Peor caso: 7 pasadas de i, cada una con hasta 7-i comparaciones
		-- Total de comparaciones: 7+6+5+4+3+2+1 = 28
		-- Cada comparacion toma ~3-4 ciclos (S4,S5,S6 + posible S7,S8)
		-- Mas overhead de estados => ~200 ciclos es suficiente
		wait for CLK_PERIOD * 200;

		-- =============================================
		-- PASO 5: Verificar que done='1' al terminar
		-- =============================================
		assert done = '1' report "ERROR: done deberia ser 1" severity error;

		assert false report "Simulacion de controlador finalizada" severity note;
		wait;
	end process;

end test;
