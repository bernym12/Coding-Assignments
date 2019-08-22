import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;

/**
 * Defines a library of selection methods on Collections.
 *
 * @author  Bernard Moussad (brm0029@auburn.edu)
 * @version 2017-09-11
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
    * Returns the minimum value in the Collection coll as defined by the
    * Comparator comp. If either coll or comp is null, this method throws an
    * IllegalArgumentException. If coll is empty, this method throws a
    * NoSuchElementException. This method will not change coll in any way.
    *
    * @param coll    the Collection from which the minimum is selected
    * @param comp    the Comparator that defines the total order on T
    * @return        the minimum value in coll
    * @throws        IllegalArgumentException as per above
    * @throws        NoSuchElementException as per above
    */
   public static <T> T min(Collection<T> coll, Comparator<T> comp) {
      if (coll == null || comp == null) {
         throw new IllegalArgumentException();
      }
      if (coll.isEmpty()) {
         throw new NoSuchElementException();
      }
      Iterator<T>  itr = coll.iterator();
      T min = itr.next();  
      while (itr.hasNext()) {
         T val = itr.next();
         if (comp.compare(val, min) < 0) {
            min = val;
         }
      }
      return min;      
   }


   /**
    * Selects the maximum value in the Collection coll as defined by the
    * Comparator comp. If either coll or comp is null, this method throws an
    * IllegalArgumentException. If coll is empty, this method throws a
    * NoSuchElementException. This method will not change coll in any way.
    *
    * @param coll    the Collection from which the maximum is selected
    * @param comp    the Comparator that defines the total order on T
    * @return        the maximum value in coll
    * @throws        IllegalArgumentException as per above
    * @throws        NoSuchElementException as per above
    */
   public static <T> T max(Collection<T> coll, Comparator<T> comp) {
      if (coll == null || comp == null) {
         throw new IllegalArgumentException();
      }
      if (coll.isEmpty()) {
         throw new NoSuchElementException();
      }
      Iterator<T>  itr = coll.iterator();
      T max = itr.next();  
      while (itr.hasNext()) {
         T val = itr.next();
         if (comp.compare(val, max) > 0) {
            max = val;
         }
      }
      return max;       
   }


   /**
    * Selects the kth minimum value from the Collection coll as defined by the
    * Comparator comp. If either coll or comp is null, this method throws an
    * IllegalArgumentException. If coll is empty or if there is no kth minimum
    * value, this method throws a NoSuchElementException. This method will not
    * change coll in any way.
    *
    * @param coll    the Collection from which the kth minimum is selected
    * @param k       the k-selection value
    * @param comp    the Comparator that defines the total order on T
    * @return        the kth minimum value in coll
    * @throws        IllegalArgumentException as per above
    * @throws        NoSuchElementException as per above
    */
   public static <T> T kmin(Collection<T> coll, int k, Comparator<T> comp) {
      //Throws exception if coll or comp is null
      //Also if coll is empty or if k is bigger than coll size.
      if (coll == null || comp == null) {
         throw new IllegalArgumentException();
      }
      if (coll.isEmpty() || k > coll.size()) {
         throw new NoSuchElementException();
      }
      //Clones original collection
      ArrayList<T> clone = new ArrayList<T>(coll);
      //iterates through clone and removes duplicates starting from the end.
      java.util.Collections.sort(clone, comp); 
      for (int i = clone.size() - 1; i > 0; i--) {
         if (clone.get(i).equals(clone.get(i - 1))) {
            clone.remove(i);
         }
      }
     //removes nulls from the list.
      clone.trimToSize();
   //checks to see if there is a valid k in the clone list
      if (k > clone.size() || k < 1) { 
         throw new NoSuchElementException();
      }   
    //Sorts the clone based on the comparator.
   //returns the kth minimum value.        
      return clone.get(k - 1);          
   }


   /**
    * Selects the kth maximum value from the Collection coll as defined by the
    * Comparator comp. If either coll or comp is null, this method throws an
    * IllegalArgumentException. If coll is empty or if there is no kth maximum
    * value, this method throws a NoSuchElementException. This method will not
    * change coll in any way.
    *
    * @param coll    the Collection from which the kth maximum is selected
    * @param k       the k-selection value
    * @param comp    the Comparator that defines the total order on T
    * @return        the kth maximum value in coll
    * @throws        IllegalArgumentException as per above
    * @throws        NoSuchElementException as per above
    */
   public static <T> T kmax(Collection<T> coll, int k, Comparator<T> comp) {
      if (coll == null || comp == null) {
         throw new IllegalArgumentException();
      }
      if (coll.isEmpty() || k > coll.size()) {
         throw new NoSuchElementException();
      }
      ArrayList<T> clone = new ArrayList<T>(coll);
      java.util.Collections.sort(clone, comp);  
      for (int i = clone.size() - 1; i > 0; i--) {
         if (clone.get(i).equals(clone.get(i - 1))) {
            clone.remove(i);
         }
      }
     
      clone.trimToSize();
      
      if (k > clone.size() || k < 1) { 
         throw new NoSuchElementException();
      }
         
      return clone.get(clone.size() - k);
   }


   /**
    * Returns a new Collection containing all the values in the Collection coll
    * that are greater than or equal to low and less than or equal to high, as
    * defined by the Comparator comp. The returned collection must contain only
    * these values and no others. The values low and high themselves do not have
    * to be in coll. Any duplicate values that are in coll must also be in the
    * returned Collection. If no values in coll fall into the specified range or
    * if coll is empty, this method throws a NoSuchElementException. If either
    * coll or comp is null, this method throws an IllegalArgumentException. This
    * method will not change coll in any way.
    *
    * @param coll    the Collection from which the range values are selected
    * @param low     the lower bound of the range
    * @param high    the upper bound of the range
    * @param comp    the Comparator that defines the total order on T
    * @return        a Collection of values between low and high
    * @throws        IllegalArgumentException as per above
    * @throws        NoSuchElementException as per above
    */
   public static <T> Collection<T> range(Collection<T> coll, T low, T high,
                                         Comparator<T> comp) {
      if (coll == null || comp == null) {
         throw new IllegalArgumentException();
      }
                                     
     //Creates iterator for collection.
      Iterator<T> itr = coll.iterator();
      ArrayList<T> fin = new ArrayList<T>();
     //Iterates through collection
     //and stores objects in ArrayList.   
      while (itr.hasNext()) {
         T start = itr.next();
         if (comp.compare(low,start) <= 0 && comp.compare(start, high) <= 0) {
            fin.add(start);
         }
         
      }
      if (coll.isEmpty() || fin.isEmpty()) {
         throw new NoSuchElementException();
      }
      Collection<T> end = fin;                                
      return end;
   }


   /**
    * Returns the smallest value in the Collection coll that is greater than
    * or equal to key, as defined by the Comparator comp. The value of key
    * does not have to be in coll. If coll or comp is null, this method throws
    * an IllegalArgumentException. If coll is empty or if there is no
    * qualifying value, this method throws a NoSuchElementException. This
    * method will not change coll in any way.
    *
    * @param coll    the Collection from which the ceiling value is selected
    * @param key     the reference value
    * @param comp    the Comparator that defines the total order on T
    * @return        the ceiling value of key in coll
    * @throws        IllegalArgumentException as per above
    * @throws        NoSuchElementException as per above
    */
   public static <T> T ceiling(Collection<T> coll, T key, Comparator<T> comp) {
      if (coll == null || comp == null) {
         throw new IllegalArgumentException();
      }
   //Find range of numbers between the key and the max of the collection.
   //Store those values in a separate list.
      Collection<T> rnge = range(coll, key, max(coll, comp), comp);
    //return the smallest value from that range
    //or throws NoSuchElementException if rnge or coll are empty.
      if (coll.isEmpty() || rnge.isEmpty()) {
         throw new NoSuchElementException();
      }
      return min(rnge, comp);
   }


   /**
    * Returns the largest value in the Collection coll that is less than
    * or equal to key, as defined by the Comparator comp. The value of key
    * does not have to be in coll. If coll or comp is null, this method throws
    * an IllegalArgumentException. If coll is empty or if there is no
    * qualifying value, this method throws a NoSuchElementException. This
    * method will not change coll in any way.
    *
    * @param coll    the Collection from which the floor value is selected
    * @param key     the reference value
    * @param comp    the Comparator that defines the total order on T
    * @return        the floor value of key in coll
    * @throws        IllegalArgumentException as per above
    * @throws        NoSuchElementException as per above
    */
   public static <T> T floor(Collection<T> coll, T key, Comparator<T> comp) {
      if (coll == null || comp == null) {
         throw new IllegalArgumentException();
      }
     //Find range of numbers between the min of the collection and the key.
   //Store those values in a separate list.
      Collection<T> rnge = range(coll, min(coll, comp), key, comp);
    //return the largest value from that range
    //or throws NoSuchElementException if rnge or coll are empty.
      if (coll.isEmpty() || rnge.isEmpty()) {
         throw new NoSuchElementException();
      }
   
      return max(rnge, comp);
     
   
   }

}
