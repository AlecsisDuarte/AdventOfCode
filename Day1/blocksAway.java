import java.util.*;
/*
--- Day 1: No Time for a Taxicab ---
This program is meant to find the amount of blocks you will have to walk
to arrive to an specific place, using as directio L or R  accompanied by a
number of blocks that you need to walk on that direction.
Each direction must be separated with a comma and a space.
Example:
  Input:
    L1, L2, R2
  result:
    (-3,-2)
    5 blocks traveled.

 In part two you have to find the first place you visited twice.
 Example:
 	input:
 		R8, R4, R4, R8
 	result:
 		First location visited is 4 blocks away.

*/
public class blocksAway {
	int x,y;
	String key;
	public blocksAway(int _x, int _y){
		this.x=_x;
		this.y=_y;
		this.key = x+","+y;
	}

	public static void main(String[] args) {

	  Scanner tcl = new Scanner(System.in);
	  int x = 0 ,y = 0;
	  char lastDir=' ';
	  String[] blocks = tcl.nextLine().split(", ");
	  blocksAway p = new blocksAway(0,0);
	  blocksAway p2;

	  /* For Part 2 */
	  Hashtable<String, Integer> points = new Hashtable<String, Integer>(100);
	  boolean visitedTwice=false;

	  for(int i =0; i<blocks.length; i++){
	  	int amountOfBlocks = Integer.parseInt(blocks[i].substring(1));
	  	switch(blocks[i].charAt(0)){
	  	case 'R':
	  		if(lastDir == 'R'){
	  			y-=amountOfBlocks;
	  			lastDir= 'S'; //Because you'll be facing south
	  		}
	  		else if(lastDir == 'L'){
	  			y+=amountOfBlocks;
	  			lastDir= ' '; //You'll be facing north, so it restarts
	  		}
	  		else if(lastDir == 'S'){
	  			x-=amountOfBlocks;
	  			lastDir = 'L'; //You'll be facing west
	  		}
	  		else{
	  			x+=amountOfBlocks;
	  			lastDir = 'R'; //You'll be facing east
	  		}
	  		break;
	  	case 'L':
	  		if(lastDir == 'R'){
	  			y+=amountOfBlocks;
	  			lastDir= ' '; //You'll be facing north, so it restarts
	  		}
	  		else if(lastDir == 'L'){
	  			y-=amountOfBlocks;
	  			lastDir= 'S'; //Because you'll be facing south
	  		}
	  		else if(lastDir == 'S'){
	  			x+=amountOfBlocks;
	  			lastDir = 'R'; //You'll be facing east
	  		}
	  		else{
	  			x-=amountOfBlocks;
	  			lastDir = 'L'; //You'll be facing west
	  		}
	  		break;
	  	}

	  	/* For Part 2 */
	  	if(!visitedTwice){
	  		p2= new blocksAway(x,y);
	  		if(p2.x != p.x){
	  			if(p2.x > p.x)
	  				for(int _x = p.x+1; _x <= p2.x; ++_x){
	  					p= new blocksAway(_x,p.y);
	  					if(points.containsKey(p.key)){
	  						_x=p2.x+1;
	  						visitedTwice=true;
	  					}else
		  					points.put(p.key, absOfTwoInt(p.x, p.y));
	  				}
	  			else
	  				for(int _x = p.x-1; _x >= p2.x; --_x){
	  					p= new blocksAway(_x, p.y);
		  				if(points.containsKey(p.key)){
	  						_x=p2.x-1;
	  						visitedTwice=true;
		  				}else
		  					points.put(p.key, absOfTwoInt(p.x, p.y));
		  			}
	  		}else{
	  			if(p2.y > p.y)
	  				for(int _y = p.y+1; _y <= y; ++_y){
	  					p=new blocksAway(p.x,_y);
	  					if(points.containsKey(p.key)){
	  						_y=p2.y+1;
	  						visitedTwice=true;
	  					}else
		  					points.put(p.key, absOfTwoInt(p.x, p.y));

	  				}
	  			else
	  				for(int _y = p.y-1; _y >= p2.y; --_y){
	  					p= new blocksAway(p.x, _y);
	  					if(points.containsKey(p.key)){
	  						_y=p2.y-1;
	  						visitedTwice=true;
	  					}else
		  					points.put(p.key, absOfTwoInt(p.x, p.y));
	  				}
	  		}
	  	}
	  }

	 System.out.println("Last point is at ("+x+","+y+")");
	 System.out.format("%d blocks away\n", absOfTwoInt(x,y));
	 if(visitedTwice)
		 System.out.format("First place visited twice is %d blocks away at (%s)\n",points.get(p.key),p.key);
	 else
		 System.out.println("No place visited twice");
	 //printHashTable(points); In case you want to see all the values inside the hashtable
	 tcl.close();
	}
	public static String keyCreator(int x, int y){
		return x+","+y;
	}
	public static void printHashTable(Hashtable<String, Integer> h){
		System.out.println(h);
	}
	public static int absOfTwoInt(int x, int y){
		return Math.abs(x)+Math.abs(y);
	}
}
