import java.io.File;
import java.io.FileNotFoundException;
import java.util.Hashtable;
import java.util.Scanner;
/*
--- Part Two ---
You finally arrive at the bathroom (it's a several minute walk from the lobby so visitors can behold the many fancy conference rooms and water coolers on this floor) and go to punch in the code. Much to your bladder's dismay, the keypad is not at all like you imagined it. Instead, you are confronted with the result of hundreds of man-hours of bathroom-keypad-design meetings:

    1
  2 3 4
5 6 7 8 9
  A B C
    D
You still start at "5" and stop when you're at an edge, but given the same instructions as above, the outcome is very different:

You start at "5" and don't move at all (up and left are both edges), ending at 5.
Continuing from "5", you move right twice and down three times (through "6", "7", "B", "D", "D"), ending at D.
Then, from "D", you move five more times (through "D", "B", "C", "C", "B"), ending at B.
Finally, after five more moves, you end at 3.
So, given the actual keypad layout, the code would be 5DB3.
*/
public class betterBathroomLock {
	public static void main(String[] args) throws FileNotFoundException {
		Scanner tcl = new Scanner(new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day2/movements.txt"));
		int x=2,y=2;
		String code= new String();
		Hashtable<String, Character> kp= new Hashtable<String, Character>(13);

		//First position is X and second is Y
		kp.put("0,2", '1');
		kp.put("1,1", '2');
		kp.put("1,2", '3');
		kp.put("1,3", '4');
		kp.put("2,0", '5');
		kp.put("2,1", '6');
		kp.put("2,2", '7');
		kp.put("2,3", '8');
		kp.put("2,4", '9');
		kp.put("3,1", 'A');
		kp.put("3,2", 'B');
		kp.put("3,3", 'C');
		kp.put("4,2", 'D');

		while(tcl.hasNext()){
			char[] move = tcl.nextLine().toCharArray();
			for(int i =0; i<move.length; i++){
				switch(move[i]){
					case 'U':
						if((x>1 || kp.get(x+","+y)=='3') && (y>0 && y<4))
							--x;
						break;
					case 'D':
						if((x<3 || kp.get(x+","+y)=='B') && (y>0 && y<4))
							++x;
						break;
					case 'R':
						if((y<3 || kp.get(x+","+y)=='8') && (x>0 && x<4))
							++y;
						break;
					case 'L':
						if((y>1 || kp.get(x+","+y)=='6') && (x>0 && x<4))
							--y;
						break;
				}
			}
			code+=(kp.get(x+","+y));
		}
		System.out.println("Your code is: "+code);
		tcl.close();
	}


}
