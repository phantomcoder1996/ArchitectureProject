Library ieee;
use ieee.std_logic_1164.all;

--Description
--------------
--This block includes all general purpose registers in addition
--to temp and SP
-------------------------------------------------------------
--SrcDecoderOut,DstDecoderOut=>input from instruction decoding circuit 
--for enabling tristate buffers connected to registers
-----------------------------------------------------------------
Entity RegistersFile is

Generic(n:integer:=32);

Port
(
 SrcDecoderOut: in std_logic_vector(3 downto 0);
 DstDecoderOut: in std_logic_vector(3 downto 0);
 
 TEMPIN: in std_logic;
 SPIN: in std_logic;
 TEMPOUT: out std_logic;
 SPOUT: out std_logic;

 BUS1: in std_logic_vector(31 downto 0);
 BUS2: in std_logic_vector(31 downto 0);

 BUS3: out std_logic_vector(31 downto 0);

 Clk: in std_logic;
 RST: in std_logic
 
);

end Entity;

Architecture RegistersFileArch of RegistersFile is
begin

--TODO:
--Add all registers and their connections


end RegistersFileArch;