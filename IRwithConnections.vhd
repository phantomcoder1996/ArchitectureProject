Library ieee;
use ieee.std_logic_1164.all;

--Description 
--------------
--IRIN => Ctrl signal for IR register input
--IROUT => Ctrl signal for IR register output
--Branch=> Ctrl signal that is generated from branch decoding circuit 
--         Used to pass the offset address in case of branching and zero if there is no branch
-----------------------------------------------------------------------------------------------

Entity IRBlock is

Port
(
IRIN: in std_logic;
IROUT: in std_logic;

Branch: in std_logic;

BUS2: in std_logic_vector(31 downto 0);
BUS3: out std_logic_vector(31 downto 0);

Clk: in std_logic;
RST: in std_logic 

);

end entity;

Architecture IRBlockArch of IRBlock is
begin

--TODO:
-- Add IR Register and connections with AND gate as shown in design

end IRBlockArch;