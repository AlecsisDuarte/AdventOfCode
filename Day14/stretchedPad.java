import java.util.*;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
/*
--- Part Two ---

Of course, in order to make this process even more secure, you've also
implemented key stretching.

Key stretching forces attackers to spend more time generating hashes.
Unfortunately, it forces everyone else to spend more time, too.

To implement key stretching, whenever you generate a hash, before you use it,
you first find the MD5 hash of that hash, then the MD5 hash of that hash, and
so on, a total of 2016 additional hashings. Always use lowercase hexadecimal
representations of hashes.

For example, to find the stretched hash for index 0 and salt abc:

Find the MD5 hash of abc0: 577571be4de9dcce85a041ba0410f29f.
Then, find the MD5 hash of that hash: eec80a0c92dc8a0777c619d9bb51e910.
Then, find the MD5 hash of that hash: 16062ce768787384c81fe17a7a60c7e3.
...repeat many times...
Then, find the MD5 hash of that hash: a107ff634856bb300138cac6568c0f24.
So, the stretched hash for index 0 in this situation is a107ff.... In the end,
you find the original hash (one use of MD5), then find the
hash-of-the-previous-hash 2016 times, for a total of 2017 uses of MD5.

The rest of the process remains the same, but now the keys are entirely
different. Again for salt abc:

The first triple (222, at index 5) has no matching 22222 in the next thousand
hashes.
The second triple (eee, at index 10) hash a matching eeeee at index 89, and so
it is the first key.
Eventually, index 22551 produces the 64th key (triple fff with matching fffff
at index 22859.
Given the actual salt in your puzzle input and using 2016 extra MD5 calls of
key stretching, what index now produces your 64th one-time pad key?
*/
public class stretchedPad{
  static int keysAmmount = 0;
  static int index = 0;
  static String salt = "";
  static MessageDigest md;
  static String[] keys = new String[1000];
  static Hashtable<String, String> previousKeys = new Hashtable<String,String>();

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
    String key;
    for(int i = 0; i < 1000; i++){
      key = createKey(salt+secondIndex++);
      if(previousKeys.containsKey(key))
        key = previousKeys.get(key);
      else{
        previousKeys.put(key,(key = stretchKey(key)));
      }
      if(hasQuintuplets(c, key)){
        return true;
      }

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
  public static String stretchKey(String key) throws UnsupportedEncodingException{
    int stretches = 2016;
    for(; 0 < stretches; stretches--)
      key = createKey(key);
    return key;
  }
  public static boolean keysIsEmpty(){
    for(String line : keys){
      if(line != null)
        return false;
    }
    return true;
  }
  public static void emptyKeys(){
    for(int i = 0; i < keys.length; i++){
      keys[i] = null;
    }
  }
  public static void main(String[] args) throws NoSuchAlgorithmException, UnsupportedEncodingException{
    Scanner tcl = new Scanner(System.in);
    md = MessageDigest.getInstance("MD5");
    System.out.print("Insert salt: ");
    salt = tcl.nextLine();
    boolean keysFound = false;
    int keyPosition = 0;
    while(!keysFound){
      String key = null;
      char triplets;
      do{
        key = createKey(salt+(index++));
        if(previousKeys.containsKey(key))
          key = previousKeys.get(key);
        else
          previousKeys.put(key,(key = stretchKey(key)));
        triplets = hasTriplets(key);
      }while(triplets < 32);
      // System.out.println("Index "+(index-1)+": "+key +" Tripplet = "+triplets);
      if(thousandHashes(triplets)){
        if(++keysAmmount > 63)
        keysFound = true;
      }
    }

    System.out.println("The index that produces your 64th key is: " + (index-1));
  }
}
