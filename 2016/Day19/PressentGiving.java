import java.util.Scanner;

public class PressentGiving{
  public static void main(String[] args){
    Scanner tcl = new Scanner(System.in);
    ElfList elfs = new ElfList();
    System.out.print("Ammount of elfs: ");
    elfs.addElfs(tcl.nextInt());
    // System.out.println();
    // elfs.robNextPressent();
    // elfs.printElfList();
    elfs.robInfrontPressent();
    System.out.println("Remaining elf: "+elfs.getElfNumber());
  }
}
