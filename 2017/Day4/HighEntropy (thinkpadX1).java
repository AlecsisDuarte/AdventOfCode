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
        HashSet<String> words = new HashSet<String>(password.length);
        for (String s : password) {
            if (words.contains(s) || words.contains(getAnagram(s)))
                return false;
            else{
                words.add(s);
            }

        }
        return true;
    }

    public static String getAnagram(String word){
        String anagram = "";
        for(int i = word.length()-1 ; i >= 0 ; i--){
            anagram += word.charAt(i);
        }
        return anagram;
    }

    public static void main(String[] args){
        try{
            Scanner in = new Scanner( new File("input.txt").getAbsoluteFile());
            int count = 0, scount = 0;
            while(in.hasNextLine()){
                String[] password = in.nextLine().split("\\s+"); 
                if(isValidPassword(password)) count++;
                if(validWithNoAnagram(password)) scount++;
            }
            System.out.println("Part 1 = " + count);
            in.close();
        } catch(FileNotFoundException e){
            System.out.println("Error: " + e.getMessage());
        }

    }
}