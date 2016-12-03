import java.util.Scanner;

public class blocksAway {
	public static void main(String[] args) {
		Scanner tcl = new Scanner(System.in);
	    int x = 0 ,y = 0;
	    char lastDir=' ';
	    String[] blocks = tcl.nextLine().split(", ");
	    for(int i =0; i<blocks.length; i++){
	    	int amountOfBlocks = Integer.parseInt(blocks[i].substring(1));
	    	switch(blocks[i].charAt(0)){
	    	case 'R':
	    		if(lastDir == 'R'){
	    			x-=amountOfBlocks;
	    			lastDir= 'S'; //Because you'll be facing south
	    		}
	    		else if(lastDir == 'L'){
	    			x+=amountOfBlocks;
	    			lastDir= ' '; //You'll be facing north, so it restarts
	    		}
	    		else if(lastDir == 'S'){
	    			y-=amountOfBlocks;
	    			lastDir = 'R'; //You'll be facing west
	    		}
	    		else{
	    			y+=amountOfBlocks;
	    			lastDir = 'R'; //You'll be facing east
	    		}
	    		break;
	    	case 'L':
	    		if(lastDir == 'R'){
	    			x+=amountOfBlocks;
	    			lastDir= ' '; //You'll be facing north, so it restarts
	    		}
	    		else if(lastDir == 'L'){
	    			x-=amountOfBlocks;
	    			lastDir= 'S'; //Because you'll be facing south
	    		}
	    		else if(lastDir == 'S'){
	    			y+=amountOfBlocks;
	    			lastDir = 'L'; //You'll be facing east
	    		}
	    		else{
	    			y-=amountOfBlocks;
	    			lastDir = 'L'; //You'll be facing west
	    		}
	    		break;
	    	}
	    }
	    System.out.println("("+x+","+y+")");
	    x = Math.abs(x);
	    y = Math.abs(y);
	    System.out.format("%d blocks away", x+y);
	}

}
