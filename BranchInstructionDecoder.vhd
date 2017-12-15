Library ieee;
use ieee.std_logic_1164.all;

--Description
--------------
--Circuit that is responsible for handling branching 
--Circuit is drawn in the design and it includes Branch instruction decoder
--Only 5 bits of IR are needed
--If IR(15..14)=='11',This is used to enable branch decoder
--IR(13..11) indicate the kind of branch
---------------------------------------------------------------------
--Branch=> Input to IRBlock in IRwithConnections.vhdl
--------------------------------------------------------------
Entity BranchInstructionDecoder is

Port
(
 IRinput: in std_logic_vector(4 downto 0);

 CF: in std_logic;
 ZF: in std_logic;

 Branch: out std_logic

);



end Entity;

Architecture BranchInstructionDecoderArch of BranchInstructionDecoder is

component decoder is
 Generic (n : integer :=4);
Port(   En:in std_logic; 
	s: in std_logic_vector(n-1 downto 0); 
	output: out std_logic_vector(((2**n)-1) downto 0)
     );
end component;

signal BRDecoderOut: std_logic_vector( 7 downto 0);
signal BREN: std_logic;
signal JSR:  std_logic;


begin



--TODO:
--Implement branching circuit as in description above
BREN <= IRinput(3) and IRinput(4);

BranchDecoder : decoder generic map (n   => 3) port map(BREN,IRinput(3 downto 0),BRDecoderOut);

JSR <= IRinput(4) and (not (IRinput(3))) and (not (IRinput(2)))and IRinput(1) and IRinput(0);

 Branch <= JSR or BRDecoderOut(0) or (BRDecoderOut(1) and ZF) or (BRDecoderOut(2) and (not ZF)) or (BRDecoderOut(3) and CF) or (((not CF) or ZF) and BRDecoderOut(4)) or (BRDecoderOut(5) and CF)or ((CF or ZF) and BRDecoderOut(5));

 --   

end BranchInstructionDecoderArch;

