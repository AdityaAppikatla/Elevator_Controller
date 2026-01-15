`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2025 16:28:13
// Design Name: 
// Module Name: Elevator
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


module Elevator(

    input  wire       clk,
    input  wire       reset,
    input  wire       req,              // request signal
    input  wire [1:0] req_floor,        // requested floor: 00,01,10
    output reg  [1:0] current_floor,    // current floor
    output reg        moving_up,
    output reg        moving_down,
    output reg        door_open
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam MOVE      = 2'b01;
    localparam DOOR_OPEN = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] target_floor;

    //================================================
    // Sequential logic: state and current_floor
    //================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state         <= IDLE;
            current_floor <= 2'd0;   // start at floor 0
            target_floor  <= 2'd0;
        end else begin
            state <= next_state;

            // Update floor while moving
            if (state == MOVE) begin
                if (current_floor < target_floor)
                    current_floor <= current_floor + 1;
                else if (current_floor > target_floor)
                    current_floor <= current_floor - 1;
            end
        end
    end

    //================================================
    // Combinational logic: next_state and outputs
    //================================================
    always @(*) begin
        // default outputs
        next_state  = state;
        moving_up   = 1'b0;
        moving_down = 1'b0;
        door_open   = 1'b0;

        case (state)
            IDLE: begin
                // wait for request
                if (req) begin
                    next_state = MOVE;
                end
            end

            MOVE: begin
                if (current_floor < target_floor) begin
                    moving_up  = 1'b1;
                    next_state = MOVE;
                end else if (current_floor > target_floor) begin
                    moving_down = 1'b1;
                    next_state  = MOVE;
                end else begin
                    // reached target floor
                    next_state = DOOR_OPEN;
                end
            end

            DOOR_OPEN: begin
                door_open  = 1'b1;
                // keep door open for one clock, then go idle
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    //================================================
    // Latch target_floor when request arrives in IDLE
    //================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            target_floor <= 2'd0;
        end else begin
            if (state == IDLE && req) begin
                target_floor <= req_floor;
            end
        end
    end

endmodule
