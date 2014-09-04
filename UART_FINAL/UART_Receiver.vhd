library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Receiver is
port(SER_IN : in std_logic := '1';
     RESET : in std_logic;
     OUT16O : out std_logic_vector(15 downto 0) := (others=>'0');
     CLK : in std_logic;
     statusOUT : out std_logic :='0';
     ERROR: out std_logic := '0');
end UART_Receiver;

architecture Behavioral of UART_Receiver is
signal status : std_logic := '0';
signal par : std_logic := '0';
signal OUT16 : std_logic_vector(15 downto 0) := (others=>'0');
signal count : integer := 0;
signal CLK16x : std_logic := '0';
component CLK16
  port(CLK : in std_logic;
        enable : in std_logic:='0';
        CLK16x: out std_logic:='0');
end component;
begin
  CLK16P : CLK16 port map(CLK, '1', CLK16x);
  pmain : process(RESET, SER_IN, CLK16x)
  begin
    if RESET='1' then
      OUT16O <= x"0000";
      OUT16 <= x"0000";
      ERROR <= '0';
      count<=0;
      par<='0';
      status<='0';
      statusOUT <= '0';
    elsif CLK16x'event and CLK16x='1' then
      if status='0' and SER_IN='0' then       --Getting start bit
        status<='1';
        statusOUT <= '1';
        count <=0;
      elsif status='1' and count<16 then    --Count up untill count=16
        count <= count+1;
        OUT16 <= OUT16(14 downto 0) & SER_IN;
        if SER_IN='1' then                      --Changing parity requirement
          par <= not par;    --EVEN PARITY
        end if;
      elsif count=16 and status='1' then        --at count=16, counting up and checking parity
        count<=17;
        if SER_IN=(not par) then
          ERROR <= '1';
          OUT16 <= x"0000";
        end if;
      elsif count=17 and SER_IN='1' and status='1' then --at 17th count,check for SER_IN=1 for IDLE and reset
        OUT16O <= OUT16;
        ERROR <= '0';
        status<='0';
        statusOUT<='0';
      elsif count=17 and SER_IN='0' and status='1' then
        OUT16O <= x"0000";
        ERROR <='1';
        status<='0';
        statusOUT<='0';
      end if;
    end if;
  end process;
end Behavioral;