Library ieee;
use ieee.std_logic_1164.all;

--Description
--------------
--PLAinput => Output of PLA implemented in instruction decoding circuit
--ROMout => Ctrl word -- parts of it can be used in branching
--Addressout=> Address of next instruction in ROM
---------------------------------------------------------------------- 

Entity ROMSequencingCircuit is

Port(
PLAInput: in std_logic_vector(7 downto 0);
ROMout: in std_logic_vector(29 downto 0);

Addressout: out std_logic_vector(7 downto 0);

Clk:in std_logic
);
end Entity;

Architecture ROMSequencingCircuitArch of ROMSequencingCircuit is
begin

--TODO
--Add micropc , microAR , PLA ,bit oring circuit

end ROMSequencingCircuitArch;