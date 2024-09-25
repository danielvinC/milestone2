module alu_tb;
    logic clk;
    logic [31:0] rs1, rs2;
    logic [3:0] op;
    logic [31:0] rd;
 
    alu alu(
        rs1,
        rs2,
        op, 
        rd
    );

initial clk = 1'b0;
localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;


initial begin
    rs1 = 32'h0a17_0000;
    rs2 = 32'hff0c_0000;
    op = 4'b0110; //and
    #(CLK_PERIOD)
    op = 4'b0010; //
    #(CLK_PERIOD)
    op = 4'b0011;
    #(CLK_PERIOD)
    rs1 = 32'hfa17_0000;
    rs2 = 32'd16;
    op = 4'b1000;
    #(CLK_PERIOD)
    $stop(2);
end

endmodule