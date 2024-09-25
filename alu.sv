module alu(
    input logic [31:0] operand_a,
    input logic [31:0] operand_b,
    input logic [3:0] alu_op,
    output logic [31:0] alu_data
);

    function logic [31:0] sum(input logic [31:0] rs1, input logic [31:0] rs2, input logic addsub);
        logic [31:0] condinvb;
        condinvb = addsub ? ~ rs2 : rs2; // Two's complement of operand_b
        sum = rs1 + condinvb + addsub;
    endfunction: sum

    function logic [31:0] slt(input logic [31:0] rs1, input logic [31:0] rs2, input logic sgn);
        logic v, sgn1, sgn2;
        logic [32:0] comp_reg;
        sgn1 = sgn & rs1[31];
        sgn2 = sgn & rs2[31];
        comp_reg = {sgn2, rs1} + ~({sgn2, rs2}) + 1'b1;
        v = ~(1'b1 ^ sgn1 ^ sgn2) & (sgn1 ^ comp_reg[32]);
        slt = {31'b0, v ^ comp_reg[32]};
    endfunction: slt 

    always_comb begin : alu
        alu_data = 32'b0;
        case (alu_op) 
            4'b0000: 
                //add
                alu_data = sum(operand_a, operand_b, alu_op[0]);
            4'b0000: 
                //subtract
                alu_data = sum(operand_a, operand_b, alu_op[0]);
            4'b0010: 
                //set less than signed
                alu_data = slt(operand_a, operand_b, ~alu_op[0]);
            4'b0011: 
                //set less than unsigned
                alu_data = slt(operand_a, operand_b, ~alu_op[0]);
            4'b0100: 
                //XOR 
                alu_data = operand_a ^ operand_b;
            4'b0101: 
                //OR
                alu_data = operand_a | operand_b;
            4'b0110: 
                //AND
                alu_data = operand_a & operand_b;
            4'b0111: 
                //SLL
                alu_data = operand_a << operand_b[4:0];
            4'b1000: 
                //SRL
                alu_data = operand_a >> operand_b[4:0];
            4'b1001: 
                //SRA
                alu_data = operand_a >>> operand_b[4:0];
            default: 
                alu_data = 32'b0;
        endcase
    end
endmodule