Library ieee;
use ieee.std_logic_1164.all;

--Description
--------------
--This block contains MDR and MAR registers which interface with main memory
--It also includes
--1.The multiplexer that is used to clear the Higher part of MDR when needed
--2.The multiplexer responsible for choosing whether MDR input is from RAM output or BUS1 
--3.The multiplexer responsible for choosing between shifted MDR output or MDR output
--4. 32-bit shifter for shifting MDR
---------------------------------------------------------------------------------------
--MDRIN=> Ctrl signal for mdr input
--MARIN=> Ctrl signal for mar input
--MDROUT1=> Ctrl signal for mdr output low
--MDROUT2=> Ctrl signal for mdr output high
--MUXMEM=> Ctrl signal for the mux which decides the mdr input
--MUXCLEAR=> Ctrl signal for mux that clears part of the mdr register
--MUXSHIFT=> Ctrl signal for mux that chooses whether or not to pass shifted mdr
--MuxShiftOutput=> The output of the multiplexer that chooses between shifted mdr and non shifted mdr 
--                 This output is used as an input to ALU block
----------------------------------------------------------------------------------------------------------  


Entity MemoryInterfacingBlock is

Port
(
  MDRIN: in std_logic;
  MARIN: in std_logic;
  MDROUT1: in std_logic;
  MDROUT2: in std_logic;
  
  MUXMEM: in std_logic;
  MUXSHIFT: in std_logic;
  MUXCLEAR: in std_logic;

  BUS2: inout std_logic_vector(31 downto 0);

  BUS1: in std_logic_vector(31 downto 0);
  
  MuxShiftoutput: out std_logic_vector(31 downto 0);

  Clk: in std_logic;
  RST: in std_logic

);

end Entity;

Architecture MemoryInterfacingBlockArch of MemoryInterfacingBlock is
begin
--TODO:
--Add mdr,mar,shifter and three multiplexers described above and 
--their connections

end;
