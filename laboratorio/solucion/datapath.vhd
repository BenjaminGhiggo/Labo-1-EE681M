library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  Entity Declaration
entity datapath is
	port (clock		: in  std_logic;
		  wrinit	: in  std_logic;
		  control	: in  std_logic_vector (2 downto 0);
		  i,j		: in  std_logic_vector (2 downto 0);
		  datain 	: in  std_logic_vector (3 downto 0);
		  radd		: in  std_logic_vector (2 downto 0);
		  dataout	: out std_logic_vector (3 downto 0)
		 );
end datapath;

--  Architecture Body
architecture behav of datapath is
	type file_register is array(0 to 7) of std_logic_vector(3 downto 0);
	signal R: file_register;

	signal i_int : integer range 0 to 7;
	signal j_int : integer range 0 to 7;
	signal r_int : integer range 0 to 7;

begin
	-- Convertir indices de std_logic_vector a entero para indexar el arreglo
	i_int <= to_integer(unsigned(i));
	j_int <= to_integer(unsigned(j));
	r_int <= to_integer(unsigned(radd));

	-- Proceso unico (sincrono, sin reset asincrono)
	process (clock)
	begin
		if (clock'event and clock = '1') then

			-- "001": borrado sincrono de todos los registros
			if control = "001" then
				R(0) <= "0000";
				R(1) <= "0000";
				R(2) <= "0000";
				R(3) <= "0000";
				R(4) <= "0000";
				R(5) <= "0000";
				R(6) <= "0000";
				R(7) <= "0000";

			-- "010": escribir datain en R[radd] si wrinit='1'
			elsif control = "010" then
				if wrinit = '1' then
					R(r_int) <= datain;
				end if;

			-- "100": comparar R[i] y R[j], intercambiar si R[i] > R[j]
			elsif control = "100" then
				if unsigned(R(i_int)) > unsigned(R(j_int)) then
					R(i_int) <= R(j_int);
					R(j_int) <= R(i_int);
				end if;

			end if;
		end if;
	end process;

	-- Salida combinacional (no registrada): muestra R[radd]
	dataout <= R(r_int);

end behav;
