import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
/*
--- Day 6: Signals and Noise ---
You have to recover a Jammed message
sent by Santa by finding the most common
character on each columm
For part 2 you just have to find the least
commons, by changing the > for a <
in the expresion: if(letters[position[y]][y] > letters[x][y])
 */
public class jammingCommunications{
  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(
      new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day6/recordedMessage.txt")
    );
    int messageSize = 8;
    int[][] letters = new int[26][messageSize];
    while(tcl.hasNext()){
      char[] line = tcl.nextLine().toCharArray();
      for(int i =0; i <line.length; ++i){
    	  letters[(int)(line[i]-97)][i]++;
      }
    }
    int[] position = new int[messageSize];
    for(int x=0; x < 26; x++){
    	for(int y = 0; y < position.length; y++)
    		if(letters[position[y]][y] > letters[x][y])
    			position[y]=x;
    }

    System.out.print("The message is: ");
    for(int i=0; i < position.length; ++i)
    	System.out.print((char)(position[i]+97));
    tcl.close();
  }
}
