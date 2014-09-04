--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 8.2i
--  \   \         Application : ISE
--  /   /         Filename : Test_TBW.vhw
-- /___/   /\     Timestamp : Tue Apr 15 20:28:20 2014
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: Test_TBW
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY Test_TBW IS
END Test_TBW;

ARCHITECTURE testbench_arch OF Test_TBW IS
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

    SIGNAL SER_IN : std_logic := '0';
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
                -- -------------  Current Time:  9ns
                WAIT FOR 9 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  249ns
                WAIT FOR 240 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  251ns
                WAIT FOR 2 ns;
                CHECK_statusOUT('1', 251);
                -- -------------------------------------
                -- -------------  Current Time:  389ns
                WAIT FOR 138 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  1209ns
                WAIT FOR 820 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  1369ns
                WAIT FOR 160 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  1691ns
                WAIT FOR 322 ns;
                CHECK_statusOUT('0', 1691);
                CHECK_OUT16O("0111111111100111", 1691);
                -- -------------------------------------
                -- -------------  Current Time:  2329ns
                WAIT FOR 638 ns;
                RESET <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  2331ns
                WAIT FOR 2 ns;
                CHECK_OUT16O("0000000000000000", 2331);
                -- -------------------------------------
                -- -------------  Current Time:  2449ns
                WAIT FOR 118 ns;
                RESET <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  2689ns
                WAIT FOR 240 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  2731ns
                WAIT FOR 42 ns;
                CHECK_statusOUT('1', 2731);
                -- -------------------------------------
                -- -------------  Current Time:  2809ns
                WAIT FOR 78 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  3309ns
                WAIT FOR 500 ns;
                SER_IN <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  3429ns
                WAIT FOR 120 ns;
                SER_IN <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  4171ns
                WAIT FOR 742 ns;
                CHECK_statusOUT('0', 4171);
                CHECK_OUT16O("1111111011111111", 4171);
                -- -------------------------------------
                -- -------------  Current Time:  4569ns
                WAIT FOR 398 ns;
                RESET <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  4571ns
                WAIT FOR 2 ns;
                CHECK_OUT16O("0000000000000000", 4571);
                -- -------------------------------------
                -- -------------  Current Time:  4649ns
                WAIT FOR 78 ns;
                RESET <= '0';
                -- -------------------------------------
                WAIT FOR 1371 ns;

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

