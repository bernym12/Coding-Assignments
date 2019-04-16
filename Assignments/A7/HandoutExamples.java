/**
 * HandoutExamples.java
 * Generates examples from the assignment handout.
 *
 * @author Dean Hendrix (dh@auburn.edu)
 * @version 2017-11-28
 *
 */
public class HandoutExamples {

   /** Drives execution. */
   public static void main(String[] args) {
      String sourceText = "agggcagcgggcg";
      int k = 2;
      int M = 10;
      MarkovModel model1 = new MarkovModel(k, sourceText);
      System.out.println("k = " + k + ", source text: " + sourceText);
      System.out.println("The first kgram: " + model1.getFirstKgram());
      System.out.println("A random kgram: " + model1.getRandomKgram());
      System.out.println("All kgrams: " + model1.getAllKgrams());
      System.out.println("The Markov model: ");
      System.out.println(model1);
            
   }
}


/*

RUNTIME OUTPUT:

k = 2, source text: agggcagcgggcg
The first kgram: ag
A random kgram: cg
All kgrams: [gg, cg, ag, gc, ca]
The Markov model:
{gg=gcgc, cg=g, ag=gc, gc=agg, ca=g}

 */

