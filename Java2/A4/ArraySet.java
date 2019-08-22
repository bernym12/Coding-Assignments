import java.util.Iterator;
import java.util.NoSuchElementException;


/**
 * ArraySet.java.
 *
 * Provides an implementation of the Set interface using an
 * array as the underlying data structure. Values in the array
 * are kept in ascending natural order and, where possible,
 * methods take advantage of this. Many of the methods with parameters
 * of type ArraySet are specifically designed to take advantage
 * of the ordered array implementation.
 *
 * @author Bernard Moussad (brm0029@auburn.edu)
 * @version 2017-10-07
 *
 */
public class ArraySet<T extends Comparable<? super T>> implements Set<T> {

   ////////////////////////////////////////////
   // DO NOT CHANGE THE FOLLOWING TWO FIELDS //
   ////////////////////////////////////////////
   T[] elements;
   int size;

   ////////////////////////////////////
   // DO NOT CHANGE THIS CONSTRUCTOR //
   ////////////////////////////////////
   /**
    * Instantiates an empty set.
    */
   @SuppressWarnings("unchecked")
   public ArraySet() {
      elements = (T[]) new Comparable[1];
      size = 0;
   }
   
         
   @SuppressWarnings("unchecked")  
      private ArraySet(T[] a, int start, int end) {
      elements = a;
      start = 0;
      size = end;      
   }
   

    
   ///////////////////////////////////
   // DO NOT CHANGE THE SIZE METHOD //
   ///////////////////////////////////
   /**
    * Returns the current size of this collection.
    *
    * @return  the number of elements in this collection.
    */
   @Override
   public int size() {
      return size;
   }

   //////////////////////////////////////
   // DO NOT CHANGE THE ISEMPTY METHOD //
   //////////////////////////////////////
   /**
    * Tests to see if this collection is empty.
    *
    * @return  true if this collection contains no elements,
    *               false otherwise.
    */
   @Override
   public boolean isEmpty() {
      return size == 0;
   }

   ///////////////////////////////////////
   // DO NOT CHANGE THE TOSTRING METHOD //
   ///////////////////////////////////////
   /**
    * Return a string representation of this ArraySet.
    *
    * @return a string representation of this ArraySet
    */
   @Override
   public String toString() {
      if (isEmpty()) {
         return "[]";
      }
      StringBuilder result = new StringBuilder();
      result.append("[");
      for (T element : this) {
         result.append(element + ", ");
      }
      result.delete(result.length() - 2, result.length());
      result.append("]");
      return result.toString();
   }

   /**
    * Ensures the collection contains the specified element. Elements are
    * maintained in ascending natural order at all times. Neither duplicate nor
    * null values are allowed.
    *
    * @param  element  The element whose presence is to be ensured.
    * @return true if collection is changed, false otherwise.
    */
   @SuppressWarnings("unchecked")
   private void resize(int capacity) { 
      T[] a = (T[]) new Comparable[capacity]; 
      System.arraycopy(elements, 0, a, 0, size);
   
      elements = a;
   }
  
   private int search(T element) {
      int low = 0;
      int high = size - 1;       
      while (high >= low) {
         int middle = (low + high) / 2;
         if (elements[middle].compareTo(element) == 0) {
            return middle;
         }
         if (elements[middle].compareTo(element) < 0) {
            low = middle + 1;
         }
         if (elements[middle].compareTo(element) > 0) {
            high = middle - 1;
         }
      }
      return -1;      
   }
   
   private void sort(T elem) {
      int j = size;
      for (int i = size; i > -1; i--) {
         if (elements[i] == null) {
            continue;
         }
         if (elements[i].compareTo(elem) > 0) {
          
            elements[i + 1] = elements[i];
            j--;
         }
      }   
      elements[j] = elem;  
   }
  
  
   @Override
   public boolean add(T element) {
      if (element == null) {
         return false;
      }
      int find = search(element);
      if (find != -1) {
         return false;
      }
      
      if (size == elements.length) {
         resize(elements.length * 2);
      } 
   
      if (find == -1) {
      
         sort(element);
         size++;
         return true;
      }
            
               
      return false;
         
   }

   /**
    * Ensures the collection does not contain the specified element.
    * If the specified element is present, this method removes it
    * from the collection. Elements are maintained in ascending natural
    * order at all times.
    *
    * @param   element  The element to be removed.
    * @return  true if collection is changed, false otherwise.
    */
   @Override
   public boolean remove(T element) {
      
      int j = search(element);
      if (j != -1) {
       
         for (int i = j; i < size - 1; i++) {
            elements[i] = elements[i + 1];
         }
         elements[size - 1] = null;  
         size--;
         if ((size > 0) && size < (elements.length / 4)) {
            resize(elements.length / 2);
         }
         return true;
      }
                
      return false;
   }

   /**
    * Searches for specified element in this collection.
    *
    * @param   element  The element whose presence in this collection
    *                   is to be tested.
    * @return  true if this collection contains the specified element,
    *               false otherwise.
    */
   @Override
   public boolean contains(T element) {
      return (search(element) > -1);
   }

   /**
    * Tests for equality between this set and the parameter set.
    * Returns true if this set contains exactly the same elements
    * as the parameter set, regardless of order.
    *
    * @return  true if this set contains exactly the same elements
    *               as the parameter set, false otherwise
    */
   @Override
   public boolean equals(Set<T> s) {
      if (s.size() != size) {
         return false;
      }
      for (int i = 0; i < size; i++) {
         if (!s.contains(elements[i])) {
            return false; 
         }
      }
   
      return true;
   }

   /**
    * Tests for equality between this set and the parameter set.
    * Returns true if this set contains exactly the same elements
    * as the parameter set, regardless of order.
    *
    * @return  true if this set contains exactly the same elements
    *               as the parameter set, false otherwise
    */
   public boolean equals(ArraySet<T> s) {
      if (s.size() != size) {
         return false;
      }
      Iterator<T> itr = s.iterator();
      Iterator<T> itr2 = this.iterator();
      while (itr.hasNext()) {
         if (itr.next().compareTo(itr2.next()) != 0)  {
            return false;
         }
      }
      
      return true;
   }

   /**
    * Returns a set that is the union of this set and the parameter set.
    *
    * @return  a set that contains all the elements of this set and
    *            the parameter set
    */
   @Override
   public Set<T> union(Set<T> s) {
      Set<T> u = new ArraySet<T>();
      for (T elem : s) {
         u.add(elem);
      }
      for (T elem : this) {
         u.add(elem);
      }
      return u;
   }

   /**
    * Returns a set that is the union of this set and the parameter set.
    *
    * @return  a set that contains all the elements of this set and
    *            the parameter set
    */
   @SuppressWarnings("unchecked")
   
   public Set<T> union(ArraySet<T> s) {
      Iterator<T> itr = iterator();
      Iterator<T> itr2 = s.iterator();
      T[] c = (T[]) new Comparable[s.size() + size];
      while(itr.hasNext()) {
         T start = itr.next();
         T start2 = itr2.next();
         int i = 0;
         if(start.compareTo(start2) != 0) {
            c[i] = start;
            i++;
         }
      }
      ArraySet<T> c2= new ArraySet<T>(c, 0, s.size() + size); 
     
      return c2;
   }


   /**
    * Returns a set that is the intersection of this set
    * and the parameter set.
    *
    * @return  a set that contains elements that are in both
    *            this set and the parameter set
    */
   @Override
   public Set<T> intersection(Set<T> s) {
      ArraySet<T> i = new ArraySet<T>();
      for (int j = 0; j < size; j++) {
         if (s.contains(elements[j])) {
            i.add(elements[j]);
         }
      }
      return i;
   }

   /**
    * Returns a set that is the intersection of this set and
    * the parameter set.
    *
    * @return  a set that contains elements that are in both
    *            this set and the parameter set
    */
   @SuppressWarnings("unchecked")
   public Set<T> intersection(ArraySet<T> s) {
      int i = 0;
      for (int j = 0; j < size; j++) {
         if (s.contains(elements[j])) {
            i++;
         }
      }
      
      T[] c = (T[]) new Comparable[i];
      int b = 0;
      for (int j = 0; j < size; j++) {
         if (s.contains(elements[j])) {
            c[b] = elements[j];
            b++;
         }
      }
   
      ArraySet<T> c2= new ArraySet<T>(c, 0, i); 
   
   
      return c2;
   }

   /**
    * Returns a set that is the complement of this set and
    * the parameter set.
    *
    * @return  a set that contains elements that are in this
    *            set but not the parameter set
    */
   @SuppressWarnings("unchecked")
   @Override
   public Set<T> complement(Set<T> s) {
      
      int i = 0;
      for (int j = 0; j < size; j++) {
         if (!s.contains(elements[j])) {
            i++;
         }
      }
      
      T[] c = (T[]) new Comparable[i];
      int b = 0;
      for (int j = 0; j < size; j++) {
         if (!s.contains(elements[j])) {
            c[b] = elements[j];
            b++;
         }
      }
   
      ArraySet<T> c2= new ArraySet<T>(c, 0, i); 
   
   
      return c2;
   
    
   }

   /**
    * Returns a set that is the complement of this set and
    * the parameter set.
    *
    * @return  a set that contains elements that are in this
    *            set but not the parameter set
    */
   @SuppressWarnings("unchecked")
   public Set<T> complement(ArraySet<T> s) {
      int i = 0;
      for (int j = 0; j < size; j++) {
         if (!s.contains(elements[j])) {
            i++;
         }
      }
      
      T[] c = (T[]) new Comparable[i];
      int b = 0;
      for (int j = 0; j < size; j++) {
         if (!s.contains(elements[j])) {
            c[b] = elements[j];
            b++;
         }
      }
   
      ArraySet<T> c2= new ArraySet<T>(c, 0, i); 
   
   
      return c2;      
   }


   /**
    * Returns an iterator over the elements in this ArraySet.
    * No specific order can be assumed.
    *
    * @return  an iterator over the elements in this ArraySet
    */
   @Override
   public Iterator<T> iterator() {
      return new ArrayIterator<T>(elements, size);
      // ALMOST ALL THE TESTS DEPEND ON THIS METHOD WORKING CORRECTLY.
      // MAKE SURE YOU GET THIS ONE WORKING FIRST.
      // HINT: JUST USE THE SAME CODE/STRATEGY AS THE ARRAYBAG CLASS
      // FROM LECTURE. THE ONLY DIFFERENCE IS THAT YOU'LL NEED THE
      // ARRAYITERATOR CLASS TO BE NESTED, NOT TOP-LEVEL.
   
      
   }
   
      
   /**
    * Returns an iterator over the elements in this ArraySet.
    * The elements are returned in descending order.
    *
    * @return  an iterator over the elements in this ArraySet
    */
   public Iterator<T> descendingIterator() {
      return new ReverseArrayIterator<T>(elements, size);
   }

   /**
    * Returns an iterator over the members of the power set
    * of this ArraySet. No specific order can be assumed.
    *
    * @return  an iterator over members of the power set
    */
   public Iterator<Set<T>> powerSetIterator() {
      return new PowerSetIterator(elements, size);
   }

   @SuppressWarnings("unchecked")
   private class PowerSetIterator implements Iterator<Set<T>> {
      
          
      private int setSize; //size()
      private double powerSetSize;//2^size()
      private int current;// indicates the current or “next” element in the iteration
      private T[] items;
      int bit = 0;
   
      public PowerSetIterator(T[] elements, int size) {
         setSize = size;
         powerSetSize = Math.pow(2, size);
         current = 0;
      }
                  
      public Set<T> next() {
         for (int i = 0; i < size; i++) {
         
            if (((current >>> i) & 1) != 0) { 
               bit++;
            }
         }
        
         items = (T[]) new Comparable[bit];
         int j = 0;
         for (int i = 0; i < size; i++) {
            if (((current >>> i) & 1) != 0) {
             
               items[j] = elements[i];
               j++;
            }
         }
      
         
         ArraySet<T> hold = new ArraySet<T>(items, 0, bit); 
         bit = 0;
         current++; 
         return hold;
      }
      
      public boolean hasNext() {
      
         return (current < powerSetSize);
      }
      
      public void remove() { 
         throw new NoSuchElementException();
      }          
   
   }
   
   private class ArrayIterator<T> implements Iterator<T> {
      private T[] items;
      private int current;
      private int count;
    
      public ArrayIterator(T[] elements, int size) {
         items = elements;
         count = size;
         current = 0;
      }
      
      public boolean hasNext() {
         return (current < count);        
      }
      
      public T next() {
      
         if (!hasNext()) {
            throw new NoSuchElementException();
         }
         return items[current++];
      }
      
      public void remove() {
         throw new UnsupportedOperationException();
      }
   }

   private class ReverseArrayIterator<T> implements Iterator<T> {
      private T[] items;
      private int current;
      private int count;
    
      public ReverseArrayIterator(T[] elements, int size) {
         items = elements;
         count = -1;
         current = size - 1;
      }
      
      public boolean hasNext() {
         return (count < current);        
      }
      
      public T next() {
      
         if (!hasNext()) {
            throw new NoSuchElementException();
         }
         
         return items[current--];
      }
      
      public void remove() {
         throw new UnsupportedOperationException();
      }
      
   }
    
}
