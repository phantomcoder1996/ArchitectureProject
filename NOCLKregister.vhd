library ieee;
use ieee.std_logic_1164.all;

entity myRegister is

     generic (n : integer := 32);
     port( rst,enable : IN std_logic; 
           d:in std_logic_vector(n-1 downto 0);  
           q : OUT std_logic_vector(n-1 downto 0));

end myRegister;

architecture a_my_register OF myRegister is
begin

     process(enable,d,rst)
     begin

	if    rst    = '1'  then q <= (others=>'0');
	elsif enable = '1'  then q <= d;
        end if;

     end process;

end a_my_register;
