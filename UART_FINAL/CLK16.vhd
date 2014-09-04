library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLK16 is
port (CLK : in std_logic;
		enable: in std_logic:='0';
    CLK16x : out std_logic:='0');
end CLK16;

architecture Behavioral of CLK16 is
signal currentCLK16x : std_logic :='1';
signal count : integer:=1;
begin
process(CLK, enable)
  begin
    if enable='1' then
      if Rising_edge(CLK) then
        if count=1 then
          currentCLK16x <= not currentCLK16x;
          CLK16x<=currentCLK16x;
        end if;
        count <= count-1;
        if count=0 then
          count<=1;
        end if;
      end if;
    end if;
  end process;
end Behavioral;

