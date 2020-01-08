package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

/**
 * 审批信息
 * @author zhangch
 * @date 2020/1/6 0006 上午 11:53
 */
@Document(indexName = "review_info",shards = 1,replicas = 0)
public class ReviewInfo {
    @Id
    private String id;

    private String fileId;//文件id

    private String reviewIdea;//审批意见

    private Integer rejectCount;//驳回次数

    private String reviewer;//审批人

    private String status;//审批状态

    public ReviewInfo() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getReviewIdea() {
        return reviewIdea;
    }

    public void setReviewIdea(String reviewIdea) {
        this.reviewIdea = reviewIdea;
    }

    public Integer getRejectCount() {
        return rejectCount;
    }

    public void setRejectCount(Integer rejectCount) {
        this.rejectCount = rejectCount;
    }

    public String getReviewer() {
        return reviewer;
    }

    public void setReviewer(String reviewer) {
        this.reviewer = reviewer;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
