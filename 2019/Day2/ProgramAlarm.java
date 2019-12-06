import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Scanner;


public class ProgramAlarm {
    static int MAX_SIZE_INTCODE = 1000;
    static int DESIRED_OUTPUT = 19690720;

    static boolean found = false;
    static int verb = 0, noun = 0;
    public static void main(String[] args) throws IOException {
        int[] intcodes = fillIntcodes();
        runIntcodesPart1(intcodes);
        runIntcodesPart2(intcodes);
    }

    static void runIntcodesPart1(int[] intcodes) {
        int[] tmpIntcodes = intcodes.clone();
        tmpIntcodes[1] = 12;
        tmpIntcodes[2] = 2;
        
        runOpcodes(tmpIntcodes);
        System.out.println("Part 1 - Result = " + tmpIntcodes[0]);
    }

    static void runIntcodesPart2(int[] intcodes) {
        int[] tmpIntcodes = new int[] {0};

        int noun = -1;
        int verb = 99;

        do {
            //TODO: try to apply an log n search
            if (tmpIntcodes[0] < DESIRED_OUTPUT) {
                noun++;
            } else {
                verb--;
            }
            tmpIntcodes = intcodes.clone();
            tmpIntcodes[1] = noun;
            tmpIntcodes[2] = verb;
            runOpcodes(tmpIntcodes); 
            
        } while (tmpIntcodes[0] != DESIRED_OUTPUT);
        System.out.printf("Part 2 - 100 * [Noun %d] + [Verb %d] = %d\n", noun, verb, 100 * noun + verb);
    }

    static int[] fillIntcodes() throws IOException {
        File file = new File(".", "input.txt");
        Scanner in = new Scanner(file);

        String[] intcodesStr = in.nextLine().split(",");
        int[] intcodes = new int[intcodesStr.length];

        for (int i = 0; i < intcodesStr.length - 3; i++) {
            intcodes[i] = Integer.parseInt(intcodesStr[i]);
        }

        in.close();
        return intcodes;
    }

    static void runOpcodes(int[] intcodes) {
        for (int index = 0; index < intcodes.length; index += 4) {
            int opcode = intcodes[index];

            switch (opcode) {
                case 1:
                case 2:
                runOpcode(opcode, index, intcodes);
                break;
                case 99:
                return;
            }

        }
    }

    static void runOpcode(int opcode, int index, int[] intcodes) {
        int leftInput = intcodes[intcodes[index + 1]];
        int rightInput = intcodes[intcodes[index + 2]];
        int position = intcodes[index + 3];
        
        if (opcode == 1) {
            intcodes[position] = leftInput + rightInput;
        } else if (opcode == 2) {
            intcodes[position] = leftInput * rightInput;
        }

    }
}