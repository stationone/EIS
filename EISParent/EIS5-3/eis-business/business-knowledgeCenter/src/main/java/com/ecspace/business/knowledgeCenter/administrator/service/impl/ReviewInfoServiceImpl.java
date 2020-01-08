package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.dao.ReviewInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.ReviewInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
import com.ecspace.business.knowledgeCenter.administrator.service.ReviewInfoService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

/**
 * @author zhangch
 * @date 2020/1/6 0006 下午 14:16
 */
@Service
public class ReviewInfoServiceImpl implements ReviewInfoService {
    @Autowired
    private ReviewInfoDao reviewInfoDao;
    @Autowired
    private FileService fileService;

    @Override
    public GlobalResult insert(ReviewInfo reviewInfo) throws Exception {
        reviewInfo.setId(TNOGenerator.generateId());
        reviewInfo.setReviewer("系统管理员");//审核人员
        Integer integer = reviewInfoDao.countByFileId(reviewInfo.getFileId());
        integer = integer + 1;
        reviewInfo.setRejectCount(integer);//审核次数
        //修改文档信息
        FileInfo fileInfo = fileService.getFileById(reviewInfo.getFileId());
//        if (fileInfo.getStatus() == 4) {
//            //已经审核入库, 无须审核
//            return new GlobalResult(false,400,"违规操作");
//        }
        fileInfo.setStatus(Integer.parseInt(reviewInfo.getStatus()));
        ReviewInfo info = reviewInfoDao.save(reviewInfo);//保存
        FileInfo finfo = fileService.saveFileInfo(fileInfo);
        return new GlobalResult(true,200,"ok",finfo);
    }

    /**
     * 修改
     * @param reviewInfo
     * @return
     */
    @Override
    public GlobalResult update(ReviewInfo reviewInfo) {

        return null;
    }

    @Override
    public GlobalResult delete(String id) {
        reviewInfoDao.deleteById(id);
        return new GlobalResult(true,200,"ok",null);
    }

    @Override
    public PageData reviewList(String fileId, Integer page, Integer size) {
        if (page == null) {
            page = 0;
        }else {
            page = page - 1;
        }
        if (size == null) {
            size = 10;
        }
        Pageable pageable = PageRequest.of(page, size);
        Page<ReviewInfo> infoPage = reviewInfoDao.findByFileId(fileId, pageable);
        PageData pageData = new PageData();
        Long total = infoPage.getTotalElements();

        pageData.setTotal(total.intValue());
        pageData.setRows(infoPage.getContent());
        return pageData;
    }
}
