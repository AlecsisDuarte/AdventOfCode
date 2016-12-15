import java.util.Scanner;
import java.io.*;
/*
--- Part Two ---

Apparently, the file actually uses version two of the format.

In version two, the only difference is that markers within decompressed data are
decompressed. This, the documentation explains, provides much more substantial
compression capabilities, allowing many-gigabyte files to be stored in only a
few kilobytes.

For example:

(3x3)XYZ still becomes XYZXYZXYZ, as the decompressed section contains no
markers.
X(8x2)(3x3)ABCY becomes XABCABCABCABCABCABCY, because the decompressed data
from the (8x2) marker is then further decompressed, thus triggering the (3x3)
marker twice for a total of six ABC sequences.
(27x12)(20x12)(13x14)(7x10)(1x12)A decompresses into a string of A repeated
241920 times.
(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN becomes 445 characters
long.
Unfortunately, the computer you brought probably doesn't have enough memory to
actually decompress the file; you'll have to come up with another way to get
its decompressed length.

What is the decompressed length of the file using this improved format?

This code was based on http://pastebin.com/wqkTGAvg
*/
public class decompressingV3{
  static long fileLength = 0;
  static int index = 0;
  static String text;

  public static long decompress(int mainSteps, int mainReps){
    long chars = 0;
    char c;
    for(;0 < mainSteps; mainSteps--){
      c = text.charAt(++index);
      if(c == '('){
        int aux = 1;
        int steps = 0;
        while((c = text.charAt(++index)) != 'x'){
          aux++;
          steps *= 10;
          steps += c - '0';
        }
        int reps = 0;
        aux++;
        while((c = text.charAt(++index)) != ')'){
          aux++;
          reps *= 10;
          reps += c - '0';
        }
        chars += decompress(steps, reps) * mainReps;
        mainSteps -= steps+aux;
      }
      else{
        chars += mainReps;
      }
    }
    return chars;
  }

  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day9/uncompressed.txt"));
    text = tcl.nextLine();
    char c;
    for(; index < text.length(); index++){
      c = text.charAt(index);
      if(c == '('){
        int steps = 0;
        while((c = text.charAt(++index)) != 'x'){
          steps *= 10;
          steps += c - '0';
        }
        int reps = 0;
        while((c = text.charAt(++index)) != ')'){
          reps *= 10;
          reps += c - '0';
        }
        fileLength += decompress(steps, reps);
      }
      else{
        ++fileLength;
      }
    }
    System.out.println("The file is "+fileLength+" characters long");
    tcl.close();
  }
}
