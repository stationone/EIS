
package com.ecspace.business.knowledgeCenter.administrator.FileAnalysis;


import com.ecspace.business.knowledgeCenter.administrator.pojo.FileDirectoryNode;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Page;
import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 获取word文档
 *
 * @Author tongy
 */

public class WordUtil {

    /**
     * 获取word文件的标题
     *
     * @param filePath 文件路径
     * @return
     * @throws IOException
     */

    public static List<Map<String, Object>> getWordTitles(String filePath) {
        List<Map<String, Object>> mapList = new ArrayList<>();
        ActiveXComponent word = new ActiveXComponent("Word.Application");
        word.setProperty("Visible", new Variant(false));
        Dispatch documents = word.getProperty("Documents").toDispatch();
        Dispatch wordFile = Dispatch.invoke(documents, "Open", Dispatch.Method, new Object[]{filePath, new Variant(true), new Variant(false)}, new int[1]).toDispatch();
        Dispatch paragraphs = Dispatch.get(wordFile, "Paragraphs").toDispatch();
        int paraCount = Dispatch.get(paragraphs, "Count").getInt();
        for (int i = 0; i < paraCount; i++) {
            Dispatch paragraph = Dispatch.call(paragraphs, "Item", new Variant(i + 1)).toDispatch();
            int level = Dispatch.get(paragraph, "OutlineLevel").getInt();
            if (level <= 9) {
                Map<String, Object> map = new HashMap<>();
                Dispatch paraRange = Dispatch.get(paragraph, "Range").toDispatch();
                String title = Dispatch.get(paraRange, "Text").toString();
//                int pageNum = Integer.parseInt(Dispatch.call(paraRange,"information",1).toString());
                int pageNum = Integer.parseInt(Dispatch.call(paraRange, "information", 3).toString());
                map.put("nodeName", title);
                map.put("level", level);
                map.put("pageNum", pageNum);
                mapList.add(map);
            }
        }
        Dispatch.call(wordFile, "Close", new Variant(true));
        Dispatch.call(word, "Quit");
        return mapList;
    }


    /**
     * 将map集合转换为实体集合
     *
     * @param mapList
     * @return
     */

    public static List<FileDirectoryNode> packageNode(List<Map<String, Object>> mapList) {
        List<FileDirectoryNode> nodeList = new ArrayList<>();
        for (int mapIndex = 0, size = mapList.size(); mapIndex < size; mapIndex++) {
            Map<String, Object> map = mapList.get(mapIndex);
            FileDirectoryNode node = new FileDirectoryNode();
            node.setNodeNO(String.valueOf(mapIndex + 1));   //节点编号
            node.setNodeName((String) map.get("nodeName"));  //节点名称
            node.setLevel((Integer) map.get("level"));  //节点等级
            Page page = new Page();
            page.setPageNO((Integer) map.get("pageNum"));
            node.setPage(page);      //节点所在page页
            nodeList.add(node);
        }
        return nodeList;
    }


    /**
     * 封装父子节点及前驱后驱节点
     *
     * @param nodeList
     * @return
     */

    public static List<FileDirectoryNode> packageOthers(List<FileDirectoryNode> nodeList) {
        //父目录
        for (int nodeIndex = 0, size = nodeList.size(); nodeIndex < size; nodeIndex++) {
            FileDirectoryNode node = nodeList.get(nodeIndex);
            //(不是一级目录则封装)
            if (node.getLevel() != 1) {
                //从当前目录往前找第一个上级目录
                FileDirectoryNode finalParentNode = new FileDirectoryNode();
                for (int pNodeIndex = nodeIndex - 1; pNodeIndex >= 0; pNodeIndex--) {
                    FileDirectoryNode parentNode = nodeList.get(pNodeIndex);
                    int parentLevel = parentNode.getLevel();    //父级目录的层级
                    if (parentLevel + 1 == node.getLevel()) {    //存在隐患（跨级标题）：父目录与子目录为一级标题和三级标题
                        finalParentNode = parentNode;
                        break;
                    }
                }
                node.setParentNode(finalParentNode);
            } else {
                node.setParentNode(new FileDirectoryNode());
            }

        }
        //子目录
        for (FileDirectoryNode node : nodeList) {
            List<FileDirectoryNode> subNodeList = new ArrayList<>();
            //从当前目录往后所有目录
            for (FileDirectoryNode node1 : nodeList) {
                if (node1.getParentNode() != null && node1.getParentNode().getNodeNO() != null) {//&& node1.getNodeNO() != null 不加判断会报空指针异常
                    if (node1.getParentNode().getNodeNO().equals(node.getNodeNO())) {
                        subNodeList.add(node1);
                    }
                }
            }
            node.setSubNodeList(subNodeList);
        }
        //前驱节点与后驱节点
        for (FileDirectoryNode node : nodeList) {
            int level = node.getLevel();
            //得到与当前节点同级的目录（且父级目录也相同）
            List<FileDirectoryNode> levelNodeList = new ArrayList<>();
            for (FileDirectoryNode node1 : nodeList) {
                if (level == node1.getLevel()) {     //与当前目录同级
                    //一级目录
                    if (level == 1) {
                        levelNodeList.add(node1);
                    } else {
                        String parenNodeNO = node.getParentNode().getNodeNO();      //当前目录的父目录
                        //加入非空判断
                        if (parenNodeNO != null && parenNodeNO.equals(node1.getParentNode().getNodeNO())) {   //限定同一父目录
                            levelNodeList.add(node1);
                        }
                    }
                }
            }
            for (int levelNodeIndex = 0, size = levelNodeList.size(); levelNodeIndex < size; levelNodeIndex++) {
                FileDirectoryNode levelNode = levelNodeList.get(levelNodeIndex);
                if (levelNode.getNodeNO().equals(node.getNodeNO())) {    //得到当前的目录
                    if (levelNodeIndex != 0) {
                        node.setPreviousNode(levelNodeList.get(levelNodeIndex - 1));
                    }
                    if (levelNodeIndex != size - 1) {
                        node.setNextNode(levelNodeList.get(levelNodeIndex + 1));
                    }
                }
            }
        }
        return nodeList;
    }

    public static List<FileDirectoryNode> getWordNodes(String filePath) {
        List<Map<String, Object>> mapList = getWordTitles(filePath);
        List<FileDirectoryNode> nodes = packageNode(mapList);
        List<FileDirectoryNode> nodeList = packageOthers(nodes);
        return nodeList;
    }

    public static void main(String[] args) {
        String filePath = "C:\\Users\\Administrator\\Desktop\\file\\word\\100808.docx";
        getWordTitles(filePath);

        List<FileDirectoryNode> nodes = getWordNodes(filePath);
        for (FileDirectoryNode node : nodes) {
            System.out.println(node.getNodeNO() + "===" + node.getNodeName());
            System.out.println("等级：     " + node.getLevel());
            System.out.println("page     " + node.getPage().toString());
            if (node.getParentNode() != null) {
                System.out.println("parent     " + node.getParentNode().getNodeName());
            }
            System.out.println("sub   " + node.getSubNodeList().size());
            if (node.getPreviousNode() != null) {
                System.out.println("previous     " + node.getPreviousNode().getNodeName());
            }
            if (node.getNextNode() != null) {
                System.out.println("next     " + node.getNextNode().getNodeName());
            }
        }

    }
}

