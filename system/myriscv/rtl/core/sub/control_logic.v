module control_logic (
    input pc,
    input instr
    input rdata,
    input rs1,
    input rs2,
    input rd,
    input opcode,
    input funct,
    input alu_result,
    
    input REGctrl,

    output pc_4,
    output branch,
    output WDsel,
    
    output read_data1
    output read_data2

    output ALUsel,
    output ALUsrc
    
    output LSUctrl,
    output wdata,
    output wen,
    output addr,
    

);
endmodule