import java.io.File;
import java.io.IOException;

/**
 * TextGenerator.java. Creates an order K Markov model of the supplied source
 * text, and then outputs M characters generated according to the model.
 *
 * @author     Your Name (you@auburn.edu)
 * @author     Dean Hendrix (dh@auburn.edu)
 * @version    2017-11-28
 *
 */
public class TextGenerator {

   /** Drives execution. */
   public static void main(String[] args) {
   
      if (args.length < 3) {
         System.out.println("Usage: java TextGenerator k length input");
         return;
      }
   
      // No error checking! You may want some, but it's not necessary.
      int K = Integer.parseInt(args[0]);
      int M = Integer.parseInt(args[1]);
      if ((K < 0) || (M < 0)) {
         System.out.println("Error: Both K and M must be non-negative.");
         return;
      }
   
      File text;
      try {
         text = new File(args[2]);
         if (!text.canRead()) {
            throw new Exception();
         }
      }
      catch (Exception e) {
         System.out.println("Error: Could not open " + args[2] + ".");
         return;
      }
      
      if (K > text.length()) {
         System.out.println("Error: Source must contain at least K characters.");
         return;
      }
   
   
      // instantiate a MarkovModel with the supplied parameters and
      // generate sample output text ...
      
      MarkovModel model = new MarkovModel(K, text);
      String kgram = model.getRandomKgram();
      String fin = kgram;
      
      for (int i = 0; fin.length() < M; i++) {
         if (model.getNextChar(kgram) == '\u0000') {
            kgram = model.getRandomKgram();
            fin += kgram;
         }
         
         char check = model.getNextChar(kgram);
         fin += check;
         // if (fin.length() == M) {
            // break;
         // }
         kgram = fin.substring(i + 1, i + K + 1);
      
         
        
      }
      System.out.print(fin);
   }
}
