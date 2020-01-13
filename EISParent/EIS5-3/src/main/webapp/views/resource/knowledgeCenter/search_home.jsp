<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/1/8 0008
  Time: 上午 11:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String treeId = "pxTool-tree";
    String datagridId1 = "px_2";
    String datagridId2 = "download_datagrid";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>搜索界面</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script type="text/javascript" src="ui/jquery.min.js"></script>
    <script type="text/javascript" src="ui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="ui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>

    <script>
        /**
         * 入口函数
         */
        $(function () {


        });

        /**
         * 点击搜索
         */
        function file_search() {
            //获取input中的值
            var search = document.getElementById('search').value;
            window.location.href = "./views/resource/knowledgeCenter/file_search_home.jsp?search=" + search;
        }
    </script>

</head>
<body>

<div id="cc" class="easyui-layout" style="width:100%;height:100%;margin: auto;">
    <table style="margin: auto;">
        <div style="margin-top: 8%;"></div>
        <tr>
            <td style="text-align: center">
                <div style="background-color: blue;width: 250px;height: 70px;margin: auto;">
                    <img src="./images/px-icon/logo.png" alt="" style="width: 250px;height: 70px;">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div style="margin-top: 5%;"></div>
            </td>
        </tr>
        <tr>
            <td>
                <input id="search" name="search" class="easyui-textbox"
                       style="width:500px;height: 32px;border: 1px solid blue;font-size: 20px;margin-top: 5px;">
                <a onclick="file_search()" href="javaScript:void(0)" class="easyui-linkbutton"
                   style="text-align: center;color: #3ba7f6; width:80px;height: 30px;">
                    <span style="font-size: 22px;">搜&nbsp;&nbsp;&nbsp;索</span></a>
            </td>
        </tr>

    </table>
</div>

</body>
</html>
