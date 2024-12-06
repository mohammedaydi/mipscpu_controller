module Controller_TB;

  // Inputs
  reg [4:0] opcode;
  reg Distination;
  reg carryFlag;
  reg zeroFlag;
  reg clk;
  reg Reset_in;
  // Outputs
  wire Reset_out;
  wire [3:0] Stat_tst_out;
  wire ALU_MUX;
  wire [3:0] ALU_OP;
  wire PC_INC;
  wire PC_LOAD;
  wire IR_WR_SIGNAL;
  wire RAM_RD;
  wire RAM_WR;
  wire FLAG_WR_SIGNAL;
  wire RAM_MUX;
  wire MDR_WR_SIGNAL;
  wire A_WR_SIGNAL;
  wire ALU_EN;

  // Instantiate the Unit Under Test (UUT)
  controller_verilog uut (
    .opcode(opcode),
    .Distination(Distination),
    .carryFlag(carryFlag),
    .zeroFlag(zeroFlag),
    .clk(clk),
    .Reset_in(Reset_in),
    .Reset_out(Reset_out),
    .Stat_tst_out(Stat_tst_out),
    .ALU_MUX(ALU_MUX),
    .ALU_OP(ALU_OP),
    .PC_INC(PC_INC),
    .PC_LOAD(PC_LOAD),
    .IR_WR_SIGNAL(IR_WR_SIGNAL),
    .RAM_RD(RAM_RD),
    .RAM_WR(RAM_WR),
    .FLAG_WR_SIGNAL(FLAG_WR_SIGNAL),
    .RAM_MUX(RAM_MUX),
    .MDR_WR_SIGNAL(MDR_WR_SIGNAL),
    .A_WR_SIGNAL(A_WR_SIGNAL),
    .ALU_EN(ALU_EN)
  );

  // Clock process definitions
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // Stimulus process
  initial begin
  	$dumpfile("dump.vcd");
    $dumpvars;
    // hold reset state for 100 ns.
    #100 Reset_in = 1;

    #10 Reset_in = 0;

    // insert stimulus her

    opcode = 5'b01001;  // ADDAR GOUP A&B INSTRUCTION
    Distination = 1'b0;
    #4000;

//     #30 opcode = 5'b01001;  // ADDAR GOUP A&B INSTRUCTION
//     Distination = 1'b1;

//     #30 opcode = 5'b00101;  // INCR GROUP B INSRICTION

//     #30 opcode = 5'b10110;  // JZ GROUP C INSRICTION
//     zeroFlag = 1'b0;

//     #30 opcode = 5'b10110;  // JZ GROUP C INSRICTION
//     zeroFlag = 1'b1;

//     #30 opcode = 5'b00011;  // MOVIRA GROUP D INSRICTION

//     #30 opcode = 5'b00100;  // MOVIAR GROUP E INSRICTION

    #100 $finish;
  end
endmodule
