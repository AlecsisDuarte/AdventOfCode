import java.util.Scanner;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
/*
This program consist in a creation of a MD5 hash,
using a DoorID and an incrementing integer index
starting with 0.
Then after getting a MD5 hash of each index incremental
value, we look for md5 hash that starts with 5 zeros
and the 6th character is the character that tells you
in which position you'll store the next characters to it (7th).
So the position must be between 0-7 as the password is only 8digits
long.
Example:
  DoorID: abc
  password: 05ace8e3
*/
public class hashingV2{
  public static void main(String[] args) throws NoSuchAlgorithmException, UnsupportedEncodingException{
    Scanner tcl = new Scanner(System.in);
    char[] password  = new char[8];
    int index =0;
    System.out.print("Insert door ID: ");
    String doorId = tcl.nextLine();
    int i=0;
    while(i<8){
      String hashtext ="";
      int position=0;
      do{
        byte[] bytesOfMessage = (doorId+index).getBytes("UTF-8");
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] thedigest = md.digest(bytesOfMessage);
        BigInteger bigInt = new BigInteger(1,thedigest);
        hashtext = bigInt.toString(16);
        while(hashtext.length()<32){
          hashtext = "0"+hashtext;
        }
        ++index;
      }while(!(hashtext.startsWith("00000")));
      if(hashtext.charAt(5)>47 && hashtext.charAt(5)<56){
        position = hashtext.charAt(5)-48;
        if(password[position] == 0){
          System.out.println(new String(hashtext));
          password[hashtext.charAt(5)-48]=hashtext.charAt(6);
          ++i;
        }
      }

    }
    System.out.println("The password is: "+new String(password));
  }
}
