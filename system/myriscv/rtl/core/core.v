module core(

);
fetch u0(
    .pc_4(pc_4),
    .pc(pc),
    .instr(instr)
);

instruction_decoder(
    .instr(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .funct(funct),
);

register_file(
    .read_register1(rs1),
    .read_register2(rs2),
    .write_register(rd),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2),
);

control_logic(
    .pc_4(pc_4),
    .pc(pc),
    .branch(branch),
    .LSUctrl(LSUctrl),
    

);
alu();
lsu();


endmodule