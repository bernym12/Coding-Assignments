import java.io.File;
import java.util.HashMap;
import java.io.IOException;
import java.util.Random;
import java.util.Scanner;
import java.util.Set;

/**
 * MarkovModel.java Creates an order K Markov model of the supplied source
 * text. The value of K determines the size of the "kgrams" used to generate
 * the model. A kgram is a sequence of k consecutive characters in the source
 * text.
 *
 * @author     Your Name (you@auburn.edu)
 * @author     Dean Hendrix (dh@auburn.edu)
 * @version    2017-11-28
 *
 */
public class MarkovModel {

   // Map of <kgram, chars following> pairs that stores the Markov model.
   private HashMap<String, String> model;
      
   // add other fields as you need them ...


   /**
    * Reads the contents of the file sourceText into a string, then calls
    * buildModel to construct the order K model.
    *
    * DO NOT CHANGE THIS CONSTRUCTOR.
    *
    */
   public MarkovModel(int K, File sourceText) {
      model = new HashMap<>();
      try {
         String text = new Scanner(sourceText).useDelimiter("\\Z").next();
         buildModel(K, text);
      }
      catch (IOException e) {
         System.out.println("Error loading source text: " + e);
      }
   }


   /**
    * Calls buildModel to construct the order K model of the string sourceText.
    *
    * DO NOT CHANGE THIS CONSTRUCTOR.
    *
    */
   public MarkovModel(int K, String sourceText) {
      model = new HashMap<>();
      buildModel(K, sourceText);
   }


   /**
    * Builds an order K Markov model of the string sourceText.
    */
   private String first;
   private void buildModel(int K, String sourceText) {
      first = sourceText.substring(0,K);
      if (first.length() == sourceText.length()) {
         model.put(first, null);
      }
      for (int i = 0; i < (sourceText.length() - K); i++) {
         String kGram = sourceText.substring(i, i + K);
         String next = sourceText.substring(i + K, i + K + 1);
         if(!model.containsKey(kGram)) {
            model.put(kGram, next);  
         }
         else {
            String add = model.get(kGram).concat(next);
            model.put(kGram, add);
         }
                 
      }
   }
      
   /** Returns the first kgram found in the source text. */
   public String getFirstKgram() {
                
      return first;
   }


   /** Returns a kgram chosen at random from the source text. */
   public String getRandomKgram() {
      Set<String> hold = getAllKgrams();
      String[] fin = hold.toArray(new String[0]);
      Random gen = new Random();
      int rand = gen.nextInt(fin.length);
      return fin[rand];
   }


   /**
    * Returns the set of kgrams in the source text.
    *
    * DO NOT CHANGE THIS METHOD.
    *
    */
   public Set<String> getAllKgrams() {
      return model.keySet();
   }


   /**
    * Returns a single character that follows the given kgram in the source
    * text. This method selects the character according to the probability
    * distribution of all characters that follow the given kgram in the source
    * text.
    */
   public char getNextChar(String kgram) {
      char empty = '\u0000';
      if (!model.containsKey(kgram)) {
         return empty;
      }
     
      String vals = model.get(kgram);
      
      char[] prob = vals.toCharArray();
      Random gen = new Random();
      
      int rand = gen.nextInt(prob.length);
      if (prob.length == 0) {
         return empty;
      }
   
      return prob[rand];
   }   

   /**
    * Returns a string representation of the model.
    * This is not part of the provided shell for the assignment.
    *
    * DO NOT CHANGE THIS METHOD.
    *
    */
   @Override
    public String toString() {
      return model.toString();
   }

}
