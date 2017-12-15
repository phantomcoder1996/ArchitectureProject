Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--Description
--------------
--PLAinput => Output of PLA implemented in instruction decoding circuit
--ROMout => Ctrl word -- parts of it can be used in branching
--Addressout=> Address of next instruction in ROM
---------------------------------------------------------------------- 
--Branch Address Decoder Description
--000 => 0 noaction
--001 => 1 branch64 (dest)
--010 => 2 branch32  (single op)
--011 => 3 branch92 (mov or cmp)
--100 => 4 plaEn (wide branch)
-------------------------------------------------------------------------

Entity ROMSequencingCircuit is

Port(
PLAInput: in std_logic_vector(6 downto 0);
ROMout: in std_logic_vector(2 downto 0);

Addressout: out std_logic_vector(6 downto 0);

Clk:in std_logic;
rst:in std_logic; --ctrl signal
endi: in std_logic; --ctrl signal

oneoperand: in std_logic; --a signal indicating that the instruction is a one operand instruction (received from decoder in instruction decoding circuit)

IR_input:in std_logic_vector(15 downto 0); --The bits of IR having the opcode [15..10]

outPLAEn: out std_logic --ctrl signal to enable PLA in instruction decoding circuit


);
end Entity;

Architecture ROMSequencingCircuitArch of ROMSequencingCircuit is

signal counterinput: std_logic_vector(6 downto 0);
signal counteroutput: std_logic_vector(6 downto 0);
signal counterReset: std_logic;

signal muxBranchAddressSelectorOut: std_logic_vector(6 downto 0);
signal muxBranchAddressSelectionLine: std_logic_vector(1 downto 0);
signal branchDecoderOutput: std_logic_vector(7 downto 0); --may be removed

signal muxbranchSelection: std_logic;

signal load:std_logic;

constant branchAddressDest: std_logic_vector(6 downto 0):="1000000"; --64
constant branchAddressSingleOP: std_logic_vector(6 downto 0):="0100000"; --32
constant branchAddressMovorCMP: std_logic_vector(6 downto 0):="1011100"; --92
constant movOpcode:std_logic_vector(5 downto 0):="001001";
constant cmpOpcode:std_logic_vector(5 downto 0):="000100";

constant plaen:std_logic_vector(2 downto 0):="100";
constant branch64:std_logic_vector(2 downto 0):="001";
constant branch32:std_logic_vector(2 downto 0):="010";
constant branch92:std_logic_vector(2 downto 0):="011";

signal movdestAI: std_logic;
signal movdestAD: std_logic;
signal movdestReg: std_logic;
signal singleOp: std_logic;
signal movIndexedIndexed: std_logic;
signal bitOredAddress: std_logic_vector(6 downto 0);



begin

--TODO
--Add micropc , microAR , PLA ,bit oring circuit
--branchDecoder: entity work.decoder Generic map(n=>3) port map('1',ROMout(2 downto 0),branchDecoderOutput);

counterReset<='1' when ((rst='1')or(endi='1')) else '0';
micropc:entity work.counter Generic map(n=>7) port map(Clk,Addressout,counterReset,counterinput,load);

--branchMux: entity work.mux2 Generic map(n=>7) port map(muxBranchAddressSelectorOut,PLAInput,branchDecoderOutput(4),counterinput);
branchMux: entity work.mux2 Generic map(n=>7) port map(bitOredAddress,PLAInput,muxbranchSelection,counterinput);
MuxAddressSelector: entity work.mux4 Generic map(n=>7) port map(branchAddressDest,branchAddressSingleOP, branchAddressMovorCMP,"0000000",muxBranchAddressSelectionLine,muxBranchAddressSelectorOut);

muxBranchSelection<='1' when ROMout=plaen
else '0';

outPLAen<='1' when ROMout=plaen
else '0';

muxBranchAddressSelectionLine<= "00" when ROMout=branch64
                           else "01" when ROMout=branch32
                           else "10" when ROMout=branch92
                           else "11";

load<='1' when ROMout=plaen or ROMout=branch64 or ROMout=branch32 or ROMout=branch92
  else '0';


--signals for check
movdestReg<= '1' when((IR_input(15 downto 10)=movopcode)and(((IR_input(4) nor IR_input(3))='1')))else '0';
movdestAI<='1' when((IR_input(4)='0'and IR_input(3)='1')and(IR_input(15 downto 10)=movopcode)) else '0';
movdestAD<='1' when (((IR_input(3)='0')and (IR_input(4)='1'))and(IR_input(15 downto 10)=movopcode)) else '0';
singleOp<='1' when (( IR_input(15)='0')and (IR_input(14)='1')) else '0';
movIndexedIndexed<='1' when ((IR_input(15 downto 10)=movopcode)and((IR_input(4)='1')and (IR_input(3)='1'))and((IR_input(9)='1') and (IR_input(8)='1'))) else '0';
--Bit oring circuitry
bitOredAddress(0)<='1' when((muxBranchAddressSelectorOut(0)='1') or ((movdestReg='1') and ROMout=branch32)or((movIndexedIndexed='1') and ROMout=branch92)) else '0';
bitOredAddress(1)<='1' when((muxBranchAddressSelectorOut(1)='1') or ((movdestReg='1') and ROMout=branch32)or(((IR_input(15 downto 10)=cmpOpcode)or (movIndexedIndexed='1'))and ROMout=branch92)) else '0';
bitOredAddress(2)<='1' when((muxBranchAddressSelectorOut(2)='1') or (((movdestAI='1') or (singleOp='1'))and ROMout=branch32)) else '0';
bitOredAddress(3)<='1' when((muxBranchAddressSelectorOut(3)='1') or (((movdestAD='1') or (singleOp='1')) and ROMout=branch32)or((IR_input(3)='1')and (ROMout=branch64))) else '0';
bitOredAddress(4)<='1' when((muxBranchAddressSelectorOut(4)='1') or ((IR_input(4)='1') and ROMout=branch64)) else '0';
bitOredAddress(6 downto 5)<=muxBranchAddressSelectorOut(6 downto 5);

end ROMSequencingCircuitArch;