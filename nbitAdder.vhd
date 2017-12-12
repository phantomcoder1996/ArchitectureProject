library ieee;
use ieee.std_logic_1164.all;



ENTITY nbitAdder IS
         generic (n : integer := 32);
         PORT( 
               cin : IN std_logic;    
               cout : out std_logic;              
               a,b: in std_logic_vector(n-1 downto 0);
               c:out std_logic_vector(n-1 downto 0)
              );
END nbitAdder;

ARCHITECTURE nbitArcadder OF nbitAdder IS

component adder IS
         PORT( a,b,cin : IN std_logic;                  
               c,cout : OUT std_logic);
 END component;

signal temp : std_logic_vector(n-1 DOWNTO 0);
signal temp2 : std_logic_vector(n-1 DOWNTO 0);

BEGIN

     loop1: for i in 0 to n-1 generate
        g0: IF i = 0 generate
                f0: adder port map (a(i) ,b(i) ,cin, temp2(i), temp(i));
         end generate g0;
         gx: if i > 0 generate
                 fx: adder port map  (a(i),b(i),temp(i-1),temp2(i),temp(i));
          end generate gx;
    end generate;

cout<=temp(n-1);
c<=temp2;
   
END nbitArcadder;
