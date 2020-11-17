LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY filter_iir IS
             PORT (DIN, a1, a2, b0, b1, b2, b3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
			       clk, RST_n, VIN : IN STD_LOGIC;
				   VOUT: OUT STD_LOGIC;
				   DOUT: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			 );
END filter_iir;

ARCHITECTURE Structure OF filter_iir IS 


SIGNAL x,x1,x2,x3,xbo,xbo1,xbo2,sum,sum1,xb1,xb11,xb2,xb21,xb3,xb31,s1,s2,s21: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL  DIN_int,y,y1,sub,y1a1,y1a2,y1a11,y1a21: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL VIN_int,VIN_int1,VIN_int2,VIN_int3,VIN_int3_1, reset_n : STD_LOGIC;

COMPONENT register_d is 
   generic ( N: integer := 8);
   port(
      Q : out std_logic_vector(N-1 downto 0);    
    Clk, reset_n, enable: in std_logic;  
      D :in  std_logic_vector(N-1 downto 0)    
   );
END COMPONENT;

COMPONENT sommatore IS 
  GENERIC ( N : integer := 8) ;
       PORT ( input1 , input2 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;   
		               output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		   ) ;
END COMPONENT ;

COMPONENT sottrattore IS 
  GENERIC ( N : integer := 8) ;
       PORT ( input1 , input2 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;   
		               output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		   ) ;
END COMPONENT ;

COMPONENT moltiplicatore is
   generic ( N: integer := 8);
   port
   (
      d1, d2: in std_logic_vector(N-1 downto 0);
      d1d2: out std_logic_vector(N-1 downto 0)------------------------------------------------
   );
end COMPONENT;

COMPONENT flipflop is 
   port(
      Q : out std_logic;    
    Clk, reset_n, enable: in std_logic;  
      D :in  std_logic    
   );
end COMPONENT;

BEGIN 
reset_n <= RST_n;
reg_vin: flipflop PORT MAP (VIN_int, clk, reset_n, '1', VIN);
reg_din: register_d GENERIC MAP (N => 8) 
                   PORT MAP ( DIN_int, clk, reset_n, VIN, DIN);


x(7 DOWNTO 0) <= DIN_int(7 DOWNTO 0);

mol1: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (x, b0, xbo);
				   
				   
reg1: register_d GENERIC MAP (N => 8) 
                   PORT MAP (x1, clk, reset_n, VIN_int, x);
				   
reg2: register_d GENERIC MAP (N => 8) 
                   PORT MAP (x2, clk, reset_n, VIN_int, x1);

reg3: register_d GENERIC MAP (N => 8) 
                   PORT MAP (x3, clk, reset_n, VIN_int, x2);
				

molt_b1: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (x1, b1, xb1);
				
molt_b2: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (x2, b2, xb2);

molt_b3: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (x3, b3, xb3);
						 
reg4: register_d GENERIC MAP (N => 8) 
                   PORT MAP (xbo1, clk, reset_n, VIN_int, xbo);
				   
reg5: register_d GENERIC MAP (N => 8) 
                   PORT MAP (xbo2, clk, reset_n, VIN_int, xbo1);

reg6: register_d GENERIC MAP (N => 8) 
                   PORT MAP (xb11, clk, reset_n, VIN_int, xb1);
						 

				   
reg7: register_d GENERIC MAP (N => 8) 
                   PORT MAP (xb21, clk, reset_n, VIN_int, xb2);

reg8: register_d GENERIC MAP (N => 8) 
                   PORT MAP (xb31, clk, reset_n, VIN_int, xb3);
						 
summ1: sommatore GENERIC MAP (N => 8) 
                   PORT MAP (xb21, xb31, s1);
						 

						 
summ2: sommatore GENERIC MAP (N => 8) 
                   PORT MAP (s1, xb11, s2);
						 
reg9: register_d GENERIC MAP (N => 8) 
                   PORT MAP (s21, clk, reset_n, VIN_int, s2);
				
summ3: sommatore GENERIC MAP (N => 8) 
                   PORT MAP (s21, xbo2, sum);
reg10: register_d GENERIC MAP (N => 8) 
                   PORT MAP (sum1, clk, reset_n, VIN_int, sum);

sott: sottrattore GENERIC MAP (N => 8) 
                   PORT MAP (sum1, sub, y);						 
						 
reg11: register_d GENERIC MAP (N => 8) 
                   PORT MAP (y1, clk, reset_n, VIN_int, y);
						 
molt_a1: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (y1, a1, y1a1);
				
molt_a2: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (y1, a2, y1a2);	
	
reg12: register_d GENERIC MAP (N => 8) 
                   PORT MAP (y1a11, clk, reset_n, VIN_int, y1a1);

reg13: register_d GENERIC MAP (N => 8) 
                   PORT MAP (y1a21, clk, reset_n, VIN_int, y1a2);	
						 
finalsum: sommatore GENERIC MAP (N => 8) 
                   PORT MAP (y1a11, y1a21, sub);					 
						 
				   
reg_dout: register_d GENERIC MAP (N => 8) 
                   PORT MAP ( DOUT, clk, reset_n, VIN_int, y);
				   
reg_vout1: flipflop PORT MAP (VIN_int1, clk, reset_n, '1', VIN_int);
reg_vout2: flipflop PORT MAP (VIN_int2, clk, reset_n, '1', VIN_int1);
reg_vout3: flipflop PORT MAP (VIN_int3, clk, reset_n, '1', VIN_int2);
VIN_int3_1 <= VIN_int AND VIN_int3;
reg_vout4: flipflop PORT MAP (VOUT, clk, reset_n, '1', VIN_int3_1);

END Structure;
