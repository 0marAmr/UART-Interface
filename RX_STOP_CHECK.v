module RX_STOP_CHECK (
    input wire CLK,
    input wire RST,
    input wire stp_chk_en,
    input wire sampled_bit,
    output reg stp_err
);
    
    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            stp_err <= 'b0;
        end
        else if(stp_chk_en) begin
            // stop bit must be 1
            stp_err <= ~sampled_bit;
        end
    end
endmodule