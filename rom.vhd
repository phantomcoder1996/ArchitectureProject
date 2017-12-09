Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity ROM is

port(
address: in std_logic_vector(7 downto 0);
dataout: out std_logic_vector(29 downto 0)

);

end entity;


Architecture ROMArch of ROM is

type romtype is Array(0 to 6) of std_logic_vector(29 downto 0);

signal rom:romtype;
begin

dataout<=rom(to_integer(unsigned(address)));

End ROMArch;
