LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

--Description
--------------
--This block is responsible for decoding IR register
--It includes:
--1.Src decoder
--2.Dest decoder
--3.ALU decoder
--4.PLA
--5.Two Multiplexers for choosing between source and destination
--------------------------------------------------------------------------------
--DSTENS=> Ctrl signal to enable the destination register as a source
--SRCEND=> Ctrl signal to enable the source register as a destination
--RSRCEN=> Ctrl signal to enable source decoder
--RDSTEN=> Ctrl signal to enable destination decoder
--PLAOUT=> Ctrl signal to enable the output from PLA
-----------------------------------------------------------------------------------------------

Entity InstructionDecodingCircuit is 

Port
( 
DSTENS: in std_logic;
SRCEND: in std_logic;
RSRCEN: in std_logic;
RDSTEN: in std_logic;
PLAout: in std_logic;
ALUEN:  in std_logic;

srcDecoderOutput :out std_logic_vector(3 downto 0);
dstDecoderOutput :out std_logic_vector(3 downto 0);
aluDecoderOutput :out std_logic_vector(15 downto 0);
PLAoutput: out std_logic_vector(7 downto 0);

IRinput: in std_logic_vector(15 downto 0)
);

end Entity;

Architecture InstructionDecodingCircuitArch of InstructionDecodingCircuit is
component decoder is
 Generic (n : integer :=4);
Port(   En:in std_logic; 
	s: in std_logic_vector(n-1 downto 0); 
	output: out std_logic_vector(((2**n)-1) downto 0)
     );
end component;

component Mux2 is
 Generic (n : integer :=4);
Port(a:in std_logic_vector(n-1 downto 0);
     b:in std_logic_vector(n-1 downto 0);
     sel:in std_logic;
     z:out std_logic_vector(n-1 downto 0)
     );

end component;


Signal SRCDecoderInput,DSTDecoderInput:std_logic_vector(1 downto 0);

begin

--TODO:
--Add the components stated in the description and their connections
--Note : PLAOut may be a hardwired signal generated when micropc is at 3 (waiting for your suggestions)

-------------------------------------------------ALU Decoding------------------------------------------------------------------------------

ALUDecoder:decoder generic map (n   => 4) port map(ALUEN,IRinput(13 downto 10),aluDecoderOutput);
-------------------------------------------------SRC---------------------------------------------------------------------------------------

SRCMUX: MUX2 generic map (n   => 2)  port map(IRinput(9 downto 8),IRinput(5 downto 4),SRCEND,SRCDecoderInput);
SRCDecoder:decoder generic map (n   => 2) port map(RSRCEN,SRCDecoderInput,srcDecoderOutput);
-------------------------------------------------DST---------------------------------------------------------------------------------------
DSTMUX: MUX2 generic map (n   => 2)  port map(IRinput(9 downto 8),IRinput(5 downto 4),DSTENS,DSTDecoderInput);
DSTDecoder:decoder generic map (n   => 2) port map(RDSTEN,DSTDecoderInput,dstDecoderOutput);
------------------------------------------------PLA----------------------------------------------------------------------------------------
PROCESS(PLAout) IS
BEGIN
If PLAout = '1' then
-------------------------------if mov operation-------------------------------------------------------------------------------------------
 if IRinput(15 downto 10)="001001" then
---------- src=direct------------dst=direct----------------------------------
 
  if IRinput(5 downto 4)="00" and IRinput(9 downto 8)="00" then
   PLAoutput<=std_logic_vector(TO_UNSIGNED (58 ,7));
  END IF;
------------------------src=direct ------dst=indexed-------------------------
  if IRinput(5 downto 4)="11" and IRinput(9 downto 8)="00" then
   PLAoutput<=std_logic_vector(TO_UNSIGNED (46 ,7));
  END IF;
--------------------------src=AI---------dst=indx----------------------------
   if IRinput(5 downto 4)="11" and IRinput(9 downto 8)="01" then
   PLAoutput<=std_logic_vector(TO_UNSIGNED (49 ,7));
  END IF;
---------------------------src=AD-----------dst=indexed-------------------
  if IRinput(5 downto 4)="11" and IRinput(9 downto 8)="10" then
   PLAoutput<=std_logic_vector(TO_UNSIGNED (54 ,7));
  END IF;
----------------------------src=direct-----------------------------
if  IRinput(9 downto 8)="00" then
   PLAoutput<=std_logic_vector(TO_UNSIGNED (17 ,7));
  END IF;

 END IF;
---------------------------if cmp direct direct -----------------------------------------------------------------------------------------
if IRinput(15 downto 10)="000100" and IRinput(5 downto 4)="00" and IRinput(9 downto 8)="00"  then
   PLAoutput<=std_logic_vector(TO_UNSIGNED (59 ,7));
  END IF;
--------------------------------------if one operand direct -----------------------------------------------------------------------------
 if IRinput(15 downto 14)="01" and  IRinput(9 downto 8)="00" then 
 PLAoutput<=std_logic_vector(TO_UNSIGNED (61 ,7));
  END IF;
--------------------------------------------------no op---------------------------------------------------------------------------------
if IRinput(15 downto 10)="10001" then
PLAoutput<=std_logic_vector(TO_UNSIGNED (10 ,7));
  END IF;
---------------------------------------------------RST-----------------------------------------------------------------------------------
if IRinput(15 downto 10)="10010" then
PLAoutput<=std_logic_vector(TO_UNSIGNED (11 ,7));
  END IF;
---------------------------------------------Single opreand not direct-------------------------------------------------------------------
if IRinput(15 downto 14)="01" then

---------------------------if AI-------------------------------------------------
if IRinput(9 downto 8)="01" then 
PLAoutput<=std_logic_vector(TO_UNSIGNED (20 ,7));
  END IF;
----------------------------if AD-----------------------------------------------
if IRinput(9 downto 8)="10" then 
PLAoutput<=std_logic_vector(TO_UNSIGNED (24 ,7));
  END IF;
-------------------------if indexed------------------------------------------
if IRinput(9 downto 8)="11" then 
PLAoutput<=std_logic_vector(TO_UNSIGNED (28 ,7));
  END IF;

END IF;
-------------------------------if double operand -----------------------------------------------------------------------------------------
if IRinput(15 downto 14)="00" then

-------------------if src= direct-----------------------------------
if IRinput(9 downto 8)="00" then 
PLAoutput<=std_logic_vector(TO_UNSIGNED (16 ,7));
  END IF;


-------------------if src=AI---------------------------
if IRinput(9 downto 8)="01" then 
PLAoutput<=std_logic_vector(TO_UNSIGNED (20 ,7));
  END IF;
-----------------------if src=AD----------------------

if IRinput(9 downto 8)="10" then 
PLAoutput<=std_logic_vector(TO_UNSIGNED (24 ,7));
  END IF;
---------------------------if src=indexed-------------
if IRinput(9 downto 8)="11" then 
PLAoutput<=std_logic_vector(TO_UNSIGNED (28 ,7));
  END IF;



 END IF;
  ----------------------------------------JSR----------------------------------------------------------------------------------------------
if IRinput(15 downto 10)="10011" then
PLAoutput<=std_logic_vector(TO_UNSIGNED (4,7));
  END IF;
-----------------------------------------RTS-----------------------------------------------------------------------------------------------
if IRinput(15 downto 10)="10100" then
PLAoutput<=std_logic_vector(TO_UNSIGNED (7,7));
  END IF;
----------------------------------------------any branch-----------------------------------------------------------------------------------
if IRinput(15 downto 14)="11" then
PLAoutput<=std_logic_vector(TO_UNSIGNED (63,7));
  END IF;

 END IF;
  
END PROCESS;


end InstructionDecodingCircuitArch;
