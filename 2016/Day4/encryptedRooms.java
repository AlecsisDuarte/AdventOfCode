import java.util.Scanner;
import java.io.*;
/*
--- Day 4: Security Through Obscurity ---
Each room consists of an encrypted name (lowercase letters
separated by dashes) followed by a dash, a sector ID, and a
checksum in square brackets.

A room is real (not a decoy) if the checksum is the five most
common letters in the encrypted name, in order, with ties broken
by alphabetization. For example:

aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common
letters are a (5), b (3), and then a tie between x, y, and z,
which are listed alphabetically.
a-b-c-d-e-f-g-h-987[abcde] is a real room because although the
letters are all tied (1 of each), the first five are listed
alphabetically.
not-a-real-room-404[oarel] is a real room.
totally-real-room-200[decoy] is not.
Of the real rooms from the list above, the sum of their sector
IDs is 1514.

What is the sum of the sector IDs of the real rooms?
*/
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
