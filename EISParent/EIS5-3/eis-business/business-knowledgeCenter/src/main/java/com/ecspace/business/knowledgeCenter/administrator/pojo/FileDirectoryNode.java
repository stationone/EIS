package com.ecspace.business.knowledgeCenter.administrator.pojo;


import java.util.List;

/**
 * 文件内目录
 *
 * @author zhangch
 * @date 2019/11/7 0007 下午 15:04
 */
public class FileDirectoryNode {
    private Page page;
    private FileDirectoryNode parentNode;//父目录
    private String nodeName;//目录名称名称
    private List<FileDirectoryNode> subNodeList;
    private FileDirectoryNode previousNode;//前一个
    private FileDirectoryNode nextNode;//后一个
    private Integer level;//级别
    private String nodeNO;

    public Page getPage() {
        return page;
    }

    public void setPage(Page page) {
        this.page = page;
    }

    public FileDirectoryNode getParentNode() {
        return parentNode;
    }

    public void setParentNode(FileDirectoryNode parentNode) {
        this.parentNode = parentNode;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    public List<FileDirectoryNode> getSubNodeList() {
        return subNodeList;
    }

    public void setSubNodeList(List<FileDirectoryNode> subNodeList) {
        this.subNodeList = subNodeList;
    }

    public FileDirectoryNode getPreviousNode() {
        return previousNode;
    }

    public void setPreviousNode(FileDirectoryNode previousNode) {
        this.previousNode = previousNode;
    }

    public FileDirectoryNode getNextNode() {
        return nextNode;
    }

    public void setNextNode(FileDirectoryNode nextNode) {
        this.nextNode = nextNode;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public void setNodeNO(String nodeNO) {
        this.nodeNO = nodeNO;
    }

    public String getNodeNO() {
        return nodeNO;
    }

}
