import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class triangles{
  public static void main(String[] args) throws FileNotFoundException{
    int amountOfTriangles=0;
    Scanner tcl = new Scanner(new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day3/triangles.txt"));

    while(tcl.hasNext()){
      String numbers = tcl.nextLine();
      int a,b,c;
      a = Integer.parseInt(numbers.substring(0,4).trim());
      b = Integer.parseInt(numbers.substring(4,9).trim());
      c = Integer.parseInt(numbers.substring(9,13).trim());

      if((a+b>c && b+c>a)&&(a+c>b))
    	++amountOfTriangles;
    }
    System.out.println("Amount of triangles: "+amountOfTriangles);
    tcl.close();
  }
}
