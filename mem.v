//distribution asynchronous two port SRAM
module mem(
	rst_n,
	//A port write signals 
	clk_a,
	wrdata_a,
	wraddr_a,
	wrena_n,
	//B port read signals 
	clk_b,
	rdaddr_b,
	rdenb_n,
	rddata_b
	);

//parameters
	parameter ADDR_WIDTH_W=9;
	parameter DATA_WIDTH_W=16;
	parameter DATA_DEPTH_W=512;

	parameter ADDR_WIDTH_R=10;
	parameter DATA_WIDTH_R=8;
	parameter DATA_DEPTH_R=1024;

//ports
	input clk_a;
	input clk_b;
	input rst_n;

	input [DATA_WIDTH_W-1:0]wrdata_a;
	input [ADDR_WIDTH_W-1:0]wraddr_a;
	input wrena_n;

	output [DATA_WIDTH_R-1:0]rddata_b;
	input [ADDR_WIDTH_R-1:0]rdaddr_b;
	input rdenb_n;

//initial wires and regs
	reg    [DATA_WIDTH_R-1:0]rddata;
	assign rddata_b = rddata;

	wire [ADDR_WIDTH_W:0]wraddr_f;
	assign wraddr_f = {wraddr_a,1'b0};
	wire [ADDR_WIDTH_W:0]wraddr_s;
	assign wraddr_s = {wraddr_a,1'b1};

	integer i;
	reg [DATA_WIDTH_R-1:0] mem [DATA_DEPTH_R-1:0];

//write
	always@(posedge clk_a or negedge rst_n) begin 
		if(!rst_n) begin 
			for(i = 0;i < DATA_DEPTH_R;i = i+1)begin
				mem[i] <= 0;
			end
		end 
		else if(wrena_n == 1'b1)begin
			mem[wraddr_f] <= wrdata_a[DATA_WIDTH_W-1:DATA_WIDTH_R];
			mem[wraddr_s] <= wrdata_a[DATA_WIDTH_R-1:0];
		end
	end

//read
	always@(posedge clk_b or negedge rst_n)begin 
		if(!rst_n)begin 
			rddata <= 0;
		end 
		else if(rdenb_n == 1'b1)begin 
			rddata <= mem[rdaddr_b];
		end
		else 
			rddata <= rddata;
	end 

endmodule
