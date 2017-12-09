
/* 
--- Day 8: I Heard You Like Registers ---
You receive a signal directly from the CPU. Because of your recent assistance with jump instructions, it would like you to compute the result of a series of unusual register instructions.

Each instruction consists of several parts: the register to modify, whether to increase or decrease that register's value, the amount by which to increase or decrease it, and a condition. If the condition fails, skip the instruction without modifying the register. The registers all start at 0. The instructions look like this:

b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
These instructions would be processed as follows:

Because a starts at 0, it is not greater than 1, and so b is not modified.
a is increased by 1 (to 1) because b is less than 5 (it is 0).
c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
c is increased by -20 (to -10) because c is equal to 10.
After this process, the largest value in any register is 1.

You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU doesn't 
have the bandwidth to tell you what all the registers are named, and leaves that to you to determine.

What is the largest value in any register after completing the instructions in your puzzle input?

Your puzzle answer was 6012.

--- Part Two ---
To be safe, the CPU also needs to know the highest value held in any register during this process so 
that it can decide how much memory to allocate to these operations. For example, in the above 
instructions, the highest value ever held was 10 (in register c after the third instruction was 
evaluated).

Your puzzle answer was 6369.
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

class Node{
    public int weight;
    public String name;
    public ArrayList<String> childs;

    public Node(String name, int weight){
        this.name = name;
        this.weight = weight;
        childs = new ArrayList<String>();
    }
    public void addChild(String name){
        childs.add(name);
    }
}

public class RecursiveCircusTwo{

    public static int totalWeight(HashMap<String, Node> nodes, String name){
        int total = 0;
        Node n = nodes.get(name);
        total += n.weight;
        for(String s : n.childs) total += totalWeight(nodes, s);
        return total;
    }

    public static int rootWithWrongChilds(String node, HashMap<String, Node> nodes){
        boolean foundProblem = false;
        int neededWeight = 0;
        while(!foundProblem){
            foundProblem = true;
            if(nodes.get(node).childs.size() < 2) break;
            int[] weights = new int[nodes.get(node).childs.size()];
            String[] names = new String[nodes.get(node).childs.size()];
            int index = 0;
            for (String s : nodes.get(node).childs) {
                int tmpAverage = totalWeight(nodes, s);
                weights[index] = tmpAverage;
                names[index] = s;
                index++;
            }
            for(index = 0; index < weights.length; index++){
                int difCount = 0;
                int correctWeight = 0;
                for(int i = 0 ; i < weights.length; i++){
                    if(i != index){
                        if(weights[index] != weights[i]) difCount++;
                    }
                }
                if(difCount > 1){
                    if(index > 1) correctWeight = weights[index-1];
                    else correctWeight = weights[index + 1];
                    foundProblem = false;
                    node = names[index];
                    int dif = (correctWeight - weights[index]);
                    neededWeight = dif + nodes.get(node).weight;
                    break;
                }
            }
        }
        return neededWeight;
    }

    public static void main(String[] args){
        try{
            Scanner in = new Scanner(new File("input.txt").getAbsoluteFile());
            HashSet<String> top = new HashSet<String>();
            HashMap<String, Node> nodes = new HashMap<String, Node>(100);
            while(in.hasNextLine()){
                String line = in.nextLine();
                String[] parts = line.split("[^\\w]+");
                Node node = new Node(parts[0], Integer.parseInt(parts[1]));
                if(parts.length > 2){
                    for(int i = 2; i < parts.length; i++) node.addChild(parts[i]);
                }
                nodes.put(parts[0], node);
                for(String s : line.split("[^a-z]")){
                    if(top.contains(s)) top.remove(s);
                    else top.add(s);
                }
            }
            in.close();
            String root = "";
            for(String s : top) root = s;
            System.out.println("Part 1 Root = " + root);
            System.out.println("Part 2 Correct Weight = " + rootWithWrongChilds(root, nodes));
        } catch (FileNotFoundException e){
            System.err.println(e.getMessage());
        }
    }
}