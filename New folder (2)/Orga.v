module Orga(clk,pc,R1,R2,R3,R4,instruction);
input clk ;
output [15:0]pc,R1,R2,R3,R4,instruction ;
reg [15:0]dataout,pc,instruction,R1,R2,R3,R4 ;
reg [15:0]R[0:3] ; // registers 
reg [15:0] mem[0:63] ; // the memory
wire [15:0]r ;
integer op1,op2,des,i,j,firAddress,secAddress,ac ;
reg [15:0]o ;
reg [15:0]p ;
reg [3:0]flags ;
reg [15:0]stack[0:50] ; // reserve address in memory ;
reg [15:0]pointer;
reg [15:0]IDR ;
reg [15:0] ODR ;
// convert binary to integer 




initial
begin 	
//	R[0] <= 16'b0000000000000000 ;
//	R[1] <= 16'b0000000000000000 ;
//	R[2] <= 16'b0000000000000000 ; 
//	R[3] <= 16'b0000000000000000 ; 
//	pc   <= 16'b0000000000000000 ;
//	mem[0] <= 16'b0011000000001000;
//	mem[1] <= 16'b0011000100000100;
//	mem[2] <= 16'b0011000000001001;
//	mem[3] <= 16'b0011000000000010;
//	mem[4] <= 16'b0011000000001000;
//	mem[5] <= 16'b0011000000001000;
//	mem[6] <= 16'b0011000000001000;
	R[0] <= 16'b0000000000000000 ;
	R[1] <= 16'b0000000000000000 ;
	R[2] <= 16'b0000000000000000 ; 
	R[3] <= 16'b0000000000000000 ; 
	pc   <= 16'b0000000000000000 ;
	pointer <= 16'b0000000000000000 ;
	mem[0] <= 16'b0011000000001000;
	mem[1] <= 16'b0011000100000100;
	mem[2] <= 16'b0011000000001001;
	mem[3] <= 16'b0011000000000010;
	mem[4] <= 16'b0011000000001000;
	mem[5] <= 16'b0011000000001000;
	mem[6] <= 16'b0011000000001000;
	mem[7] <= 16'b0111000100000010;
	//mem[8] <= 16'b1100000000000001;
	mem[8] <= 16'b1101000000000001; // cmp R0 , R1
	//mem[9] <= 16'b0100000000001111; // jc 15
	mem[9] <= 16'b1110000000000001; // SL R0 , 1 ; => 0000000000010000 ;
end 
//initial
//begin
//	mem[0] <= 16'b0011000000001000;
//	mem[1] <= 16'b0011000100000100;
//	mem[2] <= 16'b0011000000001001;
//	mem[3] <= 16'b0011000000000010;
//	mem[4] <= 16'b0011000000001000;
//	mem[5] <= 16'b0011000000001000;
//	mem[6] <= 16'b0011000000001000;
//end

 always @ ( posedge clk)
 begin
	if(pc == 16'b0000000000000000 )
	begin
	mem[0] <= 16'b0011000000001000;
	mem[1] <= 16'b0011000100000100;
	mem[2] <= 16'b0011000000001001;
	mem[3] <= 16'b0011000000000010;
	mem[4] <= 16'b0011000000001000;
	mem[5] <= 16'b0011000000001000;
	mem[6] <= 16'b0011000000001000;
	mem[7] <= 16'b0111000100000010;
	//mem[8] <= 16'b1100000000000001;
	mem[8] <= 16'b1101000100000000; // cmp R0 , R1
	//mem[9] <= 16'b0100000000001111; // jc 15
	mem[9] <= 16'b1110000000000001; // SL R0 , 1 ; => 0000000000010000 ;
	end
	instruction <= mem[pc] ;
		
	// opcode 0011 LOAD
if(instruction[15:12] == 4'b0011)
begin 	
		//R[3] <= -3 ;
		//00 mode ->-Immediate Addressing 
		if(instruction[11:10] == 2'b00)
		begin
			//i <= instruction[9:8] ;
			IDR <= instruction[7:0] ;
			R[instruction[9:8]] <= IDR ;
			pc <= pc + 1 ;
		end
		//01 mode - > -Direct Addressing
		if(instruction[11:10] == 2'b01)
		begin
			//i <= instruction[9:8] ; // get the first operand which is a register 
			//firAddress <= instruction[7:0] ; // get the second operand which is a memory address
			IDR <= mem[instruction[7:0]] ;
			R[instruction[9:8]] <= IDR ; //  save the content of the memory at this register
			pc <= pc + 1 ;
		
		end
		//10 mode ->-Indirect Addressing
		if(instruction[11:10] == 2'b10)
		begin
			//i <= instruction[9:8] ; // get the first operand which is a register 
			//firAddress <= instruction[7:0] ; // get the second operand which is a memory address
			//secAddress <= mem[instruction[7:0]] ; //  get the content of memory which is anoother address
			IDR <= mem[mem[instruction[7:0]]] ;
			R[instruction[9:8]] <= IDR ; // save to register
			pc <= pc + 1 ;
		
		end
		//11 mode -> Register Addressing
		if(instruction[11:10] == 2'b11)
		begin
			//i <= instruction[9:8] ; // get the first operand which is a register 
			//j <= instruction[7:0] ; // the second operand [register]
			ODR <= R[instruction[7:0]] ;
			IDR <= ODR ;
			R[instruction[9:8]] <= IDR ;
			pc <= pc + 1 ;

		
		end

end
//*********************************************** LOAD *****************************************************
//opcode 1011 STORE 
else if (instruction[15:12] == 4'b1011)
	begin
		i <= instruction[9:8] ; // get the first operand which is a register (the value of it will be store in the memory)
		firAddress <= instruction[7:0] ; // get the memory address
		mem[firAddress] <= R[i] ;
		pc <= pc + 1 ;
	end 
//********************************************** STORE *************************************************	
//opcode 0111 ADD
else if (instruction[15:12]  == 4'b0111)
	begin
		//00 mode ->-Immediate Addressing 
		if(instruction[11:10] == 2'b00)
		begin
			i <= instruction[9:8] ;
			op1 <= R[i] ;
			op2 <= instruction[7:0] ;
			R[instruction[9:8]] <= R[instruction[9:8]] + instruction[7:0] ; // add immediate
			pc <= pc + 1 ;
			
		end
		//01 mode - > -Direct Addressing
		if(instruction[11:10] == 2'b01)
		begin
			i <= instruction[9:8] ; // get the first operand which is a register 
			firAddress <= instruction[7:0] ; // get the second operand which is a memory address
			op1 <= mem[instruction[7:0]] ; //  save the content of the memory at this register
			op2 <= R[instruction[9:8]] ; // save the old content of the register
			R[instruction[9:8]] <= mem[instruction[7:0]] + R[instruction[9:8]] ; // add the two operands
			pc <= pc + 1 ;
		
		end
		//10 mode ->-Indirect Addressing
		if(instruction[11:10] == 2'b10)
		begin
			i <= instruction[9:8] ; // get the first operand which is a register 
			firAddress <= instruction[7:0] ; // get the second operand which is a memory address
			secAddress <= mem[firAddress] ; //  get the content of memory which is anoother address
			op1 <= mem[secAddress] ; // save to register
			op2 <= R[instruction[9:8]] ; // save the old content of the register 
			R[i] <= op1 + op2 ; // add two operands 
			pc <= pc + 1 ;
		
		end
		//11 mode -> Register Addressing
		if(instruction[11:10] == 2'b11)
		begin
			//o <= instruction[9:8] ; // get the first operand which is a register 
			//p <= instruction[7:0] ; // the second operand [register]
			R[3] <= R[instruction[9:8]] + R[instruction[7:0]] ;
			pc <= pc + 1 ;
			//op1 <= convert(R[])
		end
	end
//******************************************* ADD **********************************************************		
	
	//opcode 1000 SUB
else if (instruction[15:12] == 4'b1000)
	begin
	//00 mode ->-Immediate Addressing 
		if(instruction[11:10] == 2'b00)
		begin
			i <= instruction[9:8] ;
			op1 <= R[i] ;
			op2 <= instruction[7:0] ;
			R[instruction[9:8]] <= R[instruction[9:8]] - instruction[7:0] ; // des <= des - src
			pc <= pc + 1 ;
		end
		//01 mode - > -Direct Addressing
		if(instruction[11:10] == 2'b01)
		begin
			i <= instruction[9:8] ; // get the first operand which is a register 
			firAddress <= instruction[7:0] ; // get the second operand which is a memory address
			op1 <= mem[firAddress] ; //  save the content of the memory at this register
			op2 <= R[i] ; // save the old content of the register
			R[i] <= op1 - op2 ; // add the two operands
			pc <= pc + 1 ;
		end
		//10 mode ->-Indirect Addressing
		if(instruction[11:10] == 2'b10)
		begin
			i <= instruction[9:8] ; // get the first operand which is a register 
			firAddress <= instruction[7:0] ; // get the second operand which is a memory address
			secAddress <= mem[firAddress] ; //  get the content of memory which is anoother address
			op1 <= mem[secAddress] ; // save to register
			op2 <= R[i] ; // save the old content of the register 
			R[i] <= op1 - op2 ; // add two operands 
			pc <= pc + 1 ;
		
		end
		//11 mode -> Register Addressing
		if(instruction[11:10] == 2'b11)
		begin
			i <= instruction[9:8] ; // get the first operand which is a register 
			j <= instruction[7:0] ; // the second operand [register]
			op1 <= R[i] ;
			op2 <= R[j] ;
			R[instruction[9:8]] <= R[instruction[9:8]] - R[instruction[7:0]] ;
			pc <= pc + 1 ;

		end
		
	 
	end
	//*********************************************** SUB ***********************************************
	//opcode 1100 JMP 
else if(instruction[15:12] == 4'b1100)
	begin
		// just immediate addressing 
		pc <= instruction[7:0] ;
	
	end 
	////////////////////////////////////////////// JMP ***********************************************8
	//opcode CMP 1101
else if (instruction[15:12] == 4'b1101)
	begin
		if(instruction[9:8] < instruction[7:0])
		begin
			flags[1:0] <= 2'b11 ;
			
		end
		else if(instruction[9:8] == instruction[7:0])
		begin
			flags[3:2] <= 2'b11 ;
		end
		else
		begin
			flags[3:0] <= 4'b0000;
		end
		pc <= pc + 1 ;
		
	end
	//********************************************* CMP *********************************************

	//opcode 0100 JC
else if (instruction[15:12] == 4'b0100)
begin
		if(flags[1:0] == 2'b11)
		begin
			pc <= instruction[7:0] ;
		end
		
	end 
	
	//opcode 0101 JZ
else if (instruction[15:12] == 4'b0101)
begin
		if(flags[3:0] == 2'b11)
		begin
			pc <= instruction[7:0] ;
		end
		
	end 
	//opcode 1110 SL
else if (instruction[15:12] == 4'b1110)
begin
		//R[instruction[9:8]] << instruction[7:0] => op1 ;
		 R[instruction[9:8]] <= R[instruction[9:8]] << instruction[7:0]  ;
	end 
	//opcode 1111 SR
else if (instruction[15:12] == 4'b1111)
begin
		R[instruction[9:8]] <= R[instruction[9:8]] >> instruction[7:0]  ;
	end 
	//opcode 0000 push
else if (instruction[15:12] == 4'b0000)
begin
		stack[pointer] <= R[instruction[9:8]] ;
		pointer <= pointer + 1 ;
		
	end 
	//opcode 0001 pull
else if (instruction[15:12] == 4'b0001)
begin
		if(pointer != 0)
		begin
			pointer <= pointer - 1 ;
			R[instruction[9:8]] <= stack[pointer] ;
		end
	
	end 
	//opcode 1010 out 
else if (instruction[15:12] == 4'b1010)
begin
		ODR <= R[instruction[9:8]] ;
	
	end
	 
	//opcode 1001 IN
else if (instruction[15:12] == 4'b1001)
begin
		
		R[instruction[9:8]] <= IDR ;
	end 
	// maping register file to variable registers
	R1 <= R[0] ; 
	R2 <= R[1] ;
	R3 <= R[2] ;
	R4 <= R[3] ;
	
	
	
	end
	endmodule  
	