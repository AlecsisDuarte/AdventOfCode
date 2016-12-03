import java.util.Scanner;
package default;

public class blocksAway{
  public static void main(String[] args){
    Scanner tcl = new Scanner(System.in);
    int cantBlocks=0;
    int direction[2]={0,0};
    char aux=' ';
    String[] blocks = tcl.nextLine().split(", ");
    for(int i =0; i<blocks.length; i++){
      if(blocks[i].startsWith(aux+"")){
        cantBlocks-= Integer.parseInt(blocks[i].substring(1));
        aux = ' ';
      }else{
        if(blocks[i].startsWith("L"))
          cantBlockes[Integer.parseInt(blocks[i].substring(1));
        aux = blocks[i].charAt(0);
      }
    }
    System.out.println("Cantidad de Bloques = "+cantBlocks);
  }
}
