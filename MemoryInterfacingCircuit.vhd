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
  RAMOUT:in std_logic_vector(31 downto 0);   ---added--
  
  MuxShiftoutput: out std_logic_vector(31 downto 0);

  Clk: in std_logic;
  RST: in std_logic

);
SIGNAl MDRd,MARd,MDRq,MARq,MUXMEMOUT,SHIFEROUT,MDROUT:std_logic_vector(31 downto 0);
SIGNAL MUXCOUT:std_logic_vector(15 DOWNTO 0);
end Entity;

Architecture MemoryInterfacingBlockArch of MemoryInterfacingBlock is
  ------start of register component -----------
COMPONENT nbitregister IS
Generic(n: integer:=32);
Port(d : in std_logic_vector(n-1 downto 0);
     rst: in std_logic;
     clk: in std_logic;
     En: in std_logic;
     q: out std_logic_vector(n-1 downto 0));
END COMPONENT ;
  ------end of register component--------------
  ------start of mux component-----------------
COMPONENT Mux2 IS
Generic(n: integer:=16);
Port(a:in std_logic_vector(n-1 downto 0);
     b:in std_logic_vector(n-1 downto 0);
     sel:in std_logic;
     z:out std_logic_vector(n-1 downto 0)
     );
END COMPONENT ;
  ------end of  mux component-----------------
  
begin

-- get data from bus2 ------
MARd <= BUS2;
----------TODO : el output 3la bus 2 bta3 el mux clear ana shaia mlosh lazma  -----------

-- create MDR & MAR registers 
MDR :nbitregister GENERIC MAP(32)  PORT MAP(MDRd,RST,Clk,MDRIN,MDRq);
MAR :nbitregister GENERIC MAP(32)  PORT MAP(MARd,RST,Clk,MARIN,MARq);
  
---create clear MDR mux ---------
clear: Mux2 GENERIC MAP(16)  PORT MAP(MDRq(31 DOWNTO 16),"0000000000000000",MUXCLEAR,MUXCOUT);
  
---create multiplexer responsible for choosing whether MDR input is from RAM output or BUS1 -------
mem: Mux2 GENERIC MAP(32)  PORT MAP(RAMOUT,BUS1,MUXMEM,MUXMEMOUT);
MDRd<=MUXMEMOUT;
MDROUT<=MUXCOUT&MDRq(15 DOWNTo 0);

---create multiplexer responsible for choosing between shifted MDR output or MDR output-------------------
choose:Mux2 GENERIC MAP(32)  PORT MAP(MDROUT,SHIFEROUT,MUXSHIFT,MuxShiftoutput);
---create  32-bit shifter for shifting MDR-----------------------
SHIFEROUT<="0000000000000000" & MDRq(31 DOwNTO 16);

end;
