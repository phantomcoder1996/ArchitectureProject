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
begin

--TODO:
--Implement branching circuit as in description above

end BranchInstructionDecoderArch;

