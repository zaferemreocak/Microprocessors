module CPU(/*clk, */din, grounds, grounds1, display);

reg [1:0] state;
reg [15:0] memory [0:255];
wire[15:0] aluinr, aluinl;
wire[3:0] aluop;
reg[15:0] pc, aluout, ir;
reg [15:0] regbank[0:3];

//input wire clk;
reg clk;	//to test the code
input wire[15:0] din;
output reg[3:0] grounds;	//each seven segment has 4 bit ground
output reg[6:0] display; //each seven segment has 7 pin to set a value
output [3:0] grounds1;	//connector bits

reg[3:0] data [3:0];	//number to be printed on display
reg[1:0] count;		//which data register to be displayed
reg[25:0] clk1;		//to modify speed of 7-segments

localparam FETCH = 2'b00;	//localparam means the value cannot be changed
localparam LDI = 2'b01;
localparam ALU = 2'b10;

always @(posedge clk1[15]) //25 slow //19 wavy //15 perfect
begin
    grounds<={grounds[2:0],grounds[3]};	//shift the right-most side bit to one left.
    count<=count+1;
end

always @(posedge clk)
	clk1 <= clk1 + 1;

//each data register has 4-bit wide data and 16 different possible output
always @(*)
    case(data[count])
        0:display=7'b1111110; //starts with a, ends with g
        1:display=7'b0110000;
        2:display=7'b1101101;
        3:display=7'b1111001;
        4:display=7'b0110011;
        5:display=7'b1011011;
        6:display=7'b1011111;
        7:display=7'b1110000;
        8:display=7'b1111111;
        9:display=7'b1111011;
        4'ha:display=7'b1110111;
        4'hb:display=7'b0011111;
        4'hc:display=7'b1001110;
        4'hd:display=7'b0111101;
        4'he:display=7'b1001111;
        4'hf:display=7'b1000111;
        default display=7'b1111111;
    endcase

always @*
    begin
    data[0]=din[15:12];	//left-most 7-segment displayer
    data[1]=din[11:8];	//second left-most 7-segment displayer
    data[2]=din[7:4];	//second right-most 7-segment displayer
    data[3]=din[3:0];	//right-most 7-segment displayer
    end

// this part assignes reg0 hex bits to each 7-segment displayer
/*
always @(posedge clk)
	begin
	data[3] = regbank[0][3:0];	//first 4 bits of reg #0 is assigned
	data[2] = regbank[0][7:4];	//second 4 bits of reg #0 is assigned
	data[1] = regbank[0][11:8];	//third 4 bits of reg #0 is assigned
	data[0] = regbank[0][15:12];	//fourth 4 bits of reg #0 is assigned
	end
*/

always @(posedge clk)
	case(state)

		FETCH:
		begin
			state <= memory[pc][15:14];
			ir <= memory[pc][15:0];
			pc <= pc+1;
		end
		
		LDI:
		begin
			state <= FETCH;
			regbank[ ir[1:0] ] <= memory[pc];
			pc <= pc+1;
		end
		
		ALU:
		begin
			state <= FETCH;
			regbank[ ir[1:0] ] <= aluout;
		end
	endcase

assign aluinl = regbank[ir[7:6]];	//src #1 register
assign aluinr = regbank[ir[3:2]];	//src #2 register
assign aluop  = ir[11:8];		//aluop

always @*
	case( aluop )
		4'h0:	aluout = aluinl + aluinr;	//add
		4'h1:	aluout = aluinl - aluinr;	//sub
		4'h2:	aluout = aluinl & aluinr;	//and
		4'h3:	aluout = aluinl | aluinr;	//or
		4'h4:	aluout = aluinl ^ aluinr;	//xor
		4'h5:	aluout = ~aluinl;		//not
		4'h6:	aluout = aluinl;		//mov
		4'h7:	aluout = aluinl + 16'h0001;	//inc
		4'h8:	aluout = aluinl - 16'h0001;	//dec
		default: 	aluout = 0;
	endcase

initial begin
	//C:/Modeltech_pe_edu_10.4a/examples/
	$readmemh("RAM.txt", memory);
	state = FETCH;	//start with fetch operation
	pc = 8'b00000000;	//set PC to 0
	

	data[0]=4'h1;
	data[1]=4'h9;
	data[2]=4'ha;
	data[3]=4'hc;

	count = 2'b0;
	grounds=4'b1110;
	clk1=0;

	end

//set clock - purpose of testing only
initial begin
clk=0;
//10 time unit for each clock cycle
forever #5 clk = ~clk;
end

endmodule
