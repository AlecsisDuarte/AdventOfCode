import java.util.Scanner;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/*
--- Day 14: One-Time Pad ---
In order to communicate securely with Santa while you're on this mission,
you've been using a one-time pad that you generate using a pre-agreed algorithm.
Unfortunately, you've run out of keys in your one-time pad, and so you need to
generate some more.

To generate keys, you first get a stream of random data by taking the MD5 of a
pre-arranged salt (your puzzle input) and an increasing integer index (starting
with 0, and represented in decimal); the resulting MD5 hash should be
represented as a string of lowercase hexadecimal digits.

However, not all of these MD5 hashes are keys, and you need 64 new keys for
your one-time pad. A hash is a key only if:

It contains three of the same character in a row, like 777. Only consider the
first such triplet in a hash.
One of the next 1000 hashes in the stream contains that same character five
times in a row, like 77777.
Considering future hashes for five-of-a-kind sequences does not cause those
hashes to be skipped; instead, regardless of whether the current hash is a
key, always resume testing for keys starting with the very next hash.

For example, if the pre-arranged salt is abc:

The first index which produces a triple is 18, because the MD5 hash of abc18
contains ...cc38887a5.... However, index 18 does not count as a key for your
one-time pad, because none of the next thousand hashes (index 19 through index
1018) contain 88888.
The next index which produces a triple is 39; the hash of abc39 contains eee.
It is also the first key: one of the next thousand hashes (the one at index
816) contains eeeee.
None of the next six triples are keys, but the one after that, at index 92,
is: it contains 999 and index 200 contains 99999.
Eventually, index 22728 meets all of the criteria to generate the 64th key.
So, using our example salt of abc, index 22728 produces the 64th key.

Given the actual salt in your puzzle input, what index produces your 64th
one-time pad key?
*/
public class pad{
  static int keysAmmount = 0;
  static int index = 0;
  static String salt = "";
  static MessageDigest md;

  public static String createKey(String data) throws UnsupportedEncodingException{
    byte[] theDigest = md.digest(data.getBytes("UTF-8"));
    return md5ToHex(theDigest);
  }

  public static boolean hasQuintuplets(char c, String line){
    for(int i = 0; i < line.length() - 4; i++){
      int count = 0;
      for(int x = 0; x < 5; x++){
        if(line.charAt(i+x) == c)
          ++count;
      }
      if(count > 4)
        return true;
    }
    return false;
  }

  public static char hasTriplets(String line){
    for(int i  = 0; i < line.length()-2; i++){
      if((line.charAt(i) == line.charAt(i+1)) && (line.charAt(i) ==  line.charAt(i+2))){
        return line.charAt(i);
      }
    }
    return 0;
  }

  public static boolean thousandHashes(char c) throws UnsupportedEncodingException{
    int found  = 0;
    int secondIndex = index;
    String line;
    for(int i = 0; i < 1000; i++){
      if(hasQuintuplets(c, (line = createKey(salt+(secondIndex++)))))
        return true;
    }
    return false;
  }

  public static String md5ToHex(byte[] md5) throws UnsupportedEncodingException{
    StringBuffer sb = new StringBuffer();
    for(byte b : md5) sb.append(byteToHex(b));
    return sb.toString();
  }

  public static String byteToHex(byte b){
    String hex = Integer.toHexString((int) b & 0xff);
    boolean hasTwoDigits = (2 == hex.length());
    if(hasTwoDigits) return hex;
    else return "0" + hex;
  }

  public static void main(String[] args) throws NoSuchAlgorithmException, UnsupportedEncodingException{
    Scanner tcl = new Scanner(System.in);
    md = MessageDigest.getInstance("MD5");
    System.out.print("Insert salt: ");
    salt = tcl.nextLine();
    boolean keysFound = false;
    while(!keysFound){
      String key;
      char triplets;
      do{
        key = createKey(salt+(index++));
        triplets = hasTriplets(key);
      }while(triplets < 32);
      if(thousandHashes(triplets)){
        if(++keysAmmount > 63)
          keysFound = true;
      }
    }

    System.out.println("The index that produces your 64th key is: " + (index-1));
  }
}
