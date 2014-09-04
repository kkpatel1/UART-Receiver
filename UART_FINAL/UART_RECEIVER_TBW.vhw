--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 8.2i
--  \   \         Application : ISE
--  /   /         Filename : UART_RECEIVER_TBW.vhw
-- /___/   /\     Timestamp : Tue Apr 15 20:16:24 2014
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: UART_RECEIVER_TBW
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY UART_RECEIVER_TBW IS
END UART_RECEIVER_TBW;

ARCHITECTURE testbench_arch OF UART_RECEIVER_TBW IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT UART_Receiver
        PORT (
            SER_IN : In std_logic;
            RESET : In std_logic;
            OUT16O : Out std_logic_vector (15 DownTo 0);
            CLK : In std_logic;
            statusOUT : Out std_logic;
            ERROR : Out std_logic
        );
    END COMPONENT;

    SIGNAL SER_IN : std_logic := '1';
    SIGNAL RESET : std_logic := '0';
    SIGNAL OUT16O : std_logic_vector (15 DownTo 0) := "0000000000000000";
    SIGNAL CLK : std_logic := '0';
    SIGNAL statusOUT : std_logic := '0';
    SIGNAL ERROR : std_logic := '0';

    SHARED VARIABLE TX_ERROR : INTEGER := 0;
    SHARED VARIABLE TX_OUT : LINE;

    constant PERIOD : time := 20 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 0 ns;

    BEGIN
        UUT : UART_Receiver
        PORT MAP (
            SER_IN => SER_IN,
            RESET => RESET,
            OUT16O => OUT16O,
            CLK => CLK,
            statusOUT => statusOUT,
            ERROR => ERROR
        );

        PROCESS    -- clock process for CLK
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                CLK <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                CLK <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            PROCEDURE CHECK_ERROR(
                next_ERROR : std_logic;
                TX_TIME : INTEGER
            ) IS
                VARIABLE TX_STR : String(1 to 4096);
                VARIABLE TX_LOC : LINE;
                BEGIN
                IF (ERROR /= next_ERROR) THEN
                    STD.TEXTIO.write(TX_LOC, string'("Error at time="));
                    STD.TEXTIO.write(TX_LOC, TX_TIME);
                    STD.TEXTIO.write(TX_LOC, string'("ns ERROR="));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, ERROR);
                    STD.TEXTIO.write(TX_LOC, string'(", Expected = "));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, next_ERROR);
                    STD.TEXTIO.write(TX_LOC, string'(" "));
                    TX_STR(TX_LOC.all'range) := TX_LOC.all;
                    STD.TEXTIO.writeline(RESULTS, TX_LOC);
                    STD.TEXTIO.Deallocate(TX_LOC);
                    ASSERT (FALSE) REPORT TX_STR SEVERITY ERROR;
                    TX_ERROR := TX_ERROR + 1;
                END IF;
            END;
            PROCEDURE CHECK_OUT16O(
                next_OUT16O : std_logic_vector (15 DownTo 0);
                TX_TIME : INTEGER
            ) IS
                VARIABLE TX_STR : String(1 to 4096);
                VARIABLE TX_LOC : LINE;
                BEGIN
                IF (OUT16O /= next_OUT16O) THEN
                    STD.TEXTIO.write(TX_LOC, string'("Error at time="));
                    STD.TEXTIO.write(TX_LOC, TX_TIME);
                    STD.TEXTIO.write(TX_LOC, string'("ns OUT16O="));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, OUT16O);
                    STD.TEXTIO.write(TX_LOC, string'(", Expected = "));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, next_OUT16O);
                    STD.TEXTIO.write(TX_LOC, string'(" "));
                    TX_STR(TX_LOC.all'range) := TX_LOC.all;
                    STD.TEXTIO.writeline(RESULTS, TX_LOC);
                    STD.TEXTIO.Deallocate(TX_LOC);
                    ASSERT (FALSE) REPORT TX_STR SEVERITY ERROR;
                    TX_ERROR := TX_ERROR + 1;
                END IF;
            END;
            PROCEDURE CHECK_statusOUT(
                next_statusOUT : std_logic;
                TX_TIME : INTEGER
            ) IS
                VARIABLE TX_STR : String(1 to 4096);
                VARIABLE TX_LOC : LINE;
                BEGIN
                IF (statusOUT /= next_statusOUT) THEN
                    STD.TEXTIO.write(TX_LOC, string'("Error at time="));
                    STD.TEXTIO.write(TX_LOC, TX_TIME);
                    STD.TEXTIO.write(TX_LOC, string'("ns statusOUT="));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, statusOUT);
                    STD.TEXTIO.write(TX_LOC, string'(", Expected = "));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, next_statusOUT);
                    STD.TEXTIO.write(TX_LOC, string'(" "));
                    TX_STR(TX_LOC.all'range) := TX_LOC.all;
                    STD.TEXTIO.writeline(RESULTS, TX_LOC);
                    STD.TEXTIO.Deallocate(TX_LOC);
                    ASSERT (FALSE) REPORT TX_STR SEVERITY ERROR;
                    TX_ERROR := TX_ERROR + 1;
                END IF;
            END;
            BEGIN
                -- -------------  Current Time:  89ns
                WAIT FOR 89 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  209ns
                WAIT FOR 120 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  251ns
                WAIT FOR 42 ns;
                CHECK_statusOUT('1', 251);
                -- -------------------------------------
                -- -------------  Current Time:  289ns
                WAIT FOR 38 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  529ns
                WAIT FOR 240 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  609ns
                WAIT FOR 80 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  789ns
                WAIT FOR 180 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  869ns
                WAIT FOR 80 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  989ns
                WAIT FOR 120 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  1169ns
                WAIT FOR 180 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  1609ns
                WAIT FOR 440 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  1689ns
                WAIT FOR 80 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  1691ns
                WAIT FOR 2 ns;
                CHECK_statusOUT('0', 1691);
                CHECK_OUT16O("1110110110011111", 1691);
                -- -------------------------------------
                -- -------------  Current Time:  1969ns
                WAIT FOR 278 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  2011ns
                WAIT FOR 42 ns;
                CHECK_statusOUT('1', 2011);
                -- -------------------------------------
                -- -------------  Current Time:  2089ns
                WAIT FOR 78 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  2149ns
                WAIT FOR 60 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  2229ns
                WAIT FOR 80 ns;
                RESET <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  2231ns
                WAIT FOR 2 ns;
                CHECK_statusOUT('0', 2231);
                CHECK_OUT16O("0000000000000000", 2231);
                -- -------------------------------------
                -- -------------  Current Time:  2429ns
                WAIT FOR 198 ns;
                RESET <= '0';
                -- -------------------------------------
                WAIT FOR 1591 ns;

                IF (TX_ERROR = 0) THEN
                    STD.TEXTIO.write(TX_OUT, string'("No errors or warnings"));
                    STD.TEXTIO.writeline(RESULTS, TX_OUT);
                    ASSERT (FALSE) REPORT
                      "Simulation successful (not a failure).  No problems detected."
                      SEVERITY FAILURE;
                ELSE
                    STD.TEXTIO.write(TX_OUT, TX_ERROR);
                    STD.TEXTIO.write(TX_OUT,
                        string'(" errors found in simulation"));
                    STD.TEXTIO.writeline(RESULTS, TX_OUT);
                    ASSERT (FALSE) REPORT "Errors found during simulation"
                         SEVERITY FAILURE;
                END IF;
            END PROCESS;

    END testbench_arch;

