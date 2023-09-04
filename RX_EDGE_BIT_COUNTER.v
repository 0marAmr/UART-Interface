module RX_EDGE_BIT_COUNTER (
    input wire          CLK,                 // RX Clock input signal
    input wire          RST,                 
    input wire          edge_count_enable,
    input wire          bit_count_enable,
    input wire  [4:0]   Prescale,
    output wire [2:0]   bit_cnt,
    output wire [4:0]   edge_cnt
);
    
    wire [4:0] half_prescale;
    assign half_prescale_p1 = (Prescale >> 1'b1) + 1'b1;
    
    reg [4:0] edge_cnt_reg;
    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            edge_cnt_reg <= 'b0000;
        end
        else if(edge_count_enable) begin
            if (edge_cnt_reg ==half_prescale_p1) begin
                edge_cnt_reg <= 'b0000;
            end
            else begin
                edge_cnt_reg <= edge_cnt_reg + 'b1;
            end
        end
    end

    reg [2:0] bit_cnt_reg;
    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            bit_cnt_reg <= 'b000;
        end
        else if((edge_cnt_reg ==half_prescale_p1) && bit_count_enable) begin
                bit_cnt_reg <= bit_cnt_reg + 1'b1;
            end
        end

        assign edge_cnt = edge_cnt_reg;
        assign bit_cnt = bit_cnt_reg;

endmodule