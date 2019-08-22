import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import java.util.Arrays;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;
import java.util.TreeSet;
import java.util.HashMap; //*

import java.util.stream.Collectors;

/**
 * Provides an implementation of the WordLadderGame interface. The lexicon
 * is stored as a TreeSet of Strings.
 *
 * @author Bernard Moussad (brm0029@auburn.edu)
 * @version 2017-11-17
 */
public class Doublets implements WordLadderGame {

   // The word list used to validate words.
   // Must be instantiated and populated in the constructor.
   private TreeSet<String> lexicon;
   private List<String> EMPTY_LADDER = new ArrayList<>();
   /**
    * Instantiates a new instance of Doublets with the lexicon populated with
    * the strings in the provided InputStream. The InputStream can be formatted
    * in different ways as long as the first string on each line is a word to be
    * stored in the lexicon.
    */
   public Doublets(InputStream in) {
      try {
         lexicon = new TreeSet<String>();
         Scanner s =
            new Scanner(new BufferedReader(new InputStreamReader(in)));
        
         while (s.hasNext()) {
            String str = s.next();
            /////////////////////////////////////////////////////////////
            // INSERT CODE HERE TO APPROPRIATELY STORE str IN lexicon. //
            /////////////////////////////////////////////////////////////
            lexicon.add(str.toLowerCase());
         
            s.nextLine();
         }
         in.close();
      }
      catch (java.io.IOException e) {
         System.err.println("Error reading from InputStream.");
         System.exit(1);
      }
   }


   //////////////////////////////////////////////////////////////
   // ADD IMPLEMENTATIONS FOR ALL WordLadderGame METHODS HERE  //
   //////////////////////////////////////////////////////////////
   //need to see how many letters changed from one word to another. Could check if charAt each position is different
   public int getHammingDistance(String str1, String str2) {
      if (str1.length() != str2.length()) {
         return -1;
      }
              
      int ham = 0;
      for (int i = 0; i < str1.length(); i++) {
         if (str1.toLowerCase().charAt(i) != str2.toLowerCase().charAt(i)) {
            ham++;
         }
      }
      return ham;
   }
  /**
  *Makes a word ladder using start and end.
  *Uses depth-first backtracking to find word ladder.
  *Probably first check to see if both are actual words otherwise it isn't a word ladder.
  *Start from the end and work our way up I think.
  *Change first letter of start to first of end. Check if it's a word. Move on and do the same process
  *isValid means it is a word
  * add start to end of a queue. get its neighbors. check to see if any of those neighbors are the end.
  * if not then just add the first one to the bottom of the queue and get its neighbors. 
  */ 
   public List<String> getLadder(String start, String end) {
     
      List<String> result = new ArrayList<String>();
        
      if (start.equals(end)) {
         result.add(start);
         return result;
      }
      else if (start.length() != end.length()) {
         return EMPTY_LADDER;
      }
      else if (!isWord(start) || !isWord(end)) {
         return EMPTY_LADDER;
      }
      TreeSet<String> one = new TreeSet<>();
      Deque<String> stack = new ArrayDeque<>();
       
      stack.addLast(start);
      one.add(start);
      while (!stack.isEmpty()) {
       
         String current = stack.peekLast();
         if (current.equals(end)) {
            break;
         }
         List<String> neighbors1 = getNeighbors(current);
         List<String> neighbors = new ArrayList<>();
          
         for (String word : neighbors1) {
            if (!one.contains(word)) {
               neighbors.add(word);
            }
         }
         if (!neighbors.isEmpty()) {
            stack.addLast(neighbors.get(0));
            one.add(neighbors.get(0));
         }
         else {
            stack.removeLast();
         }
      }
      result.addAll(stack);
      return result;      
   }
  /**
  *Use breadth first search here
  *Find "shortest path from start to end.
  *
  *
  */
   public List<String> getMinLadder(String start, String end) {
      List<String> ladder = new ArrayList<String>();
      if (start.equals(end)) {
         ladder.add(start);
         return ladder;
      }
      else if (start.length() != end.length()) {
         return EMPTY_LADDER;
      }
      else if (!isWord(start) || !isWord(end)) {
         return EMPTY_LADDER;
      }
      Deque<Node> q = new ArrayDeque<>();
      TreeSet<String> one = new TreeSet<>();
    
      one.add(start);
      q.addLast(new Node(start, null));
      while (!q.isEmpty()) {
       
         Node n = q.removeFirst();
         String position = n.position;
          
         for (String neighbor1 : getNeighbors(position)) {
            if (!one.contains(neighbor1)) {
               one.add(neighbor1);
               q.addLast(new Node(neighbor1, n));
            }
            if (neighbor1.equals(end)) {
             
               Node m = q.removeLast();
               
               while (m != null) {
                  ladder.add(0, m.position);
                  m = m.predecessor;
               }
               return ladder;
            }
         }
      }      
      return EMPTY_LADDER;     
   }
   private class Node {
      String position;
      Node predecessor;
   
      public Node(String p, Node pred) {
         position = p;
         predecessor = pred;
      }
   }

  /**
  * Change each letter of the word, check if it's a word, then add it to a list.
  */
   public List<String> getNeighbors(String word) {
      if (!isWord(word)) {
         return null;
      }
      
      List<String> store = new ArrayList<String>();
      for (int i = 0; i < word.length(); i++) {
         char[] boi = word.toCharArray();
         for (char j = 'a'; j <= 'z'; j++) {
            boi[i] = j;
            String hmm = new String(boi);
            if (isWord(hmm) && getHammingDistance(word, hmm) == 1) {
               store.add(hmm);
            }
            
         }
      }      
      return store;
   }
  
   public int getWordCount() {
      return lexicon.size();
   }
  
   public boolean isWord(String str) {
      return lexicon.contains(str);
   }
  
   public boolean isWordLadder(List<String> sequence) {
      if (sequence.isEmpty()) {
         return false;
      }
      for (int i = 1; i < sequence.size(); i++) {
         if (getHammingDistance(sequence.get(i - 1), sequence.get(i)) != 1) {
            return false;
         }
                 
      }
      for (int i = 0; i < sequence.size(); i++) {
         if (!isWord(sequence.get(i))) {
            return false;
         }
      }
      return true;
   }
  
  
  


}

