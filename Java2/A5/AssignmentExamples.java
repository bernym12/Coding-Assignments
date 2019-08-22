/**
 * Generates the DnaStrand examples in the assignment handout.
 *
 * @author   Dean Hendrix (dh@auburn.edu)
 * @version  2017-10-17
 *
 */
public class AssignmentExamples {

   /** Drives execution. */
   public static void main(String[] args) {
   
      System.out.println();
      System.out.println("DnaStrand method cutWith()");
      System.out.println("==========================");
      DnaStrand dna = new LinkedStrand("AGTCGAATTCAAGTCGAATTCAGTCA");
      String enzyme = "GAATTC";
      System.out.println("Before: " + dna);
      DnaStrand ret = dna.cutWith(enzyme);
      System.out.println("After:  " + dna);
      System.out.println("Return: " + ret);
      
      System.out.println();   
      System.out.println("DnaStrand method cutAndSplice()");
      System.out.println("===============================");
      dna = new LinkedStrand("AGTCGAATTCAAGTCGAATTCAGTCA");
      enzyme = "GAATTC";
      String splice = "XXYY";
      System.out.println("Before: " + dna);
      ret = dna.cutAndSplice(enzyme, splice);
      System.out.println("After:  " + dna);
      System.out.println("Return: " + ret);
      DnaStrand boi = new LinkedStrand("gaattc");
      System.out.println("Before" + boi.cutWith("gaattc")); 
      System.out.print("after" + boi);
   }
}
