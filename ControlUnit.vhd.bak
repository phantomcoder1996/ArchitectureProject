Library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is

Port
(
PLAInput: in std_logic_vector(6 downto 0);

Clk: in std_logic;


oneoperand: in std_logic; --output from decoder that indicates whether operand is single,double,noop or branch

IR_input: in std_logic_vector(15 downto 0);

--CTRL signals generated from ROM
outPLAEn:out std_logic;

mdrin: out std_logic; --28

mdrout2: out std_logic; --27

aluen: out std_logic; --26

muxpcin: out std_logic; --25

pcin:out std_logic; --24

marin: out std_logic; --23

xin: out std_logic; --22

yin: out std_logic; --21

dstens: out std_logic; --20

srcend: out std_logic; --19

aluout1: out std_logic; --18

aluout2: out std_logic; --17

muxmem: out std_logic; --16

--GROUP A (15 downto 13)
-------------------------
IRout: out std_logic;
Rsrcen: out std_logic;
SPout: out std_logic;
IRin: out std_logic;
Tempout: out std_logic;
Rst: out std_logic;

--GROUP B (12 downto 11)
------------------------
Tempin: out std_logic;
Spin: out std_logic;
Rdsten: out std_logic;

--GROUP C (10)
---------------
RDWR: out std_logic;

--GROUP E (9 downto 8)
-----------------------
PCout: out std_logic;
MDRout1: out std_logic;

--GROUP F (7 downto 6)
----------------------
endi : out std_logic;
muxclear: out std_logic;
muxshift: out std_logic;

--ALUop (5 downto 3)
--------------------
ALUop: out std_logic_vector(2 downto 0)

--microBranch control (2 downto 0)




);
end entity;

Architecture ControlUnitArch of ControlUnit is

signal GPA_En,GPB_En,GPE_En,GPF_En: std_logic;

signal GPA_decoderOut: std_logic_vector(7 downto 0);
signal GPB_decoderOut: std_logic_vector(3 downto 0);
signal GPE_decoderOut: std_logic_vector(3 downto 0);
signal GPF_decoderOut: std_logic_vector(3 downto 0); 



signal Ctrlword: std_logic_vector(28 downto 0);

signal RomAddress: std_logic_vector( 6 downto 0);
begin

GPA_En<= '0' when ((Ctrlword(15)='0') and (Ctrlword(14)='0')and (Ctrlword(13)='0')) else '1'; 
GPA_decoder: entity work.decoder generic map(n=>3) port map(GPA_En,Ctrlword(15 downto 13),GPA_decoderout);

GPB_En<= '0' when ((Ctrlword(12)='0') and (Ctrlword(11)='0')) else '1';
GPB_decoder: entity work.decoder generic map(n=>2) port map(GPB_En,Ctrlword(12 downto 11),GPB_decoderout);

GPE_En<='0'  when ((Ctrlword(9)='0') and (Ctrlword(8)='0')) else '1';
GPE_decoder: entity work.decoder generic map(n=>2) port map(GPE_En,Ctrlword(9 downto 8),GPE_decoderout);

GPF_En<='0'  when ((Ctrlword(7)='0') and (Ctrlword(6)='0')) else '1';
GPF_decoder: entity work.decoder generic map(n=>2) port map(GPF_En,Ctrlword(7 downto 6),GPF_decoderout);

mdrin<= Ctrlword(28);

mdrout2<=Ctrlword(27);

aluen<=Ctrlword(26);

muxpcin<=Ctrlword(25);

pcin<=Ctrlword(24);

marin<=Ctrlword(23);

xin<=Ctrlword(22);

yin<=Ctrlword(21);

dstens<=Ctrlword(20);

srcend<=Ctrlword(19);

aluout1<=Ctrlword(18);

aluout2<=Ctrlword(17);

muxmem<=Ctrlword(16);

irout<= GPA_decoderout(1);
rsrcen<= GPA_decoderout(2);
spout<= GPA_decoderout(4);
irin<= GPA_decoderout(5);
tempout<= GPA_decoderout(6);
rst<= GPA_decoderout(7);

tempin<=GPB_decoderout(1);
spin<=GPB_decoderout(2);
rdsten<=GPB_decoderout(3);

RDWR<=Ctrlword(10);

pcout<=GPE_decoderout(1);
mdrout1<=GPE_decoderout(2);

endi<=GPF_decoderout(1);
muxclear<=GPF_decoderout(2);
muxshift<=GPF_decoderout(3);

ALUop<=Ctrlword(5 downto 3);


RomSequencingCirc: entity work.ROMSequencingCircuit port map(PLAinput,Ctrlword(2 downto 0),RomAddress,Clk,GPA_decoderout(7),GPF_decoderout(1),oneoperand,IR_input,outPLAEn);

RM: entity work.ROM port map(RomAddress,CtrlWord);


end ControlUnitArch;