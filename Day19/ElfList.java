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

  public int robNextPressent(){
    Node currentElf = lastElf;
    int numberOfElves = elves;
    while(numberOfElves-- > 1){
      Node nextElf = currentElf.getNext();
      currentElf.setNext(nextElf.getNext());
      currentElf = nextElf.getNext();
    }
    return currentElf.getNumber();
  }

  public int robInfrontPressent(){
    Node currentElf = lastElf;
    int numberOfElves = elves;
    HashSet hs = new HashSet();
    while(numberOfElves > 1){
      int skips = (numberOfElves/2);
      while(--skips > 0) currentElf = currentElf.getNext();
      Node deletedElf = currentElf.getNext();
      currentElf.setNext(deletedElf.getNext());
      skips = ((--numberOfElves/2)+2);
      while(skips-- > 0) currentElf = currentElf.getNext();
    }
    return currentElf.getNumber();
  }
}
