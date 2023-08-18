module TX_SERIALIZER #(
    parameter DATA_WIDTH = 8
)(
    input wire CLK, RST,
    input wire ser_en, Data_Valid, busy,
    input wire [DATA_WIDTH-1:0] P_DATA,
    output wire ser_done,
    output reg ser_data
);
    
    /*Shift right register*/
    reg [DATA_WIDTH-1:0] serializer;

    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            serializer <=0;
        end
        else if(Data_Valid && ~busy) begin
            serializer <= P_DATA;
        end
        else if (ser_en) begin
            {serializer[DATA_WIDTH-2:0], ser_data} <= serializer; // shift right
        end
    end
    
    /*Counter to count 8 edges*/
    reg [2:0] count;
    always @(posedge CLK or negedge RST ) begin
        if (~RST) begin
            count <= 0;
        end
        else if (ser_en) begin
            count <= count + 1;
        end
        else begin
            count <= 0;
        end
    end

    assign ser_done = &count;

endmodule