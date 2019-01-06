import java.util.Scanner;
import java.io.FileNotFoundException;
import java.io.File;;

public class KnotHash{
    private static void twist(int[] list, int index, int length){
        int[] reversed = new int[length];
        int tmpIndex = index;
        for(int i = 0; i < length; i++){
            if(i+tmpIndex == list.length) tmpIndex = 0 - i;
            reversed[i] = list[i+tmpIndex];
        }
        while(length-- > 0){
            if(index == list.length) index = 0;
            list[index++] = reversed[length];
        }
    }

    private static int[] startList(int size){
        int[] list = new int[size];
        while(size-- > 0) list[size] = size;
        return list;
    }

    private static int[] getPartTwoLengths(String lengthLine){
        int index = 0;
        int[] lengths = new int[lengthLine.length() + 5];
        for (char c : lengthLine.toCharArray()) {
            lengths[index++] = (int) c;
        }
        int[] suffix = { 17, 31, 73, 47, 23 };
        for (int i : suffix) {
            lengths[index++] = i;
        }
        return lengths;
    }

    private static int[] getSparseHash(int[] numbers){
        int[] sparseHash = new int[numbers.length/16];
        int start = 0;
        int end = 16;
        for(int i = 0 ; i < sparseHash.length; i++){
            int xorNumber = numbers[start];
            for(int pos = start+1; pos < end; pos++){
                xorNumber ^= numbers[pos];
            }
            start += 16;
            end += 16;
            sparseHash[i] = xorNumber;
        }

        return sparseHash;
    }

    private static String getHexadecimal(int num){
        String hex = "";
        if(num / 16 > 0){
            int digit = num/16;
            if (digit > 9){
                hex = (char) (digit +  '@');
            } else {
                hex = (char) (digit + '0');
            }
            num = num % 16;
        }else {
            hex = "0";
        }
        return hex;
    }
    public static void main(String[] args){
        try{
            Scanner in = new Scanner(new File("input.txt").getAbsoluteFile());
            int size = 256;
            int[] list = startList(size);
            int skip = 0;
            int index = 0;
            String line = in.nextLine();
            for(String l : line.split(",")){
                int length = Integer.parseInt(l);
                twist(list, index, length);
                index += length + skip++;
                while(index >= list.length) index -= list.length;
            }
            System.out.println("Part 1 - First Two Multiplication = " + (list[0] * list[1]));

            list = startList(size);
            int[] lengths = getPartTwoLengths(line);
            index = 0;
            skip = 0;

            for(int times = 0; times < 64; times++){
                for(int length : lengths){
                    twist(list, index, length);
                    index+= length + skip++;
                    while(index >= list.length) {
                        index -= list.length;
                    }
                }
            }

            int[] sparseHash = getSparseHash(list);
            for(int n : sparseHash){
                System.out.print(n);
            }

            in.close();
        } catch (FileNotFoundException e){
            System.err.println(e.getMessage());
        }
    }
}