import java.util.Scanner;
import java.io.*;
/*
--- Day 10: Balance Bots ---
You come upon a factory in which many robots are zooming around handing small
microchips to each other.

Upon closer examination, you notice that each bot only proceeds when it has two
microchips, and once it does, it gives each one to a different bot or puts it in
a marked "output" bin. Sometimes, bots take microchips from "input" bins, too.

Inspecting one of the microchips, it seems like they each contain a single
number; the bots must use some logic to decide what to do with each chip.
You access the local control computer and download the bots' instructions
(your puzzle input).

Some of the instructions specify that a specific-valued microchip should be
given to a specific bot; the rest of the instructions indicate what a given
bot should do with its lower-value or higher-value chip.

For example, consider the following instructions:
  value 5 goes to bot 2
  bot 2 gives low to bot 1 and high to bot 0
  value 3 goes to bot 1
  bot 1 gives low to output 1 and high to bot 0
  bot 0 gives low to output 2 and high to output 0
  value 2 goes to bot 2

Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2
chip and a value-5 chip.
Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its
higher one (5) to bot 0.
Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives
the value-3 chip to bot 0.
Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in
output 0.
In the end, output bin 0 contains a value-5 microchip, output bin 1 contains a
value-2 microchip, and output bin 2 contains a value-3 microchip.
In this configuration, bot number 2 is responsible for comparing value-5
microchips with value-2 microchips.

Based on your instructions, what is the number of the bot that is responsible
for comparing value-61 microchips with value-17 microchips?

Your puzzle answer was 98.

--- Part Two ---

What do you get if you multiply together the values of one chip in each of
outputs 0, 1, and 2?
*/
public class bots{
  //Position 0 = BotLow, 1 = BotHigh, 2 = chip
  static int[][] bots = new int[300][3];
  static int[] outputs = new int[21];

  //Position 0= ChipValue, 1 = bot
  static int[][] chips = new int[21][2];

  //Chips we are looking for
  static int highChip = 61;
  static int lowChip = 17;
  static int responsableBot;
  static boolean botFound = false;

  public static boolean botWillProceed(int bot){
    if(bots[bot][2] > 0){
      return true;
    }
    return false;
  }
  public static void giveToBot(int bot, int chip){
    if(botWillProceed(bot)){
      int previousChip = bots[bot][2];
      if(previousChip < chip){
        if(previousChip ==  lowChip && chip == highChip){
          botFound = true;
          responsableBot = bot;
        }
        if(bots[bot][0] < 300 )
          giveToBot(bots[bot][0], previousChip);
        else
          outputs[bots[bot][0]-300] = chip;

        if(bots[bot][1] < 300 )
          giveToBot(bots[bot][1], chip);
        else
          outputs[bots[bot][1]-300] = chip;
      }
      else{
        if(previousChip ==  highChip && chip == lowChip){
          botFound = true;
          responsableBot = bot;
        }
        if(bots[bot][0] < 300 )
          giveToBot(bots[bot][0], chip);
        else
          outputs[bots[bot][0]-300] = chip;
        if(bots[bot][1] < 300 )
          giveToBot(bots[bot][1], previousChip);
        else
          outputs[bots[bot][1]-300] = chip;
      }
      bots[bot][2] = 0;
    }else{
      bots[bot][2] = chip;
    }
  }
  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day10/actions.txt"));
    int index = 0;

    while(tcl.hasNext()){
      String[] action = tcl.nextLine().split(" ");
      switch(action[0]){
        case "bot":
          int bot = Integer.parseInt(action[1]);
          if(action[5].equals("output")){
            bots[bot][0] = 300 + Integer.parseInt(action[6]);
          }
          else{
            bots[bot][0] = Integer.parseInt(action[6]);
          }
          if(action[10].equals("output")){
            bots[bot][1] = 300 + Integer.parseInt(action[11]);
          }
          else{
            bots[bot][1] = Integer.parseInt(action[11]);
          }
          break;
        case "value":
          chips[index][0] = Integer.parseInt(action[1]);
          chips[index++][1] = Integer.parseInt(action[5]);
          break;
      }
    }
    int i =0;
    while(i < index){
      giveToBot(chips[i][1], chips[i++][0]);
    }
    System.out.println(responsableBot+ " is the responsable Bot");

    int chipsMultiplied = outputs[0] * outputs[1] * outputs[3];
    System.out.println("The outputs 0, 1 and 2 values multiplied by eachother is "+chipsMultiplied);
  }
}
