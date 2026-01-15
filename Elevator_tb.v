`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2025 16:30:12
// Design Name: 
// Module Name: Elevator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Elevator_tb();
   
    reg clk;
    reg reset;
    reg req;
    reg [1:0] req_floor;
    wire [1:0] current_floor;
    wire moving_up;
    wire moving_down;
    wire door_open;

    //================================================
    // DUT (Design Under Test) Instance
    //================================================
    Elevator uut (
        .clk(clk),
        .reset(reset),
        .req(req),
        .req_floor(req_floor),
        .current_floor(current_floor),
        .moving_up(moving_up),
        .moving_down(moving_down),
        .door_open(door_open)
    );

    //================================================
    // Clock Generation : 10 ns period (100 MHz)
    //================================================
    initial begin
        clk = 0;
    end

    always begin
        #5 clk = ~clk;   // Toggle every 5 ns -> 10 ns period
    end

    //================================================
    // Stimulus
    //================================================
    initial begin
        // Initialize inputs
        reset     = 1;
        req       = 0;
        req_floor = 2'd0;

        // Hold reset for some time
        #20;
        reset = 0;

        // --------------------------------------------
        // 1st request: Go from floor 0 to floor 2
        // --------------------------------------------
        #20;                 // wait a bit after reset
        req       = 1;
        req_floor = 2'd2;    // request floor 2
        #10;
        req       = 0;       // release request

        // Wait enough time for elevator to reach floor 2
        #200;

        // --------------------------------------------
        // 2nd request: Go from floor 2 to floor 1
        // --------------------------------------------
        req       = 1;
        req_floor = 2'd1;    // request floor 1
        #10;
        req       = 0;

        // Wait enough time for elevator to reach floor 1
        #200;

        // Finish simulation
        $stop;   // or $finish;  both work in Vivado xsim
    end

endmodule






