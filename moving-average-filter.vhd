
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;        
entity moving_avg is
    port ( CLK  : in  std_logic;
           RST  : in  std_logic;
           DIN  : in  signed(7 downto 0);    
           DOUT : out signed(7 downto 0) );  
end moving_avg;

architecture rtl of moving_avg is

    signal s0, s1, s2, s3 : signed(7 downto 0);
    signal sum : signed(9 downto 0);

begin
    shift_proc: process(CLK, RST)
    begin
        if (RST = '1') then
            s0 <= (others => '0');
            s1 <= (others => '0');
            s2 <= (others => '0');
            s3 <= (others => '0');
        elsif (rising_edge(CLK)) then
            s0 <= DIN;      
            s1 <= s0;      
            s2 <= s1;       
            s3 <= s2;
        end if;
    end process shift_proc;
    sum <= resize(s0, 10) + resize(s1, 10) + resize(s2, 10) + resize(s3, 10);
    DOUT <= resize(shift_right(sum, 2), 8);
end rtl;