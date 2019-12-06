import java.io.FileNotFoundException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

public class TheTyrannyoftheRocketEquation {
    
    public static void main(String[] args) throws FileNotFoundException {
        Path inptPath = Paths.get("./input.txt");
        Scanner in = new Scanner(inptPath.toFile());

        long totalFuel = 0l, totalFuelPt2 = 0l;

        while (in.hasNextInt()) {
            int mass = in.nextInt();
            totalFuel += calculateFuel(mass);
            totalFuelPt2 += calculateFuelPartTwo(mass);

        }

        System.out.printf("Part 1 - Total fuel %d\n", totalFuel);
        System.out.printf("Part 2 - Total fuel %d\n", totalFuelPt2);
        in.close();
    }

    static int calculateFuel(int number) {
        int round = Math.floorDiv(number, 3);
        return round - 2;
    }

    static long calculateFuelPartTwo(int mass) {
        int fuel = calculateFuel(mass);
        long totalFuel = 0l;
        while (fuel > 0) {
            totalFuel += fuel;
            fuel = calculateFuel(fuel);
        }

        return totalFuel;
    }


}