import java.util.*;
import java.io.File;
import java.io.FileNotFoundException;
/*
--- Day 20: Firewall Rules ---

You'd like to set up a small hidden computer here so you can use it to get back
into the network later. However, the corporate firewall only allows
communication with certain external IP addresses.

You've retrieved the list of blocked IPs from the firewall, but the list seems
to be messy and poorly maintained, and it's not clear which IPs are allowed.
Also, rather than being written in dot-decimal notation, they are written as
plain 32-bit integers, which can have any value from 0 through 4294967295,
inclusive.

For example, suppose only the values 0 through 9 were valid, and that you
retrieved the following blacklist:

5-8
0-2
4-7
The blacklist specifies ranges of IPs (inclusive of both the start and end
value) that are not allowed. Then, the only IPs that this firewall allows are 3
and 9, since those are the only numbers not in any range.

Given the list of blocked IPs you retrieved from the firewall (your puzzle
input), what is the lowest-valued IP that is not blocked?

--- Part Two ---

How many IPs are allowed by the blacklist?
*/
public class BlockedIp{
  public static long lowestNotBlockedIP(ArrayList<Pair> pairs){
    Pair range = pairs.get(0);
    if(range.min > 0) return 0;

    for(int i = 1; i < pairs.size(); i++){
      Pair nextRange = pairs.get(i);
      if(range.max < nextRange.min)
        return range.max+1;
      else if(range.max < nextRange.max)
        range.max = nextRange.max;
    }
    return range.max+1;
  }
  public static long ipsAllowed(ArrayList<Pair> pairs){
    long count = 0;
    Pair range = pairs.get(0);
    if(range.min > 0)count += countIps(0, range.min);
    for(int i = 1; i < pairs.size(); i++){
      Pair nextRange = pairs.get(i);
      if(range.max < nextRange.min){
        count += countIps(range.max, nextRange.min);
        if(range.max < nextRange.max) range.max = nextRange.max;
      }
      else if(range.max < nextRange.max) range.max = nextRange.max;
    }
    return count;
  }
  public static long countIps(long low, long high){
    return (high-low)-1;
  }
  public static void main(String[] args) throws FileNotFoundException{
    Scanner tcl = new Scanner(new File("/home/alexisduarte/Documents/AdventOfCode/Day20/IPsRange.txt"));
    int pairsAmmount = 958;
    ArrayList<Pair> pairs = new ArrayList<Pair>(pairsAmmount);
    int index = 0;
    while(tcl.hasNext()){
      String[] values = tcl.nextLine().split("-");
      long min = Long.parseLong(values[0]);
      long max = Long.parseLong(values[1]);
      Pair pair = new Pair(min,max);
      pairs.add(pair);
    }
    Collections.sort(pairs, new PairsComparator());
    /* For Part 1 */
    System.out.println("Lowest-valued not blocked IP is: "+lowestNotBlockedIP(pairs));

    /* For Part 2 */
    System.out.println("IP's allowed: "+ipsAllowed(pairs));
  }
}
class PairsComparator implements Comparator<Pair>{
 public int compare(Pair one, Pair two){
   return (one.min < two.min? -1: one.min == two.min ? 0: 1);
 }
}
