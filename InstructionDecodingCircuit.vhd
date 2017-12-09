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

srcDecoderOutput :out std_logic_vector(3 downto 0);
dstDecoderOutput :out std_logic_vector(3 downto 0);
aluDecoderOutput :out std_logic_vector(15 downto 0);
PLAoutput: out std_logic_vector(7 downto 0);

IRinput: in std_logic_vector(15 downto 0)
);

end Entity;

Architecture InstructionDecodingCircuitArch of InstructionDecodingCircuit is
begin

--TODO:
--Add the components stated in the description and their connections
--Note : PLAOut may be a hardwired signal generated when micropc is at 3 (waiting for your suggestions)

end InstructionDecodingCircuitArch;
