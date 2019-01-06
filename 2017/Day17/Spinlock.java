
/* 
 * --- Day 17: Spinlock ---
Suddenly, whirling in the distance, you notice what looks like a massive, pixelated hurricane: a deadly spinlock. This spinlock isn't just 
consuming computing power, but memory, too; vast, digital mountains are being ripped from the ground and consumed by the vortex.

If you don't move quickly, fixing that printer will be the least of your problems.

This spinlock's algorithm is simple but efficient, quickly consuming everything in its path. It starts with a circular buffer containing 
only the value 0, which it marks as the current position. It then steps forward through the circular buffer some number of steps (your 
puzzle input) before inserting the first new value, 1, after the value it stopped on. The inserted value becomes the current position. 
Then, it steps forward from there the same number of steps, and wherever it stops, inserts after it the second new value, 2, and uses that 
as the new current position again.

It repeats this process of stepping forward, inserting a new value, and using the location of the inserted value as the new current position 
a total of 2017 times, inserting 2017 as its final operation, and ending with a total of 2018 values (including 0) in the circular buffer.

For example, if the spinlock were to step 3 times per insert, the circular buffer would begin to evolve like this (using parentheses to mark 
the current position after each iteration of the algorithm):

(0), the initial state before any insertions.
0 (1): the spinlock steps forward three times (0, 0, 0), and then inserts the first value, 1, after it. 1 becomes the current position.
0 (2) 1: the spinlock steps forward three times (0, 1, 0), and then inserts the second value, 2, after it. 2 becomes the current position.
0  2 (3) 1: the spinlock steps forward three times (1, 0, 2), and then inserts the third value, 3, after it. 3 becomes the current position.
And so on:

0  2 (4) 3  1
0 (5) 2  4  3  1
0  5  2  4  3 (6) 1
0  5 (7) 2  4  3  6  1
0  5  7  2  4  3 (8) 6  1
0 (9) 5  7  2  4  3  8  6  1
Eventually, after 2017 insertions, the section of the circular buffer near the last insertion looks like this:

1512  1134  151 (2017) 638  1513  851
Perhaps, if you can identify the value that will ultimately be after the last value written (2017), you can short-circuit the spinlock. In this 
example, that would be 638.

What is the value after 2017 in your completed circular buffer?

Your puzzle answer was 180.

--- Part Two ---
The spinlock does not short-circuit. Instead, it gets more angry. At least, you assume that's what happened; it's spinning significantly faster 
than it was a moment ago.

You have good news and bad news.

The good news is that you have improved calculations for how to stop the spinlock. They indicate that you actually need to identify the value 
after 0 in the current state of the circular buffer.

The bad news is that while you were determining this, the spinlock has just finished inserting its fifty millionth value (50000000).

What is the value after 0 the moment 50000000 is inserted?

Your puzzle answer was 13326437.
*/

import java.util.Scanner;

class Node{
    public int value;
    public Node next;
    
    public Node(int value, Node next){
        this.value = value;
        this.next = next;
    }
    
    public Node(int value){
        this.value = value;
        this.next = null;
    }
}

class LinkedList{
    Node root;
    Node realRoot;
    int length;

    public LinkedList(){
        root = new Node(0);
        realRoot = root;
        root.next = root;
        length = 1;
    }

    public void addNode(int steps,int value){
        while ( steps >= length ) {
            steps -= length;
        }
        while ( steps-- > 0) {
            root = root.next;
        }
        length++;
        Node newNode = new Node(value, root.next);
        root.next = newNode;
        root = root.next;
    }

    public int getPartOneResult(){
        Node tmp = root;
        while (tmp.value != 2017) {
            tmp = tmp.next;
        }
        return tmp.next.value;
    }

    public int getPartTwoResult(int times){
        if( times < 2) { 
            return times;
        }
        times /= 3;
        return 2 * times;
    }

    public int getValueAfterRoot(){
        return realRoot.next.value;
    }

    public String toString(){
        String line = "";
        Node tmp = realRoot;
        for(int i = 0; i < length; i++){
            line += tmp.value + " ";
            tmp = tmp.next;
        }
        return line;
    }
}

public class Spinlock{

    public static int simulateAdding(int steps, int maxValue){
        int result = 0;
        int length = 1;
        int value = 0;
        int index = 0;
        while ( value <= maxValue ) {
            index += steps;
            while (index >= length ) {
                index -= length;
            }
            ++length;
            ++value;
            if (index == 0){
                result = value;
            }
            ++index;
        }
        return result;
    }

    public static void main(String[] args){
        Scanner in = new Scanner(System.in);
        int steps = in.nextInt();
        in.close();
        LinkedList list = new LinkedList();
        int value = 1;

        while (value < 2018){
            list.addNode(steps, value++);
        }
        System.out.println("Part 1 - Value after 2017: " + list.getPartOneResult());
        System.out.println("Part 2 - Value after 0: " + simulateAdding(steps, 50000000));
    }
}