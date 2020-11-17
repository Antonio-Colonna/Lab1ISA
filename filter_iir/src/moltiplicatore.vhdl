LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity moltiplicatore is
   generic ( N: integer := 8);
   port
   (
      d1, d2: in std_logic_vector(N-1 downto 0);
      d1d2: out std_logic_vector(N-1 downto 0)------------------------------------------------
   );
end moltiplicatore;

architecture behavior of moltiplicatore is
signal d1_sig, d2_sig: SIGNED(N-1 DOWNTO 0);
signal d1d2_2N:SIGNED(2*N-1 DOWNTO 0);

begin 
d1_sig <= SIGNED(d1);
d2_sig <= SIGNED(d2);

d1d2_2N <= d1_sig * d2_sig;
d1d2 <= STD_LOGIC_VECTOR(d1d2_2N(2*N-2 DOWNTO N-1)); 

end behavior;