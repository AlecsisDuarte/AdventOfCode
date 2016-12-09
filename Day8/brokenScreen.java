import java.util.Scanner;
import java.io.*;

public class brokenScreen{
  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(
      new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day8/rectangles.txt")
    );
    int pixelsOn = 0, wide = 50, tall = 6;
    char[][] grid = new char[tall][wide];
    while(tcl.hasNext()){
      String action = tcl.nextLine();
      if(action.startsWith("rect ")){
        int x = Integer.parseInt(action.substring(5,action.length()-2).trim());
        int y = Integer.parseInt(action.substring(action.length()-1,action.length()).trim());
        for(int i = 0; i < y; i++){
          for(int e = 0; e < x; e++){
            grid[i][e] = '#';
          }
        }
      }
      else if(action.startsWith("rotate row y=")){
        int y = action.charAt(13)-'0';
        int move = Integer.parseInt(action.substring(action.length()-2,action.length()).trim());
        char[] row = new char[wide];
        boolean fromBeging = false;
        for(int i = 0; i < wide; i++){
          row[i] = grid[y][i];
        }
        for(int i = 0; i < wide; i++){
          if(i+move < wide && !fromBeging){
            grid[y][i+move] = row[i];
          }
          else if(i+move == wide && !fromBeging){
            move = i;
            fromBeging = true;
            grid[y][i-move] = row[i];
          }
          else{
            grid[y][i-move] = row[i];
          }
        }
      }
      else if(action.startsWith("rotate column x=")){
        int x = Integer.parseInt(action.substring(16,action.length()-5).trim());
        int move = action.charAt(action.length()-1)-'0';
        char[] column = new char[tall];
        boolean fromBeging = false;
        for(int i =0; i < tall; i++){
          column[i] = grid[i][x];
        }
        for(int i =0; i < tall; i++){
          if(i+move < tall && !fromBeging){
            grid[i+move][x] = column[i];
          }
          else if(i + move == tall && !fromBeging){
            move = i;
            fromBeging = true;
            grid[i-move][x] = column[i];
          }
          else{
            grid[i-move][x] = column[i];
          }
        }
      }
      System.out.println();
      for(int x = 0; x < tall; ++x){
          for(int y = 0; y < wide; ++y){
            System.out.print((grid[x][y] == '#'?'#':'-'));
          }
          System.out.println();
        }
    }
    for(int x = 0; x < tall; ++x){
      for(int y = 0; y < wide; ++y){
        if(grid[x][y] == '#')
          ++pixelsOn;
      }
    }
    System.out.println(pixelsOn+" pixels are on");
  }
}
