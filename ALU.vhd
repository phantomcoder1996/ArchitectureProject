library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is

	generic (n : integer := 32);
	port(
	      a,b:in std_logic_vector (n-1 downto 0); 
              selOP:in std_logic_vector (24 downto 0);
              c:out std_logic_vector (n-1 downto 0);
	      carryIN:in  std_logic;
	      carryOUT:out std_logic
	    );
end ALU;

architecture archALU of ALU is

  --------------components-------------
  component nbitAdder is
         generic (n : integer := 32);
         port( 
               cin : IN std_logic;    
               cout : out std_logic;              
               a,b: in std_logic_vector(n-1 downto 0);
               c:out std_logic_vector(n-1 downto 0)
              );
  end component;
  -------------------------------------

  ----------------signals----------------------------
  signal x1,x2,outA:std_logic_vector (n-1 downto 0);
  signal auxCin,auxCout:std_logic;
  ---------------------------------------------------
  ---------------constants---------------------------
  constant Xplus2:std_logic_vector (24 downto 0):="0000000000000000000000001";
  
  ---------------------------------------------------

  begin

  ----------------portmaps---------------------------
	myAdder:nbitAdder port map(auxCin,auxCout,x1,x2,outA);
  ---------------------------------------------------

  ----------------operation---------------------------  
	
	--two operands
	c <= a                   when selOP="0000000000000000000000100"  --f=a
	else b                   when selOP="0000000000000000000001000"  --f=b
	else a       and b       when selOP="0000000000000000100000000"  --f=a and b
	else a       or  b       when selOP="0000000000000001000000000"  --f=a or b
	else a       xor b       when selOP="0000000000000010000000000"  --f=a xor b
	else a       or  b       when selOP="0000000000000100000000000"  --f=BIS
	else (not a) and b       when selOP="0000000000001000000000000"  --f=BIC
	
	--one operand
	else (others=>'0')                     when selOP="0000000010000000000000000" --f=CLR
	else not b  		               when selOP="0000000100000000000000000" --f=INV
	else '0'             & b(n-1 downto 1) when selOP="0000001000000000000000000" --f=LSR
	else b(0)            & b(n-1 downto 1) when selOP="0000010000000000000000000" --f=ROR
	else carryIN         & b(n-1 downto 1) when selOP="0000100000000000000000000" --f=RRC
	else b(n-1)          & b(n-1 downto 1) when selOP="0001000000000000000000000" --f=ASR
	else b(n-2 downto 0) & '0'             when selOP="0010000000000000000000000" --f=LSL
	else b(n-2 downto 0) & b(n-1)          when selOP="0100000000000000000000000" --f=ROL
	else b(n-2 downto 0) & carryIN         when selOP="1000000000000000000000000" --f=RLC
        else outA;   
	----------------------------
	carryOUT<= b(0)          when selOP="0000100000000000000000000" --f=RRC
	else       b(n-1)        when selOP="1000000000000000000000000" --f=RLC
        else       auxCout;                   
       -----------------------------
	x1<= a                   when selOP="0000000000000000000000010" or selOP="0000000000000000000000001" or selOP="0000000000000000000010000" or selOP="0000000000000000000100000" 
                                            --f=x-2                            --f=x+2                                    --f=a+b                   --f=a+b+carry                                
	else b                   when selOP="0000000000000000001000000" or selOP="0000000000000000010000000" or selOP="0000000000010000000000000" or selOP="0000000000100000000000000" or selOP="0000000001000000000000000" ;
                                            --f=b-a                            --f=b-a-carry                              --f=cmp                      --f=b+1                      --f=b-1
	----------------------------
	x2<=(1=>'1',others=>'0') when selOP="0000000000000000000000001" 
                                      --f=x+2
	else b                   when selOP="0000000000000000000010000" or selOP="0000000000000000000100000"
                                      --f=a+b                                  --f=a+b+carry
	else (0=>'0',others=>'1')when selOP="0000000000000000000000010"
				      --f=x-2
	else (not a)             when selOP="0000000000000000001000000" or (selOP="0000000000000000010000000" and carryIN='0') or selOP="0000000000010000000000000"
                                      --f=b-a                                  --f=b-a-carry                              --f=cmp
        else  not a              when selOP="0000000000000000010000000" and carryIN='1' 
                                      --f=b-a-carry
	else (0=>'1',others=>'0')when selOP="0000000000100000000000000"
                                       --f=b+1
	else (others=>'1')       when selOP="0000000001000000000000000";
                                      --f=b-1
	----------------------------  
	auxCin <= '0'               when selOP="0000000000000000000000001" or selOP="0000000000000000000000010" or selOP="0000000000000000000010000" or selOP="0000000000100000000000000" or selOP="0000000001000000000000000"
                                      --f=x+2                                  --f=x-2                                    --f=a+b                  --f=b+1                                --f=b-1
	else      carryIN           when selOP="0000000000000000000100000"
 				      --f=a+b+carry
	else      '1'               when selOP="0000000000000000001000000" or (selOP="0000000000000000010000000" and carryIN='0') or selOP="0000000000010000000000000"
                                      --f=b-a                                  --f=b-a-carry                              --f=cmp
        else      '0'               when selOP="0000000000000000010000000" and carryIN='1' ;
				      --f=b-a-carry
        -----------------------------
end archALU;
