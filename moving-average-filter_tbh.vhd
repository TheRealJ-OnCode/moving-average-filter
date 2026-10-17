library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moving_avg_tb is
end moving_avg_tb;
architecture sim of moving_avg_tb is
    component moving_avg
        port ( CLK  : in  std_logic;
               RST  : in  std_logic;
               DIN  : in  signed(7 downto 0);
               DOUT : out signed(7 downto 0) );
    end component;
    constant CLK_PERIOD : time := 10 ns;
    signal CLK      : std_logic := '0';
    signal RST      : std_logic := '0';
    signal DIN      : signed(7 downto 0) := (others => '0');
    signal DOUT     : signed(7 downto 0);
    signal sim_done : boolean := false;

    type sample_array is array (0 to 15) of integer;
    constant SAMPLES : sample_array :=
        (22, 25, 20, 23, 19, 24, 21, 23,
         20, 22, 24, 21, 22, 25, 20, 22);

begin

    dut: moving_avg port map ( CLK => CLK, RST => RST,
                               DIN => DIN, DOUT => DOUT );

    clk_gen: process
    begin
        if sim_done then
            wait;
        end if;
        CLK <= '0';
        wait for CLK_PERIOD / 2;
        CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stim: process
    begin
        RST <= '1';
        wait for 10 ns;
        RST <= '0';

        for i in SAMPLES'range loop
            DIN <= to_signed(SAMPLES(i), 8);
            wait for CLK_PERIOD;
            report "DIN = " & integer'image(SAMPLES(i)) &
                   "   DOUT = " & integer'image(to_integer(DOUT));
        end loop;

        report "Test finished";
        sim_done <= true;
        wait;
    end process;

end sim;