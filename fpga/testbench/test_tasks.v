//                              -*- Mode: Verilog -*-
// Filename        : test_tasks.v
// Description     : Tasks to help test the code
// Author          : Philip Tracton
// Created On      : Fri Dec  4 12:34:28 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Dec  4 12:34:28 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"
`include "simulation_includes.vh"

module test_tasks (/*AUTOARG*/ ) ;

   reg test_case_fail = 0;

   reg test_passed = 1'b0;
   reg test_failed = 1'b0;
   integer test_count = 0;

   always @(posedge test_passed) begin
      $display("------------------------------------------------------------------------------------------------------------");
`ifdef MODELSIM
      $display("\n\nTEST PASSED @ %d", $time);
`else
      $display("\n\n\033[1;32mTEST PASSED\033[0m  @ %d", $time);
`endif
      #10 $finish;
   end

   always @(posedge test_failed) begin
      $display("------------------------------------------------------------------------------------------------------------");
`ifdef MODELSIM
      $display("\n***** TEST FAILED *****@ %d\n", $time);
`else
      $display("\n\033[1;31m***** TEST FAILED *****\033[0m @ %d\n", $time);
`endif
      #100 $finish;
   end

   //
   // Do not let a test bench just run forever.
   //
   initial begin
      #500000000;
      $display("TEST CASE TIMEOUT @ %d", $time);
      test_failed <= 1'b1;
   end

   /****************************************************************************
    TASK: all_tests_completed
    PARAMETERS:
    OPERATION:
        This task is called at the end of a test case to indicate it is done.
        If the correct number of test cases were executed we indicate this test
        has passed.  Otherwise we indicate failure.

    ***************************************************************************/
   task all_tests_completed;
      begin
         if (`NUMBER_OF_TESTS == test_count) begin
            `TEST_PASSED <= 1;
         end else begin
            $display("INCORRECT NUMBER OF TESTS! Exp: %d  Ran: %d", `NUMBER_OF_TESTS, test_count);
            `TEST_FAILED <= 1;
         end
      end
   endtask // if

   /****************************************************************************
    TASK: compare_values
    PARAMETERS:
        input [8*80:1] display_string;  -- Test to indicate which test this is
        input [31:0]   expected; -- Expected correct value
        input [31:0]   measured; -- Actual measured value

    OPERATION:
        This task is the one called from the test cases.  It checks for bad data (X)
        and compares the expected and measured values.  Sets the pass/fail flag
        and calls the display_results task.

    ***************************************************************************/
   task compare_values;
      input [8*80:1] display_string;
      input [31:0]   expected;
      input [31:0]   measured;

      begin

         if (|measured == 1'bX) begin
            display_results("Data is X", expected, expected, measured);
            `TEST_FAILED <= 1'b1;
         end else begin
            if (expected !== measured) begin
               test_case_fail <= 1;
               //$display("EXP: 0x%h\tMeasure:0x%h", expected, measured);
               #1 display_results(display_string, expected, expected, measured);
            end else begin
               test_case_fail <= 0;
               #1 display_results(display_string, expected, expected, measured);
            end
         end
      end
   endtask // compare_values

   /****************************************************************************
    TASK: compare_range
    PARAMETERS:
    input [8*80:1] display_string;  -- Test to indicate which test this is
    input [31:0]   minimum -- Minimum value
    input [31:0]   maximum -- Minimum value
    input [31:0]   measured  -- Actual measured value

    OPERATION:
        This task is the one called from the test cases.  It checks for bad data (X)
        and compares the expected and measured values.  Sets the pass/fail flag
        and calls the display_results task.

    ***************************************************************************/
   task compare_range;
      input [8*80:1] display_string;
      input [31:0]   minimum;
      input [31:0]   maximum;
      input [31:0]   measured;

      begin
         if (|measured == 1'bX) begin
            display_results("Data is X, 0x%x", minimum, maximum, measured);
            `TEST_FAILED <= 1'b1;
         end else begin
            if ((measured < minimum) || (measured > maximum) ) begin
               test_case_fail <= 1;
               #1 display_results(display_string, minimum, maximum, measured);
            end else begin
               test_case_fail <= 0;
               #1 display_results(display_string, minimum, maximum, measured);
            end
         end // else: !if(|measured == 1'bX)
      end
   endtask // compare_values


   /****************************************************************************
    TASK: display_results
    PARAMETERS:
        input [8*80:1] display_string;  -- Test to indicate which test this is
        input [31:0]   expected; -- Expected correct value
        input [31:0]   measured; -- Actual measured value

    OPERATION:
        This task will display the table of tests with their time stamp,
        test number, string, expected, measured and results.

    ***************************************************************************/
   task display_results;
      input [8*80:1] display_string;
      input [31:0]   minimum;
      input [31:0]   maximum;
      input [31:0]   measured;

      reg [17*8-1:0]     pass_fail;

      begin
         if (test_case_fail) begin
`ifdef MODELSIM
            pass_fail = " *** FAIL *** ";
`else
            pass_fail = "\033[1;31mFAIL\033[0m";
`endif
            `TEST_FAILED <= 1;
         end else begin
`ifdef MODELSIM
            pass_fail = "PASS";
`else
            pass_fail = "\033[1;32mPASS\033[0m";
`endif
         end

         // left justify string
         while (display_string[8*35:8*35-7] == 8'h00)begin
            display_string = {display_string," "};
         end

         if (test_count == 0) begin
            $display("------------------------------------------------------------------------------------------------------------");
            $display("|TIME |Test| \tTest Case \t\t\t\t|Minimum   |\tMaximum    |\tMeasured   | State |");
            $display("------------------------------------------------------------------------------------------------------------");
         end

         test_count <= test_count + 1;
         $display("|%4d |%4d|\t%0s \t|0x%8h |\t0x%8h |\t0x%8h |%s |", $time-1, test_count, display_string, minimum, maximum, measured, pass_fail);
         if (((test_count %10) == 0) && test_count >0) begin
            $display("------------------------------------------------------------------------------------------------------------");
         end


      end

   endtask //


endmodule // test_tasks
