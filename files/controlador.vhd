library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ===========================================================
--  CONTROLADOR del Sorter - EE681M UNI-FIEE 2026-1
--  FSM de dos procesos (modelo Moore)
--
--  Estados:
--    S0  : reset / espera
--    S1  : borrado sincrono de registros
--    S2  : espera de go='0' para iniciar ordenamiento
--    S3  : iniciar iteracion (i=0, j=i+1)
--    S4  : comparar e intercambiar R[i] y R[j]
--    S5  : incrementar j
--    S6  : verificar si j llego al limite (j=7)
--    S7  : incrementar i
--    S8  : verificar si i llego al limite (i=6)
--    S9  : ordenamiento terminado (done='1')
--
--  Codificacion de control (Moore, depende solo del estado):
--    "001" => borrar registros
--    "010" => escribir datain en R[radd] (wrinit debe estar activo)
--    "100" => comparar e intercambiar R[i] y R[j]
--    "000" => sin operacion
-- ===========================================================

entity controlador is
    port (clock   : in  std_logic;
          resetn  : in  std_logic;
          go      : in  std_logic;
          i, j    : out std_logic_vector (2 downto 0);
          control : out std_logic_vector (2 downto 0);
          done    : out std_logic
         );
end controlador;

architecture behav of controlador is

    -- Definicion de estados
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
    signal estado_actual  : state_type;
    signal estado_sig     : state_type;

    -- Contadores internos de i y j (registros de la FSM)
    signal i_reg : unsigned(2 downto 0);
    signal j_reg : unsigned(2 downto 0);
    signal i_next : unsigned(2 downto 0);
    signal j_next : unsigned(2 downto 0);

begin

    -- -------------------------------------------------------
    -- PROCESO 1: Registro de estado y contadores (secuencial)
    -- -------------------------------------------------------
    process (clock, resetn)
    begin
        if resetn = '0' then
            -- Reset asincrono: volver al estado inicial
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
    -- -------------------------------------------------------
    process (estado_actual, go, i_reg, j_reg)
    begin
        -- Valores por defecto (evitar latches)
        estado_sig <= estado_actual;
        i_next     <= i_reg;
        j_next     <= j_reg;
        control    <= "000";
        done       <= '0';
        i          <= std_logic_vector(i_reg);
        j          <= std_logic_vector(j_reg);

        case estado_actual is

            -- S0: estado de reset, esperar a que go='1' (modo inicializacion)
            when S0 =>
                control <= "000";
                if go = '1' then
                    estado_sig <= S1;
                else
                    estado_sig <= S0;
                end if;

            -- S1: borrado sincrono de todos los registros
            when S1 =>
                control    <= "001";
                i_next     <= (others => '0');
                j_next     <= (others => '0');
                estado_sig <= S2;

            -- S2: modo inicializacion activo (go='1'), esperar go='0'
            --     Mientras go='1' se puede escribir en registros via wrinit
            when S2 =>
                control <= "010";  -- habilita escritura (wrinit controla si efectivamente escribe)
                if go = '0' then
                    -- Pasar a modo procesamiento, no se puede regresar
                    i_next     <= (others => '0');
                    j_next     <= to_unsigned(1, 3);
                    estado_sig <= S3;
                else
                    estado_sig <= S2;
                end if;

            -- S3: inicio de iteracion - preparar indices i y j
            when S3 =>
                control    <= "000";
                j_next     <= i_reg + 1;
                estado_sig <= S4;

            -- S4: comparar R[i] y R[j], intercambiar si necesario
            when S4 =>
                control    <= "100";
                estado_sig <= S5;

            -- S5: incrementar j
            when S5 =>
                control    <= "000";
                j_next     <= j_reg + 1;
                estado_sig <= S6;

            -- S6: verificar si j llego al limite (j = 7)
            when S6 =>
                control <= "000";
                if j_reg = "111" then
                    -- j llego al maximo, incrementar i
                    estado_sig <= S7;
                else
                    -- seguir comparando con el mismo i
                    estado_sig <= S4;
                end if;

            -- S7: incrementar i
            when S7 =>
                control    <= "000";
                i_next     <= i_reg + 1;
                estado_sig <= S8;

            -- S8: verificar si i llego al limite (i = 6, ultimo par posible)
            when S8 =>
                control <= "000";
                if i_reg = "110" then
                    -- Ordenamiento completo
                    estado_sig <= S9;
                else
                    -- Siguiente pasada del burbuja
                    j_next     <= i_reg + 2;  -- j comienza en i+1 (i ya fue incrementado)
                    estado_sig <= S3;
                end if;

            -- S9: done, ordenamiento terminado
            when S9 =>
                control    <= "000";
                done       <= '1';
                estado_sig <= S9;  -- quedarse en este estado

            when others =>
                estado_sig <= S0;

        end case;
    end process;

end behav;
