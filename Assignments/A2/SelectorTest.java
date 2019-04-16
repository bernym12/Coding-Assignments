import org.junit.Assert;
import org.junit.Test;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;   
public class SelectorTest {




   /** A test that always fails. **/
   @Test public void defaultTest() {
      Collection<Integer> c1 = Arrays.<Integer>asList(new Integer[]{});
      Selector.<Integer>kmax(c1, 1, 0);
      Assert.assertEquals(java.lang.NoSuchElementException, 1);
   }
}
