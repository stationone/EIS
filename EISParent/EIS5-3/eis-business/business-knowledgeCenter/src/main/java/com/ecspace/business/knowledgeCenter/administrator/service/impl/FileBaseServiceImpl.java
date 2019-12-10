package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.dao.FileBaseDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileBaseService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.collections4.IterableUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author zhangch
 * @date 2019/11/29 0029 下午 20:40
 */
@Service
public class FileBaseServiceImpl implements FileBaseService {
    @Autowired
    private FileBaseDao fileBaseDao;

    @Override
    public PageData fileBaseList(Integer page, Integer size) {
        if (page == null) {
            page = 0;
        } else {
            page = page - 1;
        }
        if (size == null) {
            size = 10;
        }
        Pageable pageable = new PageRequest(page, size);
        Page<FileBase> fileBasePage = fileBaseDao.findAll(pageable);
        PageData pageData = new PageData();
        pageData.setTotal(new Long(fileBasePage.getTotalElements()).intValue());
        pageData.setRows(fileBasePage.getContent());
        return pageData;
    }

    @Override
    public List<FileBase> listFileBase(){
        ArrayList<FileBase> bases = new ArrayList<>();
        Iterable<FileBase> fileBases = fileBaseDao.findAll();
        for (FileBase fileBase : fileBases) {
            bases.add(fileBase);
        }
        return bases;

    }

    @Override
    public GlobalResult saveFileBase(FileBase fileBase) {
        String id = fileBase.getId();
        if ((id == null) || "".equals(id)) {
            id = TNOGenerator.generateId();
        }
        fileBase.setId(id);
        FileBase save = fileBaseDao.save(fileBase);
        return new GlobalResult(true, 2000, "干的漂亮", save);
    }

    @Override
    public GlobalResult deleteFileBase(String id) {
        fileBaseDao.deleteById(id);
        return new GlobalResult(true, 2000, "干的漂亮");
    }
}
