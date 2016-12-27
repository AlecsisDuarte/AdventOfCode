public class Node{
  private int number;
  private Node next;

  public Node(){
    number = 0;
    next = null;
  }
  public Node(Node next){
    this.next = next;
    number = 0;
  }
  public Node(int number, Node next){
    this.number = number;
    this.next = next;
  }
  public int getNumber(){
    return number;
  }
  public Node getNext(){
    return next;
  }
  public void setNumber(int number){
    this.number = number;
  }
  public void setNext(Node next){
    this.next = next;
  }
}
