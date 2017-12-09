import java.util.Scanner;
import java.io.*;

public class elevator{
  static String[][]  floors = new String[4][10];
  static int totalSteps = 0;
  public static void printFloors(){
    for(int x = 0; x < 4; x++){
      System.out.print("F"+(x+1)+": ");
      for(int i = 0; i < 10; i++){
        System.out.print((floors[x][i] == null? " . ": floors[x][i]+" "));
      }
      System.out.println();
    }
  }
  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(
      new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day11/objects.txt")
    );

    for(int x = 0; x < 4; x++){
      String[] lineParts = tcl.nextLine().split(" a ");
      for(int i = 1; i < lineParts.length; i++){
        String[] partsParts = lineParts[i].split(" ");
        floors[x][i-1] = partsParts[0].charAt(0) +""+ partsParts[1].charAt(0);
      }
    }
  }
}
