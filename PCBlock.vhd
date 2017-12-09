Library ieee;
use ieee.std_logic_1164.all;

Entity PCBlock is

Port
(
 PCIN: in std_logic;
 PCOUT: in std_logic;
 MUXPCIN: in std_logic;
 
 RST: in std_logic;
 
 Clk: in std_logic;
 
 BUS1: in std_logic_vector(15 downto 0);
 
 BUS2: out std_logic_vector(31 downto 0)
 
);

end Entity;


Architecture PCBlockArch of PCBlock is

signal PcOutput:  std_logic_vector(15 downto 0);
signal IncrementerOutput: std_logic_vector(15 downto 0);
signal PcInput: std_logic_vector(15 downto 0);

constant zero16:std_logic_vector(15 downto 0):=(others=>'0');

begin


Pc: entity work.nbitregister generic map(n=>16) port map(PcInput,RST,Clk,PCIN,PcOutput);
PcTristateOut1:entity work.tristate generic map(n=>16) port map(PcOutput,BUS2(15 downto 0),PCOUT);
PcTristateout2:entity work.tristate generic map(n=>16) port map(zero16,BUS2(31 downto 16),PCOUT);
--muxpc:entity work.mux2 generic map(n=>16) port map(incrementeroutput,bus1,muxpcin,muxout);
MuxPc:entity work.mux2 generic map(n=>16) port map(IncrementerOutput,BUS1(15 downto 0),MUXPCIN,PcInput);
Incrementer: entity work.pccalculator generic map(n=>16) port map(PcOutput,IncrementerOutput);

end PCBlockArch;
