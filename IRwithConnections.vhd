Library ieee;
use ieee.std_logic_1164.all;

--Description 
--------------
--IRIN => Ctrl signal for IR register input
--IROUT => Ctrl signal for IR register output
--Branch=> Ctrl signal that is generated from branch decoding circuit 
--         Used to pass the offset address in case of branching and zero if there is no branch
-----------------------------------------------------------------------------------------------

Entity IRBlock is

Port
(
IRIN: in std_logic;
IROUT: in std_logic;

Branch: in std_logic;

BUS2: in std_logic_vector(31 downto 0);
BUS3: out std_logic_vector(31 downto 0);

Clk: in std_logic;
RST: in std_logic 

);
SIGNAL flag :std_logic;
SIGNAL d:std_logic_vector(31 DOWNTO 0);
SIGNAL q:std_logic_vector(15 DOWNTO 0);
end entity;

Architecture IRBlockArch of IRBlock is
  
------start of register component --------------------
COMPONENT nbitregister IS
Generic(n: integer:=32);
Port(d : in std_logic_vector(n-1 downto 0);
     rst: in std_logic;
     clk: in std_logic;
     En: in std_logic;
     q: out std_logic_vector(n-1 downto 0));
END COMPONENT ;

------end of register component ----------------------
begin

--TODO:
-- Add IR Register and connections with AND gate as shown in design
------create IR register -------------------
IR: nbitregister GENERIC MAP(16)  PORT MAP(d(15 DOWNTO 0),RST,Clk,IRIN,q);
PROCESS (CLk)
BEGIN
------1- check if IRIN =1 then read from bus2 ----
IF IRIN='1' THEN
d<=BUS2;
flag<='1';
ELSE
flag<='0';
END IF;

------3- if branch and flag =1 then out the offset 
IF Branch='1' AND flag='1' AND IROUT='1' THEN 
  BUS3<=("000000000000000000000") & q(10 DOWNTO 0);
------4- else out zeros-------------------------
ELSIF Branch='0' AND flag='1' AND IROUT='1' THEN 
BUS3<=(OTHERS=>'0');
ELSE
  BUS3<=(others=>'Z');
END IF;
END PROCESS;




end IRBlockArch;