import java.util.Scanner;

public class PressentGiving{
  public static void main(String[] args){
    Scanner tcl = new Scanner(System.in);
    ElfList elves = new ElfList();
    System.out.print("Ammount of elves: ");
    elves.addElfs(tcl.nextInt());
    // System.out.println();

    /* For Part 1 */
    // System.out.println("Remaining elf: "+elves.robNextPressent());

    /* For Part 2 */
    System.out.println("Remaining elf: "+elves.robInfrontPressent());
  }
}
