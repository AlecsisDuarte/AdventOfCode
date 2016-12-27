import java.util.*;
import java.io.File;
import java.io.FileNotFoundException;

public class Scrambling{
  public static char[] swapPositions(char[] passcode, int fchar, int schar){
    char aux = passcode[fchar], aux2 = passcode[schar];
    passcode[fchar] = aux2;
    passcode[schar] = aux;
    return passcode;
  }

  public static char[] swapLetters(char[] passcode, char fchar, char schar){
    int firstc = 0, secondc = 0;
    while(passcode[firstc] != fchar) ++firstc;
    while(passcode[secondc] != schar) ++secondc;
    return swapPositions(passcode, firstc, secondc);
  }

  public static char[] moveLetter(char[] passcode, int from, int to){
    char letter = passcode[from];
    if(to > from){
      for(int i = from; i < to; i++) passcode[i] = passcode[i+1];
      passcode[to] = letter;
    }else{
      for(int i = from; i > to; i--) passcode[i] = passcode[i-1];
      passcode[to] = letter;
    }
    return passcode;
  }

  public static char[] rotateBased(char[] passcode, char letter){
    int index = 0;
    while(passcode[index++] != letter);
    if(index > 4)++index;
    return rotate(passcode, index, 'r');
  }
  public static char[] rotateBasedInverse(char[] passcode, char letter){
    int index = 0;
    while(passcode[index++] != letter);
    if(index > 4)++index;
    switch(index){
      case 3: index = 2;
      break;
      case 4: index = 6;
      break;
      case 6: index = 1;
      break;
      case 7: index = 5;
      break;
      case 8: break;
      case 9: index = 4;
      break;
      default: index = 7;
      break;
    }
    return rotate(passcode, index, 'r');
  }

  public static char[] reversePosition(char[] passcode, int from, int to){
    int aux = from;
    if((to-from)+1 < passcode.length){
      int index = 0;
      char[] toReverse = new char[(to-from)+1];
      while(aux < (to+1)) toReverse[index++] = passcode[aux++];
      // System.out.println("To Reverse: "+new String(toReverse));
      toReverse = reverse(toReverse);
      // System.out.println("Reversed: "+new String(toReverse));
      index = 0;
      for(int i = from; i < to+1; i++) passcode[i] = toReverse[index++];
    }else{
      passcode = reverse(passcode);
    }
    return passcode;
  }

  public static char[] reverse(char[] passcode){
    int index = 0;
    while(index < ((passcode.length)/2)){
      passcode = swapPositions(passcode, index,((passcode.length-1)-index));
      ++index;
    }
    return passcode;
  }

  public static char[] rotate(char[] passcode, int steps, char dir){
    char[] aux = new String(passcode).toCharArray();
    while(steps > passcode.length-1) steps %= passcode.length;
    if(dir == 'r'){
      for(int i = 0; i < passcode.length; i++){
        if((i+steps) > (passcode.length)-1) steps = (-i);
        passcode[i+steps] = aux[i];
      }
    }else{
      for(int i = 0; i < passcode.length; i++){
        if((i+steps) > passcode.length-1) steps = (-i);
        passcode[i] = aux[i+steps];
      }
    }
    return passcode;
  }

  public static char[] options(String[] action, char[] passcode, boolean inversed){
    switch(action[0].charAt(0)){
      case 's'://Swap
        if(action[1].charAt(0) == 'p'){
          int fchar = Integer.parseInt(action[2]);
          int schar = Integer.parseInt(action[5]);
          return (inversed? swapPositions(passcode, schar, fchar): swapPositions(passcode, fchar, schar));
        }else{
          char fchar = action[2].charAt(0);
          char schar = action[5].charAt(0);
          return (inversed? swapLetters(passcode, schar, fchar): swapLetters(passcode, fchar, schar));
        }

      case 'm': //Move
        int from = Integer.parseInt(action[2]);
        int to = Integer.parseInt(action[5]);
        return (inversed?moveLetter(passcode, to, from): moveLetter(passcode, from, to));

      case 'r'://Rotate, Reverse
        if(action[1].equals("based")){
          char letter = action[6].charAt(0);
          return (inversed? rotateBasedInverse(passcode,letter): rotateBased(passcode, letter));
        }else if(action[1].equals("positions")){
          from = Integer.parseInt(action[2]);
          to = Integer.parseInt(action[4]);
          // passcode = (inversed? reversePosition(passcode, to, from): reversePosition(passcode, from, to));
          return reversePosition(passcode, from, to);
        }else{
          int steps = Integer.parseInt(action[2]);
          char dir = action[1].charAt(0);
          if(inversed){
            if(dir == 'r')dir = 'l';
            else dir = 'r';
          }
          return rotate(passcode, steps, dir);
        }
    }
    return passcode;
  }

  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(System.in);
    char[] passcode = tcl.nextLine().toCharArray();
    String[] actions = new String[100];
    boolean inverse;
    int index = 0;

    /* Part 1 */
    System.out.print("Passcode to Scramble: ");
    tcl = new Scanner(new File("actions.txt"));
    while(tcl.hasNext()){
      actions[index]= tcl.nextLine();
      String[] action = actions[index++].split(" ");
      inverse = false;
      passcode = options(action, passcode, inverse);
    }

    System.out.println("Scrambled passcode: "+new String(passcode));

    /* Part 2 */
    System.out.print("Passcode to Unscrumble: ");
    tcl = new Scanner(System.in);
    passcode = tcl.nextLine().toCharArray();
    while(index > 0){
      String[] action = actions[--index].split(" ");
      inverse = true;
      passcode = options(action, passcode, inverse);
    }
    System.out.println("Unscrambled passcode: "+new String(passcode));
    tcl.close();
  }
}
