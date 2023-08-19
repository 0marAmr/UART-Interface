module UART (
    input wire CLK, RST,
    input wire Data_Valid, PAR_EN, PAR_TYP,
    input wire [7:0] P_DATA,
    output wire TX_OUT, busy
);
    
    wire [1:0] mux_sel; 

    TX_FSM U0_FSM(
        .CLK(CLK),
        .RST(RST),
        .Data_Valid(Data_Valid),
        .PAR_EN(PAR_EN),
        .ser_done(ser_done),
        .ser_en(ser_en),
        .busy(busy),
        .mux_sel(mux_sel)
    );

    TX_SERIALIZER U0_SER (
        .CLK(CLK),
        .RST(RST),
        .ser_en(ser_en),
        .Data_Valid(Data_Valid),
        .busy(busy),
        .P_DATA(P_DATA),
        .ser_done(ser_done),
        .ser_data(ser_data)
    );

    TX_PARITY_CALC U0_PAR_CALC (
        .CLK(CLK),
        .RST(RST),
        .Data_Valid(Data_Valid),
        .PAR_TYP(PAR_TYP),
        .P_DATA(P_DATA),
        .par_bit(par_bit)
    );

    TX_OUTPUT U0_OUTPUT(
        .CLK(CLK),
        .RST(RST),
        .mux_sel(mux_sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .busy(busy),
        .TX_OUT(TX_OUT)
    );

endmodule