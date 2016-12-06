import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class triangles{
  public static void main(String[] args) throws FileNotFoundException{
    int amountOfTriangles=0;
    Scanner tcl = new Scanner(new File("C:/Users/Alexis/OneDrive/Documents/AdventOfCode/Day3/triangles.txt"));

    while(tcl.hasNext()){
      int[] x = new int[3],y = new int[3], z = new int[3];
      for(int i =0; i < 3; i++){
          String numbers = tcl.nextLine();
          x[i] =  Integer.parseInt(numbers.substring(0,4).trim());
          y[i] = Integer.parseInt(numbers.substring(4,9).trim());
          z[i] = Integer.parseInt(numbers.substring(9,13).trim());
      }
      if((x[0]+x[1]>x[2] && x[0]+x[2]>x[1])&&(x[2]+x[1]>x[0]))
        ++amountOfTriangles;
      if((y[0]+y[1]>y[2] && y[0]+y[2]>y[1])&&(y[2]+y[1]>y[0]))
        ++amountOfTriangles;
      if((z[0]+z[1]>z[2] && z[0]+z[2]>z[1])&&(z[2]+z[1]>z[0]))
        ++amountOfTriangles;
    }
    System.out.println("Amount of triangles: "+amountOfTriangles);
    tcl.close();
  }
}
