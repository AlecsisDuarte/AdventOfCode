import java.util.Scanner;
import java.io.File;
import java.io.*;

/*
  --- Day 7: Internet Protocol Version 7 ---
  For part 1: You have to find out if an ip address has TSL
  and for that, you have to find an ABBA annotation, which means
  that you have to find four-character sequence which consists of
  a pair of two differenc characters followed by the reverse of that
  pair, sush as xyyx or abba. But not inside the brackets.

  For part 2: You have to find out if an ip addres has SSL
  and for that you look for ABA anotations for example aba or xyyx
  and inside the brackets you have to find an BAB annotation, which
  is the same as de ABA just reversed.
  Example:
    ABA = xyx
    BAB = yxy

*/
public class ABBA{
  public static boolean hasABBAIn(String line){
    String[] bunchOfCharacters = line.split("-");
    for(int x =0; x < bunchOfCharacters.length; x++){
      for(int y =0; y < bunchOfCharacters[x].length()-3; y++){
        if((bunchOfCharacters[x].charAt(y) == bunchOfCharacters[x].charAt(y+3)
        && bunchOfCharacters[x].charAt(y+1) == bunchOfCharacters[x].charAt(y+2))
        && (bunchOfCharacters[x].charAt(y) != bunchOfCharacters[x].charAt(y+2)))
        return true;
      }
    }
    return false;
  }
  /* For Part 2 */
  public static boolean isSSL(String outsideBrackets, String insideBrakets){
    String[] bunchOfCharacters = outsideBrackets.split("-");
    for(int x =0; x < bunchOfCharacters.length; x++){
      for(int y =0; y < bunchOfCharacters[x].length()-2; y++){
        if(bunchOfCharacters[x].charAt(y) == bunchOfCharacters[x].charAt(y+2)
        && bunchOfCharacters[x].charAt(y+1) != bunchOfCharacters[x].charAt(y+2))
          if(searchBAB(insideBrakets, bunchOfCharacters[x].substring(y,y+2))){
            return true;
          }
      }
    }
    return false;
  }
  public static boolean searchBAB(String line, String aba){
    String[] bunchOfCharacters = line.split("-");
    for(int x =0; x < bunchOfCharacters.length; x++){
      for(int y =0; y < bunchOfCharacters[x].length()-2; y++){
        if((bunchOfCharacters[x].charAt(y) == aba.charAt(1)
        && bunchOfCharacters[x].charAt(y+1) == aba.charAt(0))
        && bunchOfCharacters[x].charAt(y+2) == aba.charAt(1))
          return true;
      }
    }
    return false;
  }
  public static void main(String[] args) throws FileNotFoundException{
    int ammountOfIpTLS = 0, ammountOfIpSSL = 0;
    Scanner tcl = new Scanner(
      new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day7/ips.txt")
    );
    while(tcl.hasNext()){
      String[] line = tcl.nextLine().split("[\\[\\]]");
      String outsideBrackets = "", insideBrakets = "";
      for(int i =0; i < line.length; i++){
        if((i+1)%2 == 0)
          insideBrakets += line[i]+"-";
        else
          outsideBrackets += line[i]+"-";
      }
      /* For Part 2 */
      if(!hasABBAIn(insideBrakets))
        if(hasABBAIn(outsideBrackets))
          ++ammountOfIpTLS;
      if(isSSL(outsideBrackets, insideBrakets))
        ++ammountOfIpSSL;
    }
    System.out.println(ammountOfIpTLS+" IPs support TLS");
    System.out.println(ammountOfIpSSL+" IPs support SSL");
  }
}
