import java.util.Scanner;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class maze{
  static MessageDigest md;
  static int width = 4, height = 4;
  // static char[][] maze = new char[width][height];

  public static String createHash(String passcode) throws UnsupportedEncodingException{
    byte[] theDigest = md.digest(passcode.getBytes("UTF-8"));
    return md5ToHex(theDigest);
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

  public static String move(String passcode, int[] preferedDoor) throws UnsupportedEncodingException{
    int[] position = {0,0};
    char lastMove = 'N';
    while(position[0] < width-1 || position[1] < height-1){
      String hash = createHash(passcode);
      char[] options = hash.substring(0,4).toCharArray();
      System.out.println("Pascode: "+passcode+"\nHash: "+new String(options)+
      "\nPosition: "+position[0]+","+position[1]+"\n");
      boolean move = false;
      int index = 0;
      while(!move && index < preferedDoor.length){
        int door = preferedDoor[index];
        ++index;
        if(doorOpen(options[door])){
          switch(door){
            case 0: //Up
              if(position[1] > 0){
                lastMove = 'U';
                position[1]--;
                passcode += lastMove+"";
                move = true;
              }
            break;
            case 1: //Down
            if(position[1] < height){
              lastMove = 'D';
              position[1]++;
              passcode += lastMove+"";
              move = true;
            }
            break;
            case 3: //Right
              if(position[0] < width){
                lastMove = 'R';
                passcode += lastMove+"";
                position[0]++;
                move = true;
              }
            break;
            case 2: //Left
            if(position[0] > 0){
              lastMove = 'L';
              passcode += lastMove+"";
              position[0]--;
              move = true;
            }
            break;
          }
        }
      }
    }
    return passcode;
  }

  public static boolean doorOpen(char door){
    if(door > 97 && door < 103) return true;
    return false;
  }

  public static void main(String[] args) throws UnsupportedEncodingException, NoSuchAlgorithmException{
//    Scanner tcl = new Scanner(System.in);
    md = MessageDigest.getInstance("MD5");
    String passcode = "ihgpwlah";
    int[] priority2 = {3,1,2,0};
    int[] priority = {1,3,0,2};
    String fPasscode = move(passcode, priority);
    String sPasscode = move(passcode, priority2);
    passcode = (fPasscode.length() < sPasscode.length()? fPasscode : sPasscode);
    System.out.println("The shortest passcode is: "+passcode);
  }
}
