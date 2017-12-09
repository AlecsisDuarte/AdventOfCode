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

    public String[] getChilds(){
        return childs.toArray(new String[childs.size()]);
    }
}

public class RecursiveCircus{

    public static int totalWeight(HashMap<String, Node> nodes, String name){
        int total = 0;
        Node n = nodes.get(name);
        total += n.weight;
        for(String s : n.childs) total += totalWeight(nodes, s);
        return total;
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
            Node rootNode = nodes.get(root);
            String[] rootChilds = rootNode.getChilds();
            HashMap<Integer, String> wrongProgram = new HashMap<Integer, String>(2);
            HashMap<Integer, Integer> difWeights = new HashMap<Integer, Integer>(2);
            for(String s : rootChilds){
                int tmpAverage = totalWeight(nodes, s);
                if(difWeights.containsKey(tmpAverage)){
                    wrongProgram.remove(tmpAverage);
                    difWeights.put(tmpAverage, difWeights.get(tmpAverage)+1);
                }else {
                    wrongProgram.put(tmpAverage, s);
                    difWeights.put(tmpAverage, 1);
                }
            }
            int correctWeight = 0, wrongWeight = 0;
            for(Map.Entry<Integer, Integer> e : difWeights.entrySet()){
                if((Integer)e.getValue() > 1 ) correctWeight = (Integer)e.getKey();
                else wrongWeight = (Integer)e.getKey();
            }
            int dif = 0;
            if(correctWeight > wrongWeight){
                dif = wrongWeight - correctWeight;
            } else {
                dif = correctWeight - wrongWeight;
            }
            String wrongName = wrongProgram.get(wrongWeight);
            System.out.println("Part 2 Correct Weight = "+ (dif + nodes.get(wrongName).weight));
        } catch (FileNotFoundException e){
            System.err.println(e.getMessage());
        }
    }
}