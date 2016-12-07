import java.util.Scanner;
import java.io.*;

public class encryptedRooms{
  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(
      new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day4/roomsId.txt")
    );
    int sectorsSum=0;
    while(tcl.hasNext()){
      String encrypted = tcl.nextLine();
      char[] checksum = encrypted.substring(encrypted.length()-6,encrypted.length()-1).toCharArray();
      int[] counts = new int[checksum.length];
      int sectorId = Integer.parseInt(encrypted.substring(encrypted.length()-10,encrypted.length()-7));
      encrypted = encrypted.substring(0,encrypted.length()-11).replace("-"," ");
      boolean room = true;

      for(int x = 0; x < checksum.length; x++){
        if(room)
    	  for(int y = 0; y < encrypted.length(); y++){
    		  if(checksum[x] == encrypted.charAt(y))
    			  counts[x]++;
    	  }
        if(counts[x] == 0) room = false;
      }
      if(room)
	      for(int i = 0; i < 4; i++){
	    	if(counts[i] < counts[i+1])
	          room = false;
	        else if(counts[i] == counts[i+1])
	          if((int)checksum[i] > (int)checksum[i+1])
	            room = false;
	      }
      if(room){
    	  sectorsSum += sectorId;

    	  /* For part 2 */
    	  char[] letters = encrypted.toCharArray();
    	  for(int i = 0; i < letters.length; i++){
    		  if(letters[i] != 32){
    			  int letter = letters[i] += sectorId;
    			  while(letter>122)
    				  letter-=26;
    			  letters[i] = (char)letter;
    		  }
    	  }
    	  String uncrypted = new String(letters);
    	  if(uncrypted.startsWith("north"))
    		  System.out.println("Room name: "+ uncrypted +" ID: "+sectorId+"\n");
      }

    }
    System.out.println("The sum of sectors ID(of real rooms) is: "+sectorsSum);
    tcl.close();
  }
}
