import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author zhangch
 * @date 2019/10/28 0028 上午 9:44
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class SpringTest {


    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;


    @Test
    public void test1(){

        System.out.println(elasticsearchTemplate.getMapping("dev", "dev"));
        System.out.println(elasticsearchTemplate.getSetting("dev"));
        //Scroll 卷
        //alias 别名
        System.out.println("Hello, elasticsearchTemplate!");
    }
}
