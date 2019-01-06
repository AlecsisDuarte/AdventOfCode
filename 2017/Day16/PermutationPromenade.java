
/* 
 * --- Day 16: Permutation Promenade ---
You come upon a very unusual sight; a group of programs here appear to be dancing.

There are sixteen programs in total, named a through p. They start by standing in a line: a stands in position 0, 
b stands in position 1, and so on until p, which stands in position 15.

The programs' dance consists of a sequence of dance moves:

Spin, written sX, makes X programs move from the end to the front, but maintain their order otherwise. (For example, 
s3 on abcde produces cdeab).
Exchange, written xA/B, makes the programs at positions A and B swap places.
Partner, written pA/B, makes the programs named A and B swap places.
For example, with only five programs standing in a line (abcde), they could do the following dance:

s1, a spin of size 1: eabcd.
x3/4, swapping the last two programs: eabdc.
pe/b, swapping programs e and b: baedc.
After finishing their dance, the programs end up in order baedc.

You watch the dance for a while and record their dance moves (your puzzle input). In what order are the programs 
standing after their dance?

Your puzzle answer was eojfmbpkldghncia.

--- Part Two ---
Now that you're starting to get a feel for the dance moves, you turn your attention to the dance as a whole.

Keeping the positions they ended up in from their previous dance, the programs perform it again and again: including 
the first dance, a total of one billion (1000000000) times.

In the example above, their second dance would begin with the order baedc, and use the same dance moves:

s1, a spin of size 1: cbaed.
x3/4, swapping the last two programs: cbade.
pe/b, swapping programs e and b: ceadb.
In what order are the programs standing after their billion dances?

Your puzzle answer was iecopnahgdflmkjb.
*/
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.io.File;
import java.io.FileNotFoundException;

public class PermutationPromenade{
    private static ArrayList<Character> getStartingCharacters(int size){
        ArrayList<Character> characters = new ArrayList<Character>(size);
        int i = 0;
        while (i < size){
            characters.add((char)('a' + (i++)));
        }
        return characters;
    }

    private static void spin(ArrayList<Character> chars, int steps){
        Collections.rotate(chars, steps);
    }

    private static void exchange(ArrayList<Character> chars, int fPos, int sPos){
        Collections.swap(chars, fPos, sPos);
    }

    private static void partner(ArrayList<Character> chars, char fChar, char sChar){
        int fPos = chars.indexOf(fChar);
        int sPos = chars.indexOf(sChar);
        exchange(chars, fPos, sPos);

    }

    private static void printChars(ArrayList<Character> chars, String line){
        System.out.print(line);
        for (char c : chars) {
            System.out.print(c);
        }
        System.out.println();
    }

    public static void dance(ArrayList<Character> chars, String action){
        switch (action.charAt(0)) {
        case 's':
            spin(chars, Integer.parseInt(action.substring(1)));
            break;

        case 'x':
            String[] positions = action.split("[^\\d]+");
            exchange(chars, Integer.parseInt(positions[1]), Integer.parseInt(positions[2]));
            break;

        case 'p':
            partner(chars, action.charAt(1), action.charAt(3));
            break;
        }
    }

    private static String[] getActions(String fileName, int numActions){
        String[] actions = null;
        try{
            Scanner in = new Scanner(new File(fileName).getAbsoluteFile());
            in.useDelimiter(",");
            int index = 0;
            actions = new String[numActions];
            while(in.hasNext()){
                actions[index++] = in.next();
            }
            in.close();
        } catch (FileNotFoundException e){
            System.err.print(e.getMessage());
        }
        return actions;
    }

    private static String getKey(ArrayList<Character> chars){
        String key = "";
        for (char c : chars) {
            key += c;
        }
        return key;
    }

    private static String getValueOfTimes(HashMap<Integer, String> variations, int times){
        while (times > variations.size() - 1) {
            times -= variations.size();
        }
        return variations.get(times);
    }

    public static void main(String[] args){
        long startTime = System.currentTimeMillis();
        int times = 48;
        HashMap<Integer, String> variations = new HashMap<Integer, String>(times);
        ArrayList<Character> chars = getStartingCharacters(16);
        String[] actions = getActions("input.txt", 10000);
        int index = 0;
        while (index < times){
            for (String action : actions){
                    dance(chars, action);
                }
            variations.put(index++, getKey(chars));
        }
        System.out.println("Part 1 Chars Order: " + getValueOfTimes(variations, 0));
        System.out.println("Part 2 Chars Order: " + getValueOfTimes(variations, (1000000000 - 1)));
        System.out.println("Runtime: " + (System.currentTimeMillis() - startTime));
    }
}

/* 
 * Runtimes:
 */