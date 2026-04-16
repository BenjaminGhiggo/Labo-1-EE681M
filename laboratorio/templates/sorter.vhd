library ieee;
use ieee.std_logic_1164.all;

--  Entity Declaration
entity sorter is
	port (clock		: in  std_logic;
		  resetn	: in  std_logic;
		  go		: in  std_logic;
		  wrinit	: in  std_logic;
		  datain 	: in  std_logic_vector (3 downto 0);
		  radd		: in  std_logic_vector (2 downto 0);
		  dataout	: out std_logic_vector (3 downto 0);
		  done		: out std_logic
		 );
end sorter;

--  Architecture Body, no need to change anything
architecture estruct of sorter is

	component datapath
		port (clock		: in  std_logic;
			  wrinit	: in  std_logic;
			  control	: in  std_logic_vector (2 downto 0);
			  i,j		: in  std_logic_vector (2 downto 0);
			  datain 	: in  std_logic_vector (3 downto 0);
			  radd		: in  std_logic_vector (2 downto 0);
			  dataout	: out std_logic_vector (3 downto 0)
			  );
	end component;
	
	component controlador
		port (clock		: in  std_logic;
			  resetn	: in  std_logic;
			  go		: in  std_logic;
			  i, j		: out std_logic_vector (2 downto 0);
			  control	: out std_logic_vector (2 downto 0);
			  done		: out std_logic
		 	  );	
	end component;

-- you may need to add some signals
	
begin

	datos: datapath
	port map (clock		=> clock,
			  wrinit	=> -- complete
			  control	=> -- complete
			  i			=> -- complete
			  j			=> -- complete
			  datain 	=> -- complete
			  radd		=> -- complete
			  dataout	=> -- complete
			  );

	control: controlador
	port map (clock		=> clock,
			  resetn	=> -- complete
			  go		=> -- complete
			  i			=> -- complete
			  j			=> -- complete
			  control	=> -- complete
			  done		=> -- complete
			  );

end estruct;