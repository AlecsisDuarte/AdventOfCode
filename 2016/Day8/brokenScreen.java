import java.util.Scanner;
import java.io.*;
/*
--- Day 8: Two-Factor Authentication ---

You come across a door implementing what you can only assume
is an implementation of two-factor authentication after a long
game of requirements telephone.
To get past the door, you first swipe a keycard (no problem;
there was one on a nearby desk). Then, it displays a code on a
little screen, and you type that code on a keypad. Then,
presumably, the door unlocks.

Unfortunately, the screen has been smashed. After a few minutes,
you've taken everything apart and figured out how it works. Now
you just have to work out what the screen would have displayed.

The magnetic strip on the card you swiped encodes a series of
instructions for the screen; these instructions are your puzzle
input. The screen is 50 pixels wide and 6 pixels tall, all of
which start off, and is capable of three somewhat peculiar operations:

rect AxB turns on all of the pixels in a rectangle at the
top-left of the screen which is A wide and B tall.
rotate row y=A by B shifts all of the pixels in row A
(0 is the top row) right by B pixels. Pixels that would
fall off the right end appear at the left end of the row.
rotate column x=A by B shifts all of the pixels in column A
(0 is the left column) down by B pixels. Pixels that would fall
off the bottom appear at the top of the column.
For example, here is a simple sequence on a smaller screen:
rect 3x2 creates a small rectangle in the top-left corner:
###....
###....
.......

rotate column x=1 by 1 rotates the second column down by one pixel:
#.#....
###....
.#.....

rotate row y=0 by 4 rotates the top row right by four pixels:
....#.#
###....
.#.....

rotate column x=1 by 1 again rotates the second column down by one
pixel, causing the bottom pixel to wrap back to the top:
.#..#.#
#.#....
.#.....

There seems to be an intermediate check of the voltage used by
the display: after you swipe your card, if the screen did work,
how many pixels should be lit?
*/
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
