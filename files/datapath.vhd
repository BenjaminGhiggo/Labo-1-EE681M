library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ===========================================================
--  DATAPATH del Sorter - EE681M UNI-FIEE 2026-1
--  8 registros de 4 bits, algoritmo burbuja
--
--  Señales de control (codificacion Moore desde controlador):
--    control = "001" => limpiar (clear) todos los registros
--    control = "010" => escribir datain en R[radd] (inicializacion)
--    control = "100" => intercambiar R[i] y R[j] si R[i] > R[j]
-- ===========================================================

entity datapath is
    port (clock   : in  std_logic;
          wrinit  : in  std_logic;
          control : in  std_logic_vector (2 downto 0);
          i, j    : in  std_logic_vector (2 downto 0);
          datain  : in  std_logic_vector (3 downto 0);
          radd    : in  std_logic_vector (2 downto 0);
          dataout : out std_logic_vector (3 downto 0)
         );
end datapath;

architecture behav of datapath is
    -- Arreglo de 8 registros de 4 bits cada uno
    type file_register is array(0 to 7) of std_logic_vector(3 downto 0);
    signal R : file_register;

    -- Senales internas para los indices numericos
    signal i_int : integer range 0 to 7;
    signal j_int : integer range 0 to 7;
    signal r_int : integer range 0 to 7;

begin
    -- Conversion de indices a entero
    i_int <= to_integer(unsigned(i));
    j_int <= to_integer(unsigned(j));
    r_int <= to_integer(unsigned(radd));

    -- Proceso principal del datapath (un solo proceso, sin reset asincrono)
    process (clock)
    begin
        if (clock'event and clock = '1') then

            -- control = "001": limpiar todos los registros (borrado sincrono)
            if control = "001" then
                R(0) <= "0000";
                R(1) <= "0000";
                R(2) <= "0000";
                R(3) <= "0000";
                R(4) <= "0000";
                R(5) <= "0000";
                R(6) <= "0000";
                R(7) <= "0000";

            -- control = "010": escribir datain en el registro apuntado por radd
            elsif control = "010" then
                if wrinit = '1' then
                    R(r_int) <= datain;
                end if;

            -- control = "100": comparar R[i] y R[j], intercambiar si R[i] > R[j]
            elsif control = "100" then
                if unsigned(R(i_int)) > unsigned(R(j_int)) then
                    R(i_int) <= R(j_int);
                    R(j_int) <= R(i_int);
                end if;

            end if;
        end if;
    end process;

    -- Salida no registrada: muestra el contenido del registro apuntado por radd
    dataout <= R(r_int);

end behav;
