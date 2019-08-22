import org.junit.Assert;

import org.junit.Test;


public class SelectorTest {


   /** A test that always fails. **/
   @Test public void kmin() {
      int[] a6 = {4,3,2,4,2,3,3,2,8,7};
      int kmin = Selector.kmin(a6, 3);
      Assert.assertEquals(4, kmin);
   }
   
   @Test public void kmin2() {
      int[] a6 = {3,4,3,2,1,5};
      int kmin = Selector.kmin(a6, 3);
      Assert.assertEquals(3, kmin);
   }
   
   @Test public void kmax() {
      int[] a6 = {3,4,3,2,1,5};
      int kmax = Selector.kmax(a6, 3);
      Assert.assertEquals(3, kmax);
   }
   
   @Test public void kmax2() {
      int[] a6 = {1,3,5,2,5,6,3,4,5,2,5};
      int kmax = Selector.kmax(a6, 4);
      Assert.assertEquals(3, kmax);
   }
   
   @Test public void kmax3() {
      int[] a6 = {1};
      int kmax = Selector.kmax(a6, 1);
      Assert.assertEquals(1, kmax);
   }

}
