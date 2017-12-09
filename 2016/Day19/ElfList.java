import java.util.HashSet;

public class ElfList{
  private Node lastElf;
  private int elves;

  public ElfList(){
    lastElf = new Node();
    lastElf.setNext(lastElf);
    lastElf.setNumber(1);
    elves = 0;
  }

  public void addElfs(int ammountOfElfs){
    ++ammountOfElfs;
    for(int i  = 1 ; i < ammountOfElfs; i++){
      if(elves > 0){
        Node currentElf = new Node(i,lastElf.getNext());
        lastElf.setNext(currentElf);
        lastElf = currentElf;
      }
      ++elves;
    }
    lastElf = lastElf.getNext();
  }
  public void printElfList(){
    Node elf = lastElf;
    for(int i = 0; i < elves; i++){
      System.out.println(elf.getNumber());
      elf = elf.getNext();
    }
  }
  public int getElfNumber(){
    return lastElf.getNumber();
  }

  public int getElfAmmount(){
    return elves;
  }

  public void robNextPressent(){
    Node currentElf = lastElf;
    int numberOfElves = elves;
    while(numberOfElves-- > 1){
      Node nextElf = currentElf.getNext();
      currentElf.setNext(nextElf.getNext());
      currentElf = nextElf.getNext();
    }
  }

  public void robInfrontPressent(){
    Node currentElf = lastElf;
    int numberOfElves = elves;
    HashSet hs = new HashSet();
    while(numberOfElves > 2){
      int skips = (numberOfElves/2);
      // System.out.println("Current elf: "+currentElf.getNumber());
      while(--skips > 0) currentElf = currentElf.getNext();
      Node deletedElf = currentElf.getNext();
      System.out.println("Deleted Elf: "+deletedElf.getNumber());
      currentElf.setNext(deletedElf.getNext());
      skips = numberOfElves;
      while(--skips > 0) currentElf = currentElf.getNext();
      // System.out.println("Elf remaining: "+(numberOfElves)+"\n");
      --numberOfElves;
    }
    lastElf = currentElf.getNext();
  }
}
