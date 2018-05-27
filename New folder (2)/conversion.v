5 2
6 3
10 load R1,[5]		
11 load r2,[6]
12 load r3,0
13 load r4,0
14 cmp r2,0	
15 jz 22
16 add r3,r1
17 jc 20
18 add r2,15    //to decremant r2
19 jump 14
20 add r4,1
21 jump 18
22 store r3,[5]
23 store r4,[6]




module simpleComputer(clock,pc,ir,registers,mbr,flags,mar);
input clock;
output pc,ir,mbr,mar,flags,registers;

reg [15:0] ir,mbr;
reg [15:0] flags;
reg [15:0] registers [4:0];
reg [11:0] pc,mar;

reg [15:0] memory [63:0];
reg [2:0] state;
reg [11:0] stackPointer; //stack 

parameter load = 4'b0011,store=4'b1011,add=4'b0111,jumb=4'b1100,cmp=4'b1101,jc=4'b0100,jz=4'b0101,sl=4'b 1110,sr =4'b 1111 , push = 4'b 0000 , pop = 4'b 0001;
parameter direct = 3'b 000,indirect =3'b 001 , immediate =3'b 010 , registerAddressing = 3'b 011 , stackAddressing = 3'b 100; 

initial begin 
//part 2 table 1 
/* 
memory[10]=16'b 0000011000110110; //load r1 [22]
memory[11]=16'b 0100011001000100; //LOAD R2,4
memory[12]=16'b 0110111000100010; //ADD R1,R2
memory[13]=16'b 0001011000110101; //STORE R1, [21]
memory[22]=16'd 3; //data
*/

//part 2 table 2
/*
memory[10]=16'b 0100011000100011; //load r1 3
memory[11]=16'b 0000111000110101; //add r1 [21]
memory[12]=16'b 0100011001000110; //load r2 6 
memory[13]=16'b 0001101000100010; //cmp r1 r2 
memory[14]=16'b 0000101000001011; // jz
memory[21]=16'd 3;  //data
*/
 
 //part 2 table 3 
 /*
memory[10]=16'b 0010011000110101; //load r1[[21]]
memory[11]=16'b 0001110000100011; //shl r1 3
memory[21]=16'd 22; // data
memory[22]=16'd 3 ;  //data
*/

//part2 table 4
/*
memory[10]=16'b 1000001000000001; //pop r1 
memory[11]=16'b 0001111000100001; //shr r1 1
memory[12]=16'b 1000000000000001; //push r1 
memory[0]=16'd 4; //data in the stack
*/
memory[5]=16'd 3;
memory[6]=16'd 4;
memory[9]=16'b 0100011000000000;
memory[10]=16'b 0000011000100101;
memory[11]=16'b 0000011001000110;
memory[12]=16'b 0100011001100000;
memory[13]=16'b 0100011010000000;
memory[14]=16'b 0111101001000000; //cmp r2.r0
memory[15]=16'b 0000101000010110;	 //jz 22
memory[16]=16'b 0110111001100001;	//add r3,r1
memory[17]=16'b 0000100000010100;	//jc 20
memory[18]=16'b 0100111000000001;	// add r2 , 15
memory[19]=16'b 0001100000001110;	// jump 14
memory[20]=16'b 0100111010000001;	// add r4,1
memory[21]=16'b 0001100000010010;	//jmp 18
memory[22]=16'b 0001011001100101; 	//store r3,[5]
memory[23]=16'b 0001011010000110;	//store r4.[6]

pc=9;
stackPointer = 12'h000; 
state=0;
end

always @ (posedge clock) begin
case (state)
0:begin //fitch 
  mar <= pc;
  state=1;
  end
1:begin //put the instruction in its register
  ir <= memory[mar]; 
  pc <= pc+1;
  state=2;
  end
2:begin  //decode and operant fetch 
	state=3;
	case (ir[12:9]) 
		load : 
		case (ir[15:13])
			direct : mbr <= memory[ir[4:0]];
			indirect : mbr <= memory[memory[ir[4:0]]];
			//immediate no oprant to fetch 
		endcase 
		
		store : mbr <= registers[ir[8:5]];
		
		add :
		case (ir[15:13])
			direct : mbr <= memory[ir[4:0]];
			indirect : mbr <= memory[memory[ir[4:0]]];
			// NO imidiate and register in this state 
		endcase
	
		jumb  : mar = ir [4:0];
		jz  : if(flags[1] == 1)
				mar = ir [4:0]; 
		jc : if(flags[0] == 1)
				mar = ir [4:0];
		cmp :   state=4;
		
		push : if (ir[15:13] == stackAddressing)
				begin 
				stackPointer <= stackPointer+1; 
				memory[stackPointer] <= registers[ir[4:0]];
				state = 0 ; 
				end 
		pop : if (ir[15:13] == stackAddressing)
				begin 
				  registers[ir[4:0]] <= memory[stackPointer];
				stackPointer <= stackPointer-1; 
				state = 0 ; 
				end 
		sl : begin 
			{flags[0],registers[ir[8:5]]} <= {flags[0],registers[ir[8:5]]} << ir[4:0];
			state = 4 ; 
			end 
		sr : begin 
			{registers[ir[8:5]] , flags[0]} <= {registers[ir[8:5]] , flags[0]} >> ir[4:0];
			state = 4 ; 
			end 
		
	endcase 
  end
3:begin //excute 
  state=4;
  case (ir[12:9])
	load :
	if (ir[15:13]==immediate)
		registers[ir[8:5]] <= ir[4:0];
	else 
		registers[ir[8:5]]<= mbr ;
		
	store: memory [ir[4:0]] <= mbr ;
    
	add : 
	if (ir[15:13] == immediate)
		{flags[0],registers[ir[8:5]]} = registers[ir[8:5]] + ir[4:0];
	else if (ir[15:13] == registerAddressing )
		{flags[0],registers[ir[8:5]]} = registers[ir[8:5]] + registers[ir[4:0]];
	else
		{flags[0],registers[ir[8:5]]} = registers[ir[8:5]] + mbr ; 
		
	jumb : pc <= mar ;
	
	jz :if(flags[1] == 1) 
				pc <= mar;
	jc :if(flags[0] == 1)
				pc <= mar;
  endcase
  end
  
       
4:begin //store
	$display("csadaa");
	state = 0 ;
	case(ir[12:9])
	add:
		if(registers[ir[8:5]]==0)
			flags[1] = 1 ; 
		else 
			flags[1] =0;
	cmp:
		if(registers[ir[8:5]]==registers[ir[4:0]])
			flags[1:0] <= 2'b10; 
		else if (registers[ir[8:5]] > registers[ir[4:0]])
			flags[1:0] <= 2'b00;
		else 
			flags[1:0] <= 2'b01;
	sl: 
		if (registers[ir[8:5]] ==0 )
			flags[1] <= 1 ; 
		else 
			flags[1]<= 0;
	sr: 
		if (registers[ir[8:5]] == 0 )
			flags[1] = 1 ; 
		else 
			flags[1] =0;
	
	endcase 
  end //end for 4
  
endcase //for case inside alwaysw
end //for always block 

endmodule      
