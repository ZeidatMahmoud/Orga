import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Convert {
	

	public static void main(String[] args) throws FileNotFoundException {
		//File f = new File("program.txt") ;
		String code1="" ,code2 ="";
		int index = 0  ;
		String code ;
		ArrayList<String> codes = new ArrayList<>() ;
		Scanner s = new Scanner(new File("program.txt"));
		ArrayList<String> list = new ArrayList<String>();
		while (s.hasNext()){
		    list.add(s.nextLine());
		}
		s.close();
		System.out.println(list.toString());
		//getCode(list,index);
		getCode(list, index, codes,code1,code2) ;
	}
	
	public static int getCode(ArrayList<String>list,int index,ArrayList<String> codes,String code1 ,String code2 ) {
		char[] array = new char[16] ;
		int address = 0;
		double mode ;
		int modeint ;
		for(int i= 0; i<list.size() ;i++) {
			code1 = "0" ;
			code2 = "0" ;
			//**************************************************************  ORG ***********************************************************************8
			if(list.get(i).split(" ")[0].equals("ORG")) {
				index = Integer.parseInt(list.get(i).split(" ")[1] );
			
				
			}
			//************************************************************* LOAD ***************************************************************************
			else if(list.get(i).split(" ")[0].equals("LOAD")) { // if the instruction is load
				code1 = "0011" ;
				
				if(list.get(i).split(" ")[1].split(",")[0].equals("R0")) { // if the src register is R0 then add 00
					code2 = "00";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R1")) {
					code2 = "01";
					System.out.println("hhhhhhhh");
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R2")) {
					code2 = "10";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R3")) {
					code2 = "11";
					
				}
				
				mode = getMode(list.get(i)) ; // get the addressing mode 
				//System.out.println(mode);
				if(mode == 4.1) {
					code1 = code1.concat("11") ;
					address = 0 ;
					
				}
				else if(mode == 4.2) {
					code1 =code1.concat("11") ;
					address = 1 ;
					
				}
				else if(mode == 4.3) {
					code1 =code1.concat("11") ;
					address = 2 ;
					
				}
				else if(mode == 4.4) {
					code1 =code1.concat("11") ;
					address = 3 ;
					
				}
				else if(mode == 3) 
					code1 = code1.concat("10") ;
				
				else if(mode == 2) 
					code1 =code1.concat("01") ;
				
				else if(mode == 1) 
					code1 =code1.concat("00");
				
				modeint = (int)mode ;
					
			if(modeint != 4) {
			address = getAddress(list.get(i), mode); // get the destination address
			}
			else {
				
			}
			String binary = Integer.toString(address, 2) ;
			int n = binary.length() ;
			for(int j = 0 ;j<8-n ; j++) {
				code2 = code2.concat("0") ;
			}
			code2 = code2.concat(binary);
			
			
			codes.add(code1+""+code2) ;
			
			
			
			}
			//****************************************************************** ADD ********************************************************************
			else if(list.get(i).split(" ")[0].equals("ADD")) { // if the instruction is ADD
				code1 = "0111" ;
				
				if(list.get(i).split(" ")[1].split(",")[0].equals("R0")) { // the src register
					code2 = "00";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R1")) {// the src register
					code2 = "01";
					System.out.println("hhhhhhhh");
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R2")) {// the src register
					code2 = "10";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R3")) {// the src register
					code2 = "11";
					
				}
				mode = getMode(list.get(i)) ; // get the addressing mode 
				
				if(mode == 4.1) {
					code1 = code1.concat("11") ;
					address = 0 ;
					
				}
				else if(mode == 4.2) {
					code1 =code1.concat("11") ;
					address = 1 ;
					
				}
				else if(mode == 4.3) {
					code1 =code1.concat("11") ;
					address = 2 ;
					
				}
				else if(mode == 4.4) {
					code1 =code1.concat("11") ;
					address = 3 ;
					
				}
				else if(mode == 3) 
					code1 = code1.concat("10") ;
				
				else if(mode == 2) 
					code1 =code1.concat("01") ;
				
				else if(mode == 1) 
					code1 =code1.concat("00");
				
				modeint = (int)mode ;
					
			if(modeint != 4) {
			address = getAddress(list.get(i), mode); // get the destination address
			}
			else {
				
			}
			String binary = Integer.toString(address, 2) ;
			int n = binary.length() ;
			for(int j = 0 ;j<8-n ; j++) {
				code2 = code2.concat("0") ;
			}
			code2 = code2.concat(binary);
			
			
			codes.add(code1+""+code2) ;
			//System.out.println(codes.toString());
			
			
			}
			//************************************************************************** SUB *******************************************************
			else if(list.get(i).split(" ")[0].equals("SUB")) { // if the instruction is ADD
				code1 = "1000" ;
				
				if(list.get(i).split(" ")[1].split(",")[0].equals("R0")) { // the src register
					code2 = "00";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R1")) {// the src register
					code2 = "01";
					System.out.println("hhhhhhhh");
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R2")) {// the src register
					code2 = "10";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R3")) {// the src register
					code2 = "11";
					
				}
				mode = getMode(list.get(i)) ; // get the addressing mode 
				
				if(mode == 4.1) {
					code1 = code1.concat("11") ;
					address = 0 ;
					
				}
				else if(mode == 4.2) {
					code1 =code1.concat("11") ;
					address = 1 ;
					
				}
				else if(mode == 4.3) {
					code1 =code1.concat("11") ;
					address = 2 ;
					
				}
				else if(mode == 4.4) {
					code1 =code1.concat("11") ;
					address = 3 ;
					
				}
				else if(mode == 3) 
					code1 = code1.concat("10") ;
				
				else if(mode == 2) 
					code1 =code1.concat("01") ;
				
				else if(mode == 1) 
					code1 =code1.concat("00");
				
				modeint = (int)mode ;
					
			if(modeint != 4) {
			address = getAddress(list.get(i), mode); // get the destination address
			}
			else {
				
			}
			String binary = Integer.toString(address, 2) ;
			int n = binary.length() ;
			for(int j = 0 ;j<8-n ; j++) {
				code2 = code2.concat("0") ;
			}
			code2 = code2.concat(binary);
			
			
			codes.add(code1+""+code2) ;
			//System.out.println(codes.toString());
			
			
			}
			//*********************************************************************** STORE *********************************
			else if(list.get(i).split(" ")[0].equals("STORE")) { // if the instruction is ADD
				code1 = "1011" ;
				
				if(list.get(i).split(" ")[1].split(",")[0].equals("R0")) { // the src register
					code2 = "00";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R1")) {// the src register
					code2 = "01";
					System.out.println("hhhhhhhh");
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R2")) {// the src register
					code2 = "10";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R3")) {// the src register
					code2 = "11";
					
				}
				mode = getMode(list.get(i)) ; // get the addressing mode 
				
				if(mode == 4.1) {
					code1 = code1.concat("11") ;
					address = 0 ;
					
				}
				else if(mode == 4.2) {
					code1 =code1.concat("11") ;
					address = 1 ;
					
				}
				else if(mode == 4.3) {
					code1 =code1.concat("11") ;
					address = 2 ;
					
				}
				else if(mode == 4.4) {
					code1 =code1.concat("11") ;
					address = 3 ;
					
				}
				else if(mode == 3) 
					code1 = code1.concat("10") ;
				
				else if(mode == 2) 
					code1 =code1.concat("01") ;
				
				else if(mode == 1) 
					code1 =code1.concat("00");
				
				modeint = (int)mode ;
					
			if(modeint != 4) {
			address = getAddress(list.get(i), mode); // get the destination address
			}
			else {
				
			}
			String binary = Integer.toString(address, 2) ;
			int n = binary.length() ;
			for(int j = 0 ;j<8-n ; j++) {
				code2 = code2.concat("0") ;
			}
			code2 = code2.concat(binary);
			
			
			codes.add(code1+""+code2) ;
			//System.out.println(codes.toString());
			
			
			}
			//****************************************************** JMP *******************************************
			else if(list.get(i).split(" ")[0].equals("JMP")) {
				code1 = "1100";
				String str = list.get(i).split(" ")[1] ;
				int immediate = Integer.parseInt(str) ;
				String bin = Integer.toString(immediate, 2) ;
				int q = bin.length() ;
				for(int j =0 ; j<12-q ;j++) {
					code1 = code1.concat("0") ;
				}
				code1 = code1.concat(bin) ;
				codes.add(code1) ;
				
			}
			//************************************************************ CMP *********************************
			else if(list.get(i).split(" ")[0].equals("CMP")) {
				code1 = "110100" ;
				if(list.get(i).split(" ")[1].split(",")[0].equals("R0")) { // the src register
					code2 = "00";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R1")) {// the src register
					code2 = "01";
					//System.out.println("hhhhhhhh");
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R2")) {// the src register
					code2 = "10";
					
				}
				else if(list.get(i).split(" ")[1].split(",")[0].equals("R3")) {// the src register
					code2 = "11";
					
				}
				modeint =1 ;
				address = getAddress(list.get(i), modeint) ;
				String binary = Integer.toString(address, 2) ;
				int n = binary.length() ;
				for(int j = 0 ;j<8-n ; j++) {
					code2 = code2.concat("0") ;
				}
				code2 = code2.concat(binary);
				
				
				codes.add(code1+""+code2) ;
				
				
				
			}
			
			
		}
		System.out.println(codes.toString());
		//System.out.println(list.get(0).split(" ")[0]);
		return index ;
	}
	
	public static int getAddress(String str , double mode) {
		String des = str.split(",")[1] ;
		String num ;
		int address ;
		if(mode ==  2) {
			num = des.split("\\[")[1] ;
			//System.out.println(num.split("\\]")[0]);
			address = Integer.parseInt(num.split("\\]")[0]) ;
			return address ;
			
		}
		else if(mode ==  1) {
			address = Integer.parseInt(des) ;
			return address ;
		}
		else if(mode ==  3) {
			String state1 , state2 ;
			//state1 = des.split("\\[")[1];
			//state2 = state1.split("\\]")[0] ;
			state1 = des.replace("[", "") ;
			state2 = state1.replace("]", "") ;
			
			//System.out.println(state2);
			
			address = Integer.parseInt(state2);
			return address ;
		}
		return 0 ;
	}
	
	
	public static double getMode(String str ) {
		
		String des = str.split(",")[1] ;
		if(des.equals("R0") ||des.equals("R1")|| des.equals("R2") || des.equals("R3") ) {
			if(des.equals("R0")) {
				return 4.1 ;
			}
			if(des.equals("R1")) {
				return 4.2 ;
			}
			if(des.equals("R2")) {
				return 4.3 ;
			}
			if(des.equals("R3")) {
				return 4.4 ;
			}
			
		}
		else if(des.charAt(0) == '[' && des.charAt(1) == '[') {
			return 3 ;
		}
		else if(des.charAt(0) == '[') {
			return 2 ;
		}
		
			
		return 1;
	}
	


}
