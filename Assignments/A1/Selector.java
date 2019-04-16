import java.util.Arrays;


/**
* Defines a library of selection methods
* on arrays of ints.
*
* @author   Bernard Moussad (brm0029@auburn.edu)
* @version  2017-08-29
*
*/
public final class Selector {

   /**
    * Can't instantiate this class.
    *
    * D O   N O T   C H A N G E   T H I S   C O N S T R U C T O R
    *
    */
   private Selector() { }


   /**
    * Selects the minimum value from the array a. This method
    * throws IllegalArgumentException if a is null or has zero
    * length. The array a is not changed by this method.
    */
   public static int min(int[] a)  {
      if (a == null || a.length == 0) {
         throw new IllegalArgumentException();
      }
      int min = a[0];
      for (int i = 0; i < a.length; i++) {
         if (a[i] < min) {
            min = a[i];
         }
      }
      return min;
          
   }


   /**
    * Selects the maximum value from the array a. This method
    * throws IllegalArgumentException if a is null or has zero
    * length. The array a is not changed by this method.
    */
   public static int max(int[] a) {
      if (a == null || a.length == 0) {
         throw new IllegalArgumentException();
      }
      int max = a[0];
      for (int i = 0; i < a.length; i++) {
         if (a[i] > max) {
            max = a[i];
         }
        
      
      }
      return max;
   }


   /**
    * Selects the kth minimum value from the array a. This method
    * throws IllegalArgumentException if a is null, has zero length,
    * or if there is no kth minimum value. Note that there is no kth
    * minimum value if k < 1, k > a.length, or if k is larger than
    * the number of distinct values in the array. The array a is not
    * changed by this method.
    */
    
   public static int kmin(int[] a, int k) {
      if (a == null || a.length == 0 || k < 1 || k > a.length) {
         throw new IllegalArgumentException();
      }
   //copy and sort array
      int[] copy = a.clone();
      Arrays.sort(copy);
   //find duplicates and replace with 0s
      for  (int i = 1; i < copy.length; i++) {
         if (copy[i - 1] == copy[i]) {
            copy[i - 1] = 0;
         }
      }
   //count non-zero numbers   
      int count = 0;
      for (int i = 0; i < copy.length; i++) {
         if (copy[i] != 0) {
            count++;
         }
      }
   //make new aray the size of count   
      int[] fin = new int[count];
      count = 0;
   //add non-zero numbers to new array
      for (int i = 0; i < copy.length; i++) {
         if (copy[i] != 0) {
            fin[count] = copy[i];
            count++;
         }  
      }
      if (k > fin.length) {
         throw new IllegalArgumentException();
      }
      int kmin = fin[k - 1];
      return kmin;
   }


   /**
    * Selects the kth maximum value from the array a. This method
    * throws IllegalArgumentException if a is null, has zero length,
    * or if there is no kth maximum value. Note that there is no kth
    * maximum value if k < 1, k > a.length, or if k is larger than
    * the number of distinct values in the array. The array a is not
    * changed by this method.
    */
   public static int kmax(int[] a, int k) {
      if (a == null || a.length == 0 || k < 1 || k > a.length) {
         throw new IllegalArgumentException();
      }
   //copy the array and sort it.
      int[] copy = a.clone();
      Arrays.sort(copy);
    //find the duplicates and make them 0.
      for  (int i = 1; i < copy.length; i++) {
         if (copy[i - 1] == copy[i]) {
            copy[i - 1] = 0;
         }
      }
    
   //count the numbers that aren't 0.   
      int count = 0;
      for (int i = 0; i < copy.length; i++) {
         if (copy[i] != 0) {
            count++;
         }
      }
   //add the numbers that aren't zero to a new array
      int[] fin = new int[count];
      count = 0;
      for (int i = 0; i < copy.length; i++) {
         if (copy[i] != 0) {
            fin[count] = copy[i];
            count++;
         }  
      }
      if (k > fin.length) {
         throw new IllegalArgumentException();
      }   
      int kmax = fin[fin.length - k];
      return kmax;
   }


   /**
    * Returns an array containing all the values in a in the
    * range [low..high]; that is, all the values that are greater
    * than or equal to low and less than or equal to high,
    * including duplicate values. The length of the returned array
    * is the same as the number of values in the range [low..high].
    * If there are no qualifying values, this method returns a
    * zero-length array. Note that low and high do not have
    * to be actual values in a. This method throws an
    * IllegalArgumentException if a is null or has zero length.
    * The array a is not changed by this method.
    */
   public static int[] range(int[] a, int low, int high) {
      
      if (a == null || a.length == 0) {
         throw new IllegalArgumentException();
      }
   
      int count = 0;
      int c = 0;
      for (int i = 0; i < a.length; i++) {
         
         if (a[i] >= low && a[i] <= high) {  
            count++;
         }
             
      }
      
      int[] range = new int[count];    
      for (int i = 0; i < a.length; i++) {
         
         if ( a[i] >= low && a[i] <= high) {  
            range[c] = a[i];
            c++;  
         }      
      }
      return range;
   }


   /**
    * Returns the smallest value in a that is greater than or equal to
    * the given key. This method throws an IllegalArgumentException if
    * a is null or has zero length, or if there is no qualifying
    * value. Note that key does not have to be an actual value in a.
    * The array a is not changed by this method.
    */
   public static int ceiling(int[] a, int key) {
      if (a == null || a.length == 0 || key > max(a)) {
         throw new IllegalArgumentException();
      }
      int[] newA = range(a, key, max(a));
      int ceiling = min(newA);
               
      return ceiling;
   }


   /**
    * Returns the largest value in a that is less than or equal to
    * the given key. This method throws an IllegalArgumentException if
    * a is null or has zero length, or if there is no qualifying
    * value. Note that key does not have to be an actual value in a.
    * The array a is not changed by this method.
    */
   public static int floor(int[] a, int key) {
      if (a == null || a.length == 0 || key < min(a)) {
         throw new IllegalArgumentException();
      }
      int[] newA = range(a, min(a), key);
      int floor = max(newA);
      return floor;
   }
}
