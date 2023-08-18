module TX_PARITY_CALC #(
    parameter DATA_WIDTH = 8
)(
    input wire CLK, RST,
    input wire Data_Valid,
    input wire PAR_TYP,
    input wire [DATA_WIDTH-1:0] P_DATA,
    output reg par_bit
);
    
    localparam  EVEN_PARITY  = 'b1;

    always @(posedge clk or negedge RST) begin
        if (~RST) begin
            par_bit <= 0;
        end
        else if (Data_Valid) begin
            if (PAR_TYP == EVEN_PARITY) begin
                par_bit = ^P_DATA;
            end
            else  begin /*Odd Parity*/
                par_bit = ~^P_DATA;
            end
        end
    end
endmodule