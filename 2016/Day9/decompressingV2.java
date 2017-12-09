import java.util.Scanner;
import java.io.*;
/*
--- Part Two ---
Apparently, the file actually uses version two of the format.

In version two, the only difference is that markers within decompressed data
are decompressed. This, the documentation explains, provides much more
substantial compression capabilities, allowing many-gigabyte files to be
stored in only a few kilobytes.

For example:

(3x3)XYZ still becomes XYZXYZXYZ, as the decompressed section contains
no markers.
X(8x2)(3x3)ABCY becomes XABCABCABCABCABCABCY, because the decompressed data
from the (8x2) marker is then further decompressed, thus triggering the (3x3)
marker twice for a total of six ABC sequences.
(27x12)(20x12)(13x14)(7x10)(1x12)A decompresses into a string of A repeated
241920 times.
(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN becomes 445
characters long.
Unfortunately, the computer you brought probably doesn't have enough memory
to actually decompress the file; you'll have to come up with another way to
get its decompressed length.

What is the decompressed length of the file using this improved format?

This coded didn't work
*/

public class decompressingV2 {
	static int ammountOfChars = 0;

	public static boolean hasParentheses(String line) {
		for (int i = 0; i < line.length(); i++)
		if (line.charAt(i) == '(')
		return true;
		return false;
	}

	public static String changeNumberInString(String reciver, String num, int start, int end) {
		return reciver.substring(0, start) + num + reciver.substring(end);
	}

	public static String multiplyMarkers(String line, int start, int mainSteps, int mainReps) {
		int x = start;
		int reps = 0;
		while (++x < (start + mainSteps + 1)) {
			if (line.charAt(x) == '(') {
				String aux = "";
				while (line.charAt(++x) != 'x')aux += line.charAt(x);
				int steps = Integer.parseInt(aux);
				int before = x + 1;
				aux = "";
				while (line.charAt(++x) != ')')
				aux += line.charAt(x);
				reps = Integer.parseInt(aux);
				if (line.charAt(x + 1) != '(') {
					reps *= mainReps;
					mainSteps += String.valueOf(reps).length() - aux.length();
					line = changeNumberInString(line, Integer.toString(reps), before, x);
				}
				int index = x;
				while(line.charAt(++index) != ')');
				if((index+steps+1) < line.length()){
					index += steps;
					if(line.charAt(index) != '('){
						int lettersQuantity =0;
						while(line.charAt(++index) != '(' || index < line.length())
						lettersQuantity++;
						ammountOfChars += lettersQuantity*(mainReps-1);
					}
				}
			}
		}
		return line;

	}

	public static void main(String[] args) throws FileNotFoundException {
		Scanner tcl = new Scanner(
		new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day9/uncompressed.txt")
		);
		while (tcl.hasNext()) {
			int steps = 0, reps = 0;
			String uncompressed = tcl.nextLine();
			for (int i = 0; i < uncompressed.length(); i++) {
				if (uncompressed.charAt(i) == '(') {
					String aux = "";
					while (uncompressed.charAt(++i) != 'x')
					aux += uncompressed.charAt(i);
					steps = Integer.parseInt(aux);
					aux = "";
					while (uncompressed.charAt(++i) != ')')
					aux += uncompressed.charAt(i);
					reps = Integer.parseInt(aux);
					if (hasParentheses(uncompressed.substring(i + 1, i + steps))) {
						uncompressed = multiplyMarkers(uncompressed, i, steps, reps);
					} else {
						ammountOfChars += (steps * reps);
						i += steps;
					}
				} else
				ammountOfChars++;
			}
		}

		System.out.println("This file is " + ammountOfChars + " characters long");
		tcl.close();
	}
}
