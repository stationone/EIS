package com.ecspace.business.resourceCenter.administrator.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.HashMap;


//@RunWith(SpringJUnit4ClassRunner.class)

//@ContextConfiguration(locations="file:EIS5-3/src/main/resource/applicationContext.xml""file:E:/wordSpaces/EISParent/EIS5-3/src/main/resource/applicationContext.xml")
public class ResourceServiceTest {

    @Autowired
    ResourceService resourceService;
    @Test
    public void list() {
        System.out.println(resourceService.list(new HashMap<>()));

    }

    @Test
    public void listByCatalogResLink() {
    }

    @Test
    public void listByCatalogResLinkTotal() {
    }

    @Test
    public void deleteBatch() {
    }
}