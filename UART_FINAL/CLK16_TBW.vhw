--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 8.2i
--  \   \         Application : ISE
--  /   /         Filename : CLK16_TBW.vhw
-- /___/   /\     Timestamp : Sun Apr 13 20:40:53 2014
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: CLK16_TBW
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY CLK16_TBW IS
END CLK16_TBW;

ARCHITECTURE testbench_arch OF CLK16_TBW IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT CLK16
        PORT (
            CLK : In std_logic;
            enable : In std_logic;
            CLK16x : Out std_logic
        );
    END COMPONENT;

    SIGNAL CLK : std_logic := '0';
    SIGNAL enable : std_logic := '0';
    SIGNAL CLK16x : std_logic := '0';

    SHARED VARIABLE TX_ERROR : INTEGER := 0;
    SHARED VARIABLE TX_OUT : LINE;

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 0 ns;

    BEGIN
        UUT : CLK16
        PORT MAP (
            CLK => CLK,
            enable => enable,
            CLK16x => CLK16x
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
            PROCEDURE CHECK_CLK16x(
                next_CLK16x : std_logic;
                TX_TIME : INTEGER
            ) IS
                VARIABLE TX_STR : String(1 to 4096);
                VARIABLE TX_LOC : LINE;
                BEGIN
                IF (CLK16x /= next_CLK16x) THEN
                    STD.TEXTIO.write(TX_LOC, string'("Error at time="));
                    STD.TEXTIO.write(TX_LOC, TX_TIME);
                    STD.TEXTIO.write(TX_LOC, string'("ns CLK16x="));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, CLK16x);
                    STD.TEXTIO.write(TX_LOC, string'(", Expected = "));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, next_CLK16x);
                    STD.TEXTIO.write(TX_LOC, string'(" "));
                    TX_STR(TX_LOC.all'range) := TX_LOC.all;
                    STD.TEXTIO.writeline(RESULTS, TX_LOC);
                    STD.TEXTIO.Deallocate(TX_LOC);
                    ASSERT (FALSE) REPORT TX_STR SEVERITY ERROR;
                    TX_ERROR := TX_ERROR + 1;
                END IF;
            END;
            BEGIN
                -- -------------  Current Time:  685ns
                WAIT FOR 685 ns;
                enable <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  715ns
                WAIT FOR 30 ns;
                CHECK_CLK16x('1', 715);
                -- -------------------------------------
                -- -------------  Current Time:  1115ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 1115);
                -- -------------------------------------
                -- -------------  Current Time:  1515ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 1515);
                -- -------------------------------------
                -- -------------  Current Time:  1915ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 1915);
                -- -------------------------------------
                -- -------------  Current Time:  2315ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 2315);
                -- -------------------------------------
                -- -------------  Current Time:  2715ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 2715);
                -- -------------------------------------
                -- -------------  Current Time:  3115ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 3115);
                -- -------------------------------------
                -- -------------  Current Time:  3515ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 3515);
                -- -------------------------------------
                -- -------------  Current Time:  3915ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 3915);
                -- -------------------------------------
                -- -------------  Current Time:  4315ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 4315);
                -- -------------------------------------
                -- -------------  Current Time:  4715ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 4715);
                -- -------------------------------------
                -- -------------  Current Time:  5115ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 5115);
                -- -------------------------------------
                -- -------------  Current Time:  5515ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 5515);
                -- -------------------------------------
                -- -------------  Current Time:  5915ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 5915);
                -- -------------------------------------
                -- -------------  Current Time:  6315ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 6315);
                -- -------------------------------------
                -- -------------  Current Time:  6715ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 6715);
                -- -------------------------------------
                -- -------------  Current Time:  7115ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 7115);
                -- -------------------------------------
                -- -------------  Current Time:  7515ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 7515);
                -- -------------------------------------
                -- -------------  Current Time:  7915ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 7915);
                -- -------------------------------------
                -- -------------  Current Time:  8315ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 8315);
                -- -------------------------------------
                -- -------------  Current Time:  8715ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 8715);
                -- -------------------------------------
                -- -------------  Current Time:  9115ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 9115);
                -- -------------------------------------
                -- -------------  Current Time:  9515ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('1', 9515);
                -- -------------------------------------
                -- -------------  Current Time:  9915ns
                WAIT FOR 400 ns;
                CHECK_CLK16x('0', 9915);
                -- -------------------------------------
                WAIT FOR 285 ns;

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

