LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sommatore IS 
  GENERIC ( N : integer := 8) ;
       PORT ( input1 , input2 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;   
		               output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		   ) ;
END sommatore ;

architecture Behavior OF sommatore IS
SIGNAL ADD1, ADD2 : SIGNED(N-1 DOWNTO 0);
BEGIN
ADD1(N-1 DOWNTO 0) <= SIGNED(input1);
ADD2(N-1 DOWNTO 0) <= SIGNED(input2);
output <= ADD1+ADD2;
end Behavior;

