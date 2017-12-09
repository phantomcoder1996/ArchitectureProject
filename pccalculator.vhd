Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity PcCalculator is

Generic(n : integer:=16);

port(
     a: in std_logic_vector(n-1 downto 0);

     Output:out std_logic_vector(n-1 downto 0)
);


end Entity;

Architecture PcCalculatorArch of PcCalculator is

signal result:integer;
begin

--result<= (to_integer(unsigned(a)))+(to_integer(unsigned(b)));
result<= to_integer(unsigned(a))+1;
Output<=std_logic_vector(to_unsigned(result,Output'length));



end PcCalculatorArch;