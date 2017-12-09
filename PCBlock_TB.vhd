Library ieee;
use ieee.std_logic_1164.all;

Entity PCBlock_TB is



end Entity;


Architecture PCBlock_TBArch of PCBlock_TB is

signal PCIN,MUXPCIN,PCOUT: std_logic:='0';

signal bus1,bus2: std_logic_vector(31 downto 0);

signal rst,clk: std_logic;

constant timestamp:time:=50 ns;
constant zero32: std_logic_vector(31 downto 0):=(others=>'0');
constant one: std_logic_vector(31 downto 0):=(0=>'1',others=>'0');
constant three: std_logic_vector(31 downto 0):=(1=>'1',0=>'1',others=>'0');
constant two: std_logic_vector(31 downto 0):=(1=>'1',others=>'0');
begin

PCB: entity work.PCBlock port map(pcin,pcout,muxpcin,rst,clk,bus1(15 downto 0),bus2);

process 
begin

clk<='1';
wait for timestamp;


clk<='0';
wait for timestamp;


end process;


process
begin

rst<='1';
pcout<='1';

wait for 2*timestamp;

assert( bus2=zero32)
report "reset not working"
severity error;

rst<='0';
pcout<='1';
pcin<='1';

wait for 2*timestamp;

assert(bus2=one)
report "pc not incremented"
severity error;

pcout<='1';
pcin<='1';
muxpcin<='1';
bus1<=(1=>'1',others=>'0');

wait for 2*timestamp;

assert(bus2=two)
report "pc not loaded with correct value"
severity error;

muxpcin<='0';
bus1<=(others=>'Z');

wait for 2*timestamp;

assert(bus2=three)
report "pc was not incremented to 3"
severity error;

bus1<=(others=>'0');
pcin<='0';
wait for 2*timestamp;
assert(bus2=three)
report "pc value was not supposed to change"
severity error;

wait;
end process;

end PCBlock_TBArch; 