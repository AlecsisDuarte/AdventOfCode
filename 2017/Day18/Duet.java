import java.util.Scanner;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Queue;

public class Duet{
    private static boolean isInteger(String line){
        if (line.length() == 1 && line.charAt(0) > 97 && line.charAt(0) < 123){
            return false;
        }
        return true;
    }

    private static int getY(HashMap<Character, Integer> registers, String line){
        if (isInteger(line)) {
            return Integer.parseInt(line);
        } else {
            return registers.get(line.charAt(0));
        }
    }

    private static void set(HashMap<Character, Integer> registers, String x, String y){
        int value = getY(registers, y);
        registers.put(x.charAt(0), value);
    }

    private static void add(HashMap<Character, Integer> registers, String x, String y){
        int value = getY(registers, y) + registers.get(x.charAt(0));
        registers.put(x.charAt(0), value);
    }
    
    private static void mul(HashMap<Character, Integer> registers, String x, String y){
        int value = getY(registers, y) * registers.get(x.charAt(0));
        registers.put(x.charAt(0), value);
    }
    
    private static void mod(HashMap<Character, Integer> registers, String x, String y){
        int value = registers.get(x.charAt(0)) % getY(registers, y);
        registers.put(x.charAt(0), value);
    }



    private static int recoveredFrequency(ArrayList<String> actions){
        int recover = 0;
        int index = 0;
        HashMap<Character, Integer> registers = new HashMap<Character, Integer>(5);
        while(index <= actions.size()){
            String[] parts = actions.get(index).split("\\s");

            if(parts[0].equals("set")){ //Set
                set(registers, parts[1], parts[2]);

            } else if (parts[0].equals("add")) { //Add
                add(registers, parts[1], parts[2]);

            } else if (parts[0].equals("mul")) { //Mul

                
            } else if (parts[0].equals("mod")) { //Mod


            } else if (parts[0].equals("snd")) { //Snd


            } else if (parts[0].equals("rcv")) { //Rcv


            } else if (parts[0].equals("jgz")) { //jgz


            }
            ++index;
        }
        return recover;
    }

    public static void main(String[] args){
        Scanner in = new Scanner(System.in);
        ArrayList<String> actions = new ArrayList<String>(10);
        int index = 0;
        while(in.hasNextLine()){
            actions.add(index++, in.nextLine());
        }
        System.out.println("Part 1 - Recovered Frequency= " + recoveredFrequency(actions));
        in.close();
    }
}