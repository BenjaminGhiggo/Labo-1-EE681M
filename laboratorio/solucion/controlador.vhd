library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  Entity Declaration
entity controlador is
	port (clock		: in  std_logic;
		  resetn	: in  std_logic;
		  go		: in  std_logic;
		  i, j		: out std_logic_vector (2 downto 0);
		  control	: out std_logic_vector (2 downto 0);
		  done		: out std_logic
		 );
end controlador;

--  Architecture Body
architecture behav of controlador is

	-- Definicion de estados
	type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
	signal estado_actual : state_type;
	signal estado_sig    : state_type;

	-- Contadores i y j (registros internos de la FSM)
	signal i_reg  : unsigned(2 downto 0);
	signal j_reg  : unsigned(2 downto 0);
	signal i_next : unsigned(2 downto 0);
	signal j_next : unsigned(2 downto 0);

begin

	-- -------------------------------------------------------
	-- PROCESO 1: Registro de estado y contadores (secuencial)
	-- Flip-flops D con reset asincrono (activo bajo)
	-- -------------------------------------------------------
	process (clock, resetn)
	begin
		if resetn = '0' then
			estado_actual <= S0;
			i_reg <= (others => '0');
			j_reg <= (others => '0');
		elsif (clock'event and clock = '1') then
			estado_actual <= estado_sig;
			i_reg <= i_next;
			j_reg <= j_next;
		end if;
	end process;

	-- -------------------------------------------------------
	-- PROCESO 2: Logica de siguiente estado y salidas (combinacional)
	-- Modelo Moore: salidas dependen SOLO del estado actual
	-- -------------------------------------------------------
	process (estado_actual, go, i_reg, j_reg)
	begin
		-- Valores por defecto (evitar latches en sintesis)
		estado_sig <= estado_actual;
		i_next     <= i_reg;
		j_next     <= j_reg;
		control    <= "000";
		done       <= '0';
		i          <= std_logic_vector(i_reg);
		j          <= std_logic_vector(j_reg);

		case estado_actual is

			-- S0: estado de reset, esperar go='1' para iniciar
			when S0 =>
				if go = '1' then
					estado_sig <= S1;
				end if;

			-- S1: borrado sincrono de todos los registros
			when S1 =>
				control    <= "001";
				i_next     <= (others => '0');
				j_next     <= (others => '0');
				estado_sig <= S2;

			-- S2: modo inicializacion (go='1'), esperar go='0' para ordenar
			when S2 =>
				control <= "010";
				if go = '0' then
					i_next     <= (others => '0');
					j_next     <= to_unsigned(1, 3);
					estado_sig <= S3;
				end if;

			-- S3: preparar indice j = i + 1 para nueva pasada
			when S3 =>
				j_next     <= i_reg + 1;
				estado_sig <= S4;

			-- S4: comparar R[i] y R[j], intercambiar si necesario
			when S4 =>
				control    <= "100";
				estado_sig <= S5;

			-- S5: verificar si j llego al limite (j=7)
			-- Se verifica DESPUES de comparar y ANTES de incrementar
			-- para no saltarse la comparacion en j=7
			when S5 =>
				if j_reg = to_unsigned(7, 3) then
					estado_sig <= S7;
				else
					estado_sig <= S6;
				end if;

			-- S6: incrementar j y volver a comparar
			when S6 =>
				j_next     <= j_reg + 1;
				estado_sig <= S4;

			-- S7: incrementar i
			when S7 =>
				i_next     <= i_reg + 1;
				estado_sig <= S8;

			-- S8: verificar si i supero el limite (i=7 significa que ya
			-- se procesaron todos los pares, incluyendo i=6 vs j=7)
			when S8 =>
				if i_reg = to_unsigned(7, 3) then
					estado_sig <= S9;
				else
					estado_sig <= S3;
				end if;

			-- S9: ordenamiento terminado
			when S9 =>
				done       <= '1';
				estado_sig <= S9;

			when others =>
				estado_sig <= S0;

		end case;
	end process;

end behav;
