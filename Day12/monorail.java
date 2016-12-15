import java.util.Scanner;
import java.io.*;

public class monorail{
  static int ammountOfActions = 23;
  static int ammountOfRegisters = 4;
  //a = 0, b = 1, c = 2, d = 3
  static int[] registers = new int[ammountOfRegisters];
  static String[] actions = new String[ammountOfActions];

  static int index = 0;

  public static boolean isNumber(char character){
    if(character <97) return true;
    return false;
  }
  public static void copy(String give, String recive){
      int value;
      char[] parts = give.toCharArray();
      if(parts.length > 1){
        value = Integer.parseInt(new String(parts));
      }
      else{
        if(isNumber(parts[0]))
          value = parts[0] - '0';
        else
          value = registers[parts[0] - 'a'];
      }
      parts = recive.toCharArray();
      registers[parts[0] - 'a'] = value;
  }

  public static void increase(char register){
    registers[register - 'a']++;
  }

  public static void decrease(char register){
    registers[register - 'a']--;
  }

  public static void jump(char register, String jumps, int position){
    int steps = (jumps.length() > 1? -(jumps.charAt(1)- '0'): jumps.charAt(0) - '0');
    int value = (isNumber(register)? registers[register - '1']: registers[register - 'a']);
    if(value > 0){
      index += steps-1;
    }
  }
  public static void printRegisters(){
    System.out.println("Action #"+(index+1)+"- | a = " + registers[0]+" | b = "+registers[1]+
    " | c = "+registers[2]+" | d = "+registers[3]+" |\n");
  }
  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner( new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day12/actions.txt"));
    registers[2] = 1; //For Part 2
    while(tcl.hasNext()){
      actions[index++] = tcl.nextLine();
    }
    String[] parts;
    for(index = 0; index < actions.length; index++){
      // System.out.println(actions[index]);
      parts = actions[index].split(" ");
      switch(parts[0].charAt(0)){
        case 'c':
          copy(parts[1],parts[2]);
          break;

        case 'i':
          increase(parts[1].charAt(0));
          break;

        case 'd':
          decrease(parts[1].charAt(0));
          break;

        case 'j':
          jump(parts[1].charAt(0), parts[2], index);
          break;
      }
      // printRegisters();

    }
    System.out.println("The value of register a is " + registers[0]);
  }
}
