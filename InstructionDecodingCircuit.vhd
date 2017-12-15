Library ieee;
use ieee.std_logic_1164.all;

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
aluDecoderOutput :out std_logic_vector(24 downto 0);
PLAoutput: out std_logic_vector(7 downto 0);

IRinput: in std_logic_vector(15 downto 0);
CW: in std_logic_vector(22 downto 0)
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
Signal twoOPout,oneOPout:std_logic_vector(15 downto 0);
Signal specialOUT:std_logic_vector(7 downto 0);
Signal twoOP,oneOP:std_logic_vector(24 downto 0);
signal enSPdec,enOneOP,enTwoOP:std_logic;
signal tempaluDecoderOutput:std_logic_vector(24 downto 0);

begin

--TODO:
--Add the components stated in the description and their connections
--Note : PLAOut may be a hardwired signal generated when micropc is at 3 (waiting for your suggestions)

-------------------------------------------------ALU Decoding------------------------------------------------------------------------------

enSPdec<= CW(5) or CW(4) or CW(3);
enOneOP<= ALUEN and  IRinput(14) and (not IRinput(15));
enTwoOP<= ALUEN and  (not IRinput(14)) and (not IRinput(15));

twoOPdec:decoder generic map (n   => 4) port map(enTwoOP,IRinput(13 downto 10), twoOPout);
oneOPdec:decoder generic map (n   => 4) port map(enOneOP,IRinput(13 downto 10), oneOPout);
specialOP:decoder generic map (n  => 3) port map(enSPdec,CW(5 downto 3), specialOUT);

tempaluDecoderOutput (24 downto 14) <= oneOPout(10 downto 0);
tempaluDecoderOutput (13 downto 4 ) <= twoOPout(9 downto 0);

 
aluDecoderOutput(0)<= specialOUT(2) ;
aluDecoderOutput(1)<= specialOUT(3);
aluDecoderOutput(2)<= specialOUT(5);
aluDecoderOutput(3)<= specialOUT(6);
aluDecoderOutput(4)<= tempaluDecoderOutput(4) or specialOUT(4);


-------------------------------------------------SRC---------------------------------------------------------------------------------------

SRCMUX: MUX2 generic map (n   => 2)  port map(IRinput(1 downto 0),IRinput(6 downto 5),SRCEND,SRCDecoderInput);
SRCDecoder:decoder generic map (n   => 2) port map(RSRCEN,SRCDecoderInput,srcDecoderOutput);
-------------------------------------------------DST---------------------------------------------------------------------------------------
DSTMUX: MUX2 generic map (n   => 2)  port map(IRinput(6 downto 5),IRinput(1 downto 0),DSTENS,DSTDecoderInput);
DSTDecoder:decoder generic map (n   => 2) port map(RDSTEN,DSTDecoderInput,dstDecoderOutput);
------------------------------------------------PLA----------------------------------------------------------------------------------------
end InstructionDecodingCircuitArch;
