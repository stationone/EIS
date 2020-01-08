package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.ReviewInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.ReviewInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 审批控制层
 * @author zhangch
 * @date 2020/1/6 0006 下午 16:24
 */
@RestController
@RequestMapping("/review")
public class ReviewInfoController {

    @Autowired
    private ReviewInfoService reviewInfoService;

    /**
     * 保存
     * @return GlobalResult
     */
    @LogAnno(operateType = "审批/添加")
    @PostMapping("/save")
    public GlobalResult save(ReviewInfo reviewInfo) throws Exception {
        if (reviewInfo.getReviewIdea() == null) {
            return new GlobalResult(false, 4000,"参数异常");
        }
        return reviewInfoService.insert(reviewInfo);
    }

    /**
     * 审批列表
     * @param fileId
     * @param page
     * @param size
     * @return
     * @throws Exception
     */
    @GetMapping("/reviewInfoList")
    public PageData reviewInfoList(String fileId, Integer page, Integer size) throws Exception {
        PageData pageData = reviewInfoService.reviewList(fileId, page, size);
        return pageData;
    }
}
