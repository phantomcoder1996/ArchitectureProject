Library ieee;
use ieee.std_logic_1164.all;

--Description
---------------
--This block shall contain:
--1.ALU 
--2.Level-triggerred-Registers x and y
------------------------------------------
--XIN=> Ctrl signal for x input
--YIN=> Ctrl signal for y input
--ALUOUT1=> Ctrl signal for ALU output on bus 1
--ALUOUT2=> Ctrl signal for ALU output on bus 2
--MUXShiftOutput=> Input from multiplexer that is used to
--                 choose whether Y is loaded with MDROutput or ShiftedOutput
--CF=>Carry Flag
--ZF=>Zero Flag
-------------------------------------------------------------------------------------  

Entity AluBlock is

Port(
XIN:in std_logic;
YIN:in std_logic;
ALUOUT1: in std_logic;
ALUOUT2: in std_logic;

MuxShiftOutput: in std_logic_vector(31 downto 0);

BUS1: out std_logic_vector(31 downto 0);
BUS2: out std_logic_vector(31 downto 0);

BUS3: in std_logic_vector(31 downto 0);

CF: out std_logic;
ZF: out std_logic;

Clk: in std_logic;
RST: in std_logic
);

end Entity;

Architecture AluBlockArch of AluBlock is
begin

--TODO:
--ADD ALU and its connections with registers x and y


end AluBlockArch;
