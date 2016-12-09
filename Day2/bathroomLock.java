import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;
/*
--- Day 2: Bathroom Security ---
You can't hold it much longer, so you decide to figure out the code as you walk
to the bathroom. You picture a keypad like this:

1 2 3
4 5 6
7 8 9

Suppose your instructions are:
ULL
RRDDD
LURDL
UUUUD

-You start at "5" and move up (to "2"), left (to "1"),
and left (you can't, and stay on "1"), so the first button is 1.
-Starting from the previous button ("1"), you move right twice (to "3")
and then down three times (stopping at "9" after two moves and ignoring the third),
ending up with 9.
-Continuing from "9", you move left, up, right, down, and left, ending with 8.
-Finally, you move up four times (stopping at "2"), then down once, ending with 5.

So, in this example, the bathroom code is 1985.
*/
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
