import java.util.Scanner;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
/*
--- Day 5: How About a Nice Game of Chess? ---
This program consist in a creation of a MD5 hash,
using a DoorID and an incrementing integer index
starting with 0.
Then after getting a MD5 hash of each index incremental
value, we look for md5 hash that starts with 5 zeros
and the 6th character is one character of our password
after getting 8 characters our password is done.
Example:
  DoorID: abc
  password: 18f47a30
*/
public class hashing{
  public static void main(String[] args) throws NoSuchAlgorithmException, UnsupportedEncodingException{
    Scanner tcl = new Scanner(System.in);
    char[] password  = new char[8];
    int index =0;
    System.out.print("Insert door ID: ");
    String doorId = tcl.nextLine();

    for(int i =0; i<password.length; i++){
    	String hashtext ="";
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
    	System.out.println(new String(hashtext));
    	password[i]=hashtext.charAt(5);
    }
    System.out.println("The password is: "+new String(password));
  }
}
