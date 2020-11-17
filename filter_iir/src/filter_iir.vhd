LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY filter_iir IS
             PORT (DIN, a1, a2, b0, b1, b2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
			       clk, RST_n, VIN : IN STD_LOGIC;
				   VOUT: OUT STD_LOGIC;
				   DOUT: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			 );
END filter_iir;

ARCHITECTURE Structure OF filter_iir IS 

SIGNAL DIN_int : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL x, w, w_b0, sw1, sw2, sw1_a1, sw2_a2, fb, ff, sw1_b1, sw2_b2, y: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL VIN_int, reset_n : STD_LOGIC;

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

sot_w: sottrattore GENERIC MAP (N => 8) 
                   PORT MAP (x, fb, w);
				   
sum_fb: sommatore GENERIC MAP (N => 8) 
                   PORT MAP (sw1_a1, sw2_a2, fb);
				   
reg1: register_d GENERIC MAP (N => 8) 
                   PORT MAP (sw1, clk, reset_n, VIN_int, w);
				   
reg2: register_d GENERIC MAP (N => 8) 
                   PORT MAP (sw2, clk, reset_n, VIN_int, sw1);

molt_a1: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (sw1, a1, sw1_a1);
				
molt_a2: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (sw2, a2, sw2_a2);

molt_b1: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (sw1, b1, sw1_b1);
				
molt_b2: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (sw2, b2, sw2_b2);
				   
molt_b0: moltiplicatore GENERIC MAP (N => 8) 
                   PORT MAP (w, b0, w_b0);

sum_ff: sommatore GENERIC MAP (N => 8) 
                   PORT MAP (sw1_b1, sw2_b2, ff);
				   
sum_y: sommatore GENERIC MAP (N => 8) 
                   PORT MAP (w_b0, ff, y);
				   
reg_dout: register_d GENERIC MAP (N => 8) 
                   PORT MAP ( DOUT, clk, reset_n, VIN_int, y);
				   
reg_vout: flipflop PORT MAP (VOUT, clk, reset_n, '1', VIN_int);

END Structure;
