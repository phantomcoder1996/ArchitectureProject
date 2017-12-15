Library ieee;
use ieee.std_logic_1164.all;

--Description
---------------
--This block shall contain:
--1.ALU 
--2.Level-triggerred-Registers x and y
------------------------------------------
--XIN=> Ctrl signal for x input
--YIN=> Ctrl signal for y input
--ALUOUT1=> Ctrl signal for ALU output on bus 1
--ALUOUT2=> Ctrl signal for ALU output on bus 2
--MUXShiftOutput=> Input from multiplexer that is used to
--                 choose whether Y is loaded with MDROutput or ShiftedOutput
--CF=>Carry Flag
--ZF=>Zero Flag
-------------------------------------------------------------------------------------  

Entity AluBlock is

generic (n : integer := 32);
Port(
XIN:in std_logic;
YIN:in std_logic;
ALUOUT1: in std_logic;
ALUOUT2: in std_logic;

MuxShiftOutput: in std_logic_vector(31 downto 0);

BUS1: out std_logic_vector(31 downto 0);
BUS2: out std_logic_vector(31 downto 0);

BUS3: in std_logic_vector(31 downto 0);

ALUopDECODERout: in std_logic_vector (24 downto 0);

CFin: in std_logic;
CFout: out std_logic;
ZF: out std_logic;

Clk: in std_logic;
RST: in std_logic
);

end Entity;

Architecture AluBlockArch of AluBlock is


----------------------components-----------------------
  component myRegister is

     generic (n : integer := 32);
     port( rst,enable : IN std_logic; 
           d:in std_logic_vector(n-1 downto 0);  
           q : OUT std_logic_vector(n-1 downto 0));

  end component;

	-----------------------------------

  component ALU is

	generic (n : integer := 32);
	port(
	      a,b:in std_logic_vector (n-1 downto 0); 
              selOP:in std_logic_vector (24 downto 0);
              c:out std_logic_vector (n-1 downto 0);
	      carryIN:in  std_logic;
	      carryOUT:out std_logic
	    );
  end component;

       -------------------------------------

  component tristateBuffer is

  generic (n : integer := 32);
  port(
       a:in std_logic_vector (n-1 downto 0);
       sel:in std_logic;
       b:out std_logic_vector (n-1 downto 0));

   end component;

-------------------------------------------------------
--------------------signals----------------------------
   signal XOUT,YOUT,TSxOUT,TSyOUT,ALUout :std_logic_vector (31 downto 0);
-------------------------------------------------------

begin


----------------tristate buffers-----------------------

   tristateX:tristateBuffer port map (BUS3,XIN,TSxOUT);
   tristateY:tristateBuffer port map (MuxShiftOutput,YIN,TSyOUT);

   tristateOUT1:tristateBuffer port map (ALUout,ALUOUT1,BUS1);
   tristateOUT2:tristateBuffer port map (ALUout,ALUOUT2,BUS2);

-------------------registers---------------------------

   X:myRegister port map (RST,XIN,TSxOUT,XOUT);
   Y:myRegister port map (RST,YIN,TSyOUT,YOUT);

-----------------------ALU-----------------------------

   myALU:ALU port map (XOUT,YOUT,ALUopDECODERout,ALUout,CFin,CFout);         ----------------------------check this one

-------------------------------------------------------
ZF<= '1' when ALUout =  (31 downto 0 => '0')
else  '0' ;

end AluBlockArch;
