/**
* LinkedStrand.java
* Provides a linked chunk list implementation of the DnaStrand interface.
* 
* @author   Bernard Moussad
* @version  2017-10-27
*
*/
public class LinkedStrand implements DnaStrand {

   /**
    * Container for storing DNA information. A given DNA strand is
    * represented by a chain of nodes.
    *
    * D O   N O T   M A K E   A N Y   C H A N G E S   T O
    *
    * T H E   N O D E   C L A S S 
    *
    */
   class Node {
      String dnaInfo;
      Node next;
   
      public Node() {
         dnaInfo = "";
         next = null;
      }
   
      public Node(String s, Node n) {
         dnaInfo = s;
         next = n;
      }
   }
   

   /** An empty strand. */
   public static final LinkedStrand EMPTY_STRAND = new LinkedStrand();

   /** The first and last node in this LinkedStrand. */
   // D O   N O T   C H A N G E   T H E S E   F I E L D S 
   Node front;
   Node rear;


   /** The number of nucleotides in this strand. */
   long size;

   /**
    * Create a strand representing an empty DNA strand, length of zero.
    *
    * D O   N O T   C H A N G E   T H I S   C O N S T R U C T O R
    */
   public LinkedStrand() {
      front = null;
      rear = null;
      size = 0;
   }


   /**
    * Create a strand representing s. No error checking is done to see if s represents
    * valid genomic/DNA data.
    *
    * @param s is the source of cgat data for this strand
    */
   public LinkedStrand(String s) {
      // YOU MUST COMPLETE THIS METHOD
      if (s.length() == 0) {
         front = null;
         rear = null;
         size = 0;
      }
      else {
         front = new Node(s, null);
         rear = front;
         size = s.length(); 
      }
   }


   /**
    * Appends the parameter to this strand changing this strand to represent
    * the addition of new characters/base-pairs, e.g., changing this strand's
    * size.
    * 
    * If possible implementations should take advantage of optimizations
    * possible if the parameter is of the same type as the strand to which data
    * is appended.
    * 
    * @param dna is the strand being appended
    * @return this strand after the data has been added
    */
   @Override
   public DnaStrand append(DnaStrand dna) {
      // YOU MUST COMPLETE THIS METHOD
      if (dna instanceof LinkedStrand) {
         LinkedStrand ss = (LinkedStrand) dna;
         if (dna.size() == 0) {
            return this;
         }            
         else if (size == 0) {
            front = ss.front;
            rear = front;
            size += dna.size();
            return this;
         }
      
         rear.next = ss.front;
         rear = ss.rear;
         size += dna.size();
         return this;
      }  
      else {
         
         return append(dna.toString());
      }
    
   }


   /**
    * Similar to append with a DnaStrand parameter in
    * functionality, but fewer optimizations are possible. Typically this
    * method will be called by the append method with an DNAStrand
    * parameter if the DnaStrand passed to that other append method isn't the same 
    * class as the strand being appended to.
    * 
    * @param dna is the string appended to this strand
    * @return this strand after the data has been added
    */
   @Override
   public DnaStrand append(String dna) {
      // YOU MUST COMPLETE THIS METHOD
      LinkedStrand ss = new LinkedStrand(dna);
      if (dna.length() == 0) {
         return this;
      }
      
      else if (size == 0) {
         front = ss.front;
         rear = front;
         size += dna.length();
         return this;
      }
      rear.next = ss.front;
      rear = ss.rear;
      size +=  dna.length();
      return this;
   }


   /**
    * Cut this strand at every occurrence of enzyme, replacing
    * every occurrence of enzyme with splice.
    *
    * @param enzyme is the pattern/strand searched for and replaced
    * @param splice is the pattern/strand replacing each occurrence of enzyme
    * @return the new strand leaving the original strand unchanged.
    */
   @Override
   public DnaStrand cutAndSplice(String enzyme, String splice) {
      // YOU MUST COMPLETE THIS METHOD
      if (front.next != null) {
         throw new IllegalStateException();
      } 
      String strand = front.dnaInfo;
      DnaStrand fin = new LinkedStrand();
      int i = 0;
      if (strand.indexOf(enzyme) == -1) {
         return EMPTY_STRAND;
      }
      while (i < strand.length()) {
         int loc = strand.indexOf(enzyme, i);
         if (loc == -1) {
            break;
         }
        
         fin.append(strand.substring(i, loc));    
         fin.append(splice);
         i = loc + enzyme.length();
      } 
      
      fin.append(strand.substring(i));
            
      return fin;
    
   }


   /**
    * Simulate a restriction enzyme cut by finding the first occurrence of
    * enzyme in this strand and replacing this strand with what comes before
    * the enzyme while returning a new strand representing what comes after the
    * enzyme. If the enzyme isn't found, this strand is unaffected and an empty
    * strand with size equal to zero is returned.
    * 
    * @param enzyme is the string being searched for
    * @return the part of the strand that comes after the enzyme
    */
   @Override
   public DnaStrand cutWith(String enzyme) {
      // YOU MUST COMPLETE THIS METHOD
      if (front.next != null) {
         throw new IllegalStateException();
      }
      DnaStrand ds = new LinkedStrand();
      
      String strand = front.dnaInfo;
      int loc = strand.indexOf(enzyme);       
      if (loc == -1) {
         DnaStrand empty = new LinkedStrand();
         return empty;
      }
      if (strand.equals(enzyme)) {
         initializeFrom(front.dnaInfo.substring(0, 0));  
         return ds;     
      }
      DnaStrand ret = new LinkedStrand(strand.substring(loc + enzyme.length()));
      initializeFrom(strand.substring(0, loc));
      return ret;
   }


   /**
    * Initialize by copying DNA data from the string into this strand,
    * replacing any data that was stored. The parameter should contain only
    * valid DNA characters, no error checking is done by the this method.
    * 
    * @param source is the string used to initialize this strand
    */
   @Override
   public void initializeFrom(String source) {
      // YOU MUST COMPLETE THIS METHOD
      if (source == null) {
         front = new Node();
         front.dnaInfo = null;
         rear = front;
         size = 0;
      }
      
      else if (source.length() == 0) {
         front = null;
         rear = front;
         size = 0;
      }
      else {
         Node sou = new Node(source, null);
         front = sou;
         rear = front;
         size = source.length();
      }
   }


   /**
    * Returns the number of elements/base-pairs/nucleotides in this strand.
    * @return the number of base-pairs in this strand
    */
   @Override
   public long size() {
      // YOU MUST COMPLETE THIS METHOD
      return size;
   }


   /**
    * Returns a string representation of this LinkedStrand.
    */
   @Override
   public String toString() {
      // YOU MUST COMPLETE THIS METHOD
      Node p = this.front;
      String hold = "";
      while (p != null) {
         hold += p.dnaInfo;
         p = p.next;
      }
      return hold;
   }


}

