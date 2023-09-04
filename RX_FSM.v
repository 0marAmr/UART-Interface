module RX_FSM (
    input wire          CLK,                 // RX Clock input signal
    input wire          RST,                 // 
    input wire          RX_IN,
    input wire          PAR_EN,
    input wire   [2:0]  bit_cnt,
    input wire          sampling_done,                    //edge_cnt,
    input wire          strt_glitch,
    input wire          par_err,
    input wire          stp_err,
    output reg          stp_chk_en,
    output reg          strt_chk_en,
    output reg          par_chk_en,
    output reg          deser_en,
    output reg          data_samp_en,
    output reg          enable,
    output reg          Data_Valid
);

    localparam STATE_REG_WIDTH = 3;  /*6 states*/
    reg [STATE_REG_WIDTH-1:0] current_state, next_state;

    localparam  [STATE_REG_WIDTH-1:0]   IDLE            = 3'b000,
                                        START_CHK       = 3'b001,
                                        DESERIALIZE     = 3'b010,
                                        PARITY_CHK      = 3'b011,
                                        STOP_CHK        = 3'b100,
                                        OUTPUT          = 3'b101;


    /*State Transition*/
    always @(posedge CLK or negedge RST) begin
        if(~RST) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    /*Next State and output logic*/
    always @(*) begin
        /*Defualt Values*/
        stp_chk_en  = 0;
        strt_chk_en = 0;
        par_chk_en  = 0;
        deser_en    = 0;
        data_samp_en = 0;
        enable      = 0;
        case (current_state)
            /*NS Logic*/
            IDLE: begin
                if (RX_IN) begin
                    next_state = IDLE;  /*input bus is high in idle state*/
                end
                else begin
                    next_state = START_CHK; 
                end

            /*OP logic*/
            // default outputs
            end 
            START_CHK: begin
                /*NS Logic*/
                if (strt_glitch) begin
                    next_state = IDLE;
                end
                else if (sampling_done) begin
                    next_state = DESERIALIZE;
                end
                else begin
                    next_state = START_CHK;
                end

                /*OP logic*/
                strt_chk_en = 'b1;
                enable = 'b1;
            end
            DESERIALIZE: begin
                /*NS Logic*/
                if (bit_cnt == 7 && sampling_done) begin
                    if (PAR_EN) begin
                        next_state = PARITY_CHK;
                    end
                    else begin
                        next_state = STOP_CHK;
                    end
                end
                else begin
                    next_state = DESERIALIZE;
                end

                /*OP logic*/
                if (sampling_done) begin
                deser_en = 'b1;
                end
                enable = 'b1;
                data_samp_en = 'b1;
            end
            PARITY_CHK: begin
                /*NS Logic*/
                if (par_err) begin
                    next_state = IDLE;
                end
                else if (sampling_done) begin
                    next_state = STOP_CHK;
                end
                else begin
                    next_state = STOP_CHK;
                end

                /*OP logic*/
                par_chk_en = 'b1;
                enable = 'b1;
                data_samp_en = 'b1;
            end
            STOP_CHK: begin
                /*NS Logic*/
                if (stp_err) begin
                    next_state = IDLE;
                end
                else if (sampling_done) begin
                    next_state = OUTPUT;
                end
                else begin
                    next_state = STOP_CHK;
                end

                /*OP logic*/
                stp_chk_en = 'b1;
                enable = 'b1;
                data_samp_en = 'b1;
            end
            OUTPUT: begin
                /*NS Logic*/
                if(RX_IN) begin
                    next_state = START_CHK;
                end
                else begin
                    next_state = IDLE;
                end

                /*OP logic*/
                Data_Valid = 'b1;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule