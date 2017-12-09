import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashSet;

public class HighEntropy{

    public static boolean isValidPassword(String[] password){
        HashSet<String> words = new HashSet<String>(password.length);
        for(String s : password){
            if(words.contains(s)) return false;
            else words.add(s);
        }
        return true;
    }

    public static boolean validWithNoAnagram(String[] password ){
        for(int x = 0; x < password.length ; x++){
            for(int y = x + 1; y < password.length; y++){
                if(password[x].length() == password[y].length()){
                    if (isAnagram(password[x], password[y]))
                        return false;
                }
            }   
        }
        return true;
    }

    public static boolean isAnagram(String fw, String sw){
        StringBuilder sb = new StringBuilder(sw);
        for(int i = 0 ; i < fw.length() ; i++){
            for(int x = 0; x < sb.length() ; x++){
                if(fw.charAt(i) == sb.charAt(x)){
                    sb.deleteCharAt(x);
                    break;
                }
            }
        }
        return sb.length() == 0? true : false;
    }

    public static void main(String[] args){
        try{
            Scanner in = new Scanner( new File("input.txt").getAbsoluteFile());
            int count = 0, scount = 0;
            while(in.hasNextLine()){
                String[] password = in.nextLine().split("\\s+"); 
                if(isValidPassword(password)){
                    count++;
                    if(validWithNoAnagram(password)) scount++;
                }
            }
            System.out.println("Part 1 = " + count);
            System.out.println("Part 2 = " + scount);
            in.close();
        } catch(FileNotFoundException e){
            System.out.println("Error: " + e.getMessage());
        }

    }
}