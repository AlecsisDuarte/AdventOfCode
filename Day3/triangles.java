import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

/*
--- Part Two ---

Now that you've helpfully marked up their design documents, it
occurs to you that triangles are specified in groups of three vertically. Each set of three numbers in a column specifies a triangle. Rows are unrelated.

For example, given the following specification, numbers with the
same hundreds digit would be part of the same triangle:

101 301 501
102 302 502
103 303 503
201 401 601
202 402 602
203 403 603
In your puzzle input, and instead reading by columns, how many of
the listed triangles are possible?
*/
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
