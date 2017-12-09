
/* --- Day 8: I Heard You Like Registers ---
You receive a signal directly from the CPU. Because of your recent assistance with jump instructions, it would like you to compute the result of a series of unusual register instructions.

Each instruction consists of several parts: the register to modify, whether to increase or decrease that register's value, the amount by which to increase or decrease it, and a condition. If the condition fails, skip the instruction without modifying the register. The registers all start at 0. The instructions look like this:

b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
These instructions would be processed as follows:

Because a starts at 0, it is not greater than 1, and so b is not modified.
a is increased by 1 (to 1) because b is less than 5 (it is 0).
c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
c is increased by -20 (to -10) because c is equal to 10.
After this process, the largest value in any register is 1.

You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU doesn't have the bandwidth to tell you what all the registers are named, and leaves that to you to determine.

What is the largest value in any register after completing the instructions in your puzzle input?

Your puzzle answer was 6012.

--- Part Two ---
To be safe, the CPU also needs to know the highest value held in any register during this process so that it can decide how much memory to allocate to these operations. For example, in the above instructions, the highest value ever held was 10 (in register c after the third instruction was evaluated).

Your puzzle answer was 6369.
 */

import java.util.HashMap;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

class Pos{
    public static final int FIRSTREG    = 0;
    public static final int ACTION      = 1;
    public static final int VALUE       = 2;
    public static final int SECONDREG   = 4;
    public static final int LOGICSIM    = 5;
    public static final int COMPAREVAL  = 6;
}

public class YouLikeRegisters{
    public static void main(String[] args){
        try{
            Scanner in = new Scanner(new File("input.txt").getAbsoluteFile());
            HashMap<String, Integer> map = new HashMap<String, Integer>(100);
            int maxAlloc = 0;
            while(in.hasNextLine()){
                String[] s = in.nextLine().split("\\s+");
                int secondReg = 0; //Register used to verify condition
                int firstReg = 0; //Register to inc or dec
                int value = Integer.parseInt(s[Pos.VALUE]);
                // System.out.println("Value = " + value);
                if(map.containsKey(s[Pos.FIRSTREG])){
                    firstReg = map.get(s[Pos.FIRSTREG]);
                }
                if(map.containsKey(s[Pos.SECONDREG])){
                        secondReg = map.get(s[Pos.SECONDREG]);
                }
                boolean doAction = true;
                int compareValue = Integer.parseInt(s[Pos.COMPAREVAL]);
                switch(s[Pos.LOGICSIM]){
                    case ">":
                        doAction = (secondReg > compareValue);
                        break;
                    case "<":
                        doAction = (secondReg < compareValue);
                        break;
                    case ">=":
                        doAction = (secondReg >= compareValue);
                        break;
                    case "<=":
                        doAction = (secondReg <= compareValue);
                        break;
                    case "!=":
                        doAction = (secondReg != compareValue);
                        break;
                    default:
                        doAction = (secondReg == compareValue);     
                        break;
                }
                if(doAction){
                    if(s[Pos.ACTION].equals("dec")){
                        value *= -1;
                    }
                    firstReg = value + firstReg;
                    maxAlloc = maxAlloc < firstReg ? firstReg : maxAlloc;
                    map.put(s[Pos.FIRSTREG], firstReg);
                }
            }
            int max = 0;
            for(Integer value : map.values()){
                max = max < value ? value : max;
            }
            in.close();
            System.out.println("Part 1:  Max= " + max);
            System.out.println("Part 1:  MaxAlloc= " + maxAlloc);
        }catch(FileNotFoundException e ){
            System.err.println(e.getMessage());
        }
    }
}