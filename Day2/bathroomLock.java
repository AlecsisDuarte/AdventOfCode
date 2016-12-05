import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class bathroomLock {
	public static void main(String[] args) throws FileNotFoundException {
		Scanner tcl = new Scanner(new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day2/movements.txt"));
		int x=1,y=1;
		String code= new String();
		Hashtable<String, Integer> kp= new Hashtable<String, Integer>(9);

		//First position is X and second is Y
		kp.put("0,0", 1);
		kp.put("0,1", 2);
		kp.put("0,2", 3);
		kp.put("1,0", 4);
		kp.put("1,1", 5);
		kp.put("1,2", 6);
		kp.put("2,0", 7);
		kp.put("2,1", 8);
		kp.put("2,2", 9);

		while(tcl.hasNext()){
			char[] move = tcl.nextLine().toCharArray();
			for(int i =0; i<move.length; i++){
				switch(move[i]){
					case 'U':
						if(x>0)
							--x;
						break;
					case 'D':
						if(x<2)
							++x;
						break;
					case 'R':
						if(y<2)
							++y;
						break;
					case 'L':
						if(y>0)
							--y;
						break;
				}
			}
			code+=(kp.get(x+","+y))+"";
		}
		System.out.println("Your code is: "+code);
		tcl.close();
	}

}
