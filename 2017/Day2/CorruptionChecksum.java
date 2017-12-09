import java.util.Arrays;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

public class CorruptionChecksum{
    public static void main(String[] args){
        Scanner in = new Scanner(System.in);
        try{
            in = new Scanner(new File("./input.txt").getAbsoluteFile());
        } catch(FileNotFoundException e){
            System.out.println("FileNotFound: " + e.getMessage());
        }
        int sum = 0;
        int sum2 = 0;
        while(in.hasNextLine()){
            int smallest = Integer.MAX_VALUE;
            int largest = Integer.MIN_VALUE;
            int[] nums = Arrays.asList(in.nextLine().split("\\s+")).stream().mapToInt(Integer::parseInt).toArray();
            for(int num : nums){
                smallest = num < smallest ? num : smallest;
                largest = num > largest ?  num : largest;
            }
            sum += largest - smallest;

            for(int index = 0; index < nums.length; index++){
                int tmp = sum2;
                for(int subIndex = index+1; subIndex < nums.length ; subIndex++){
                    if(nums[index] % nums[subIndex] == 0){
                        sum2 += nums[index] /nums[subIndex];
                        break;
                    } else if(nums[subIndex] % nums[index] == 0){
                        sum2 += nums[subIndex] / nums[index];
                        break;
                    }
                }
                if(tmp != sum2) break;
            }
        }
        System.out.println("Part2 sum = " + sum2);
        System.out.println("Part1 sum = " + sum);
    }
}