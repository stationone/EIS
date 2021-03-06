<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-17
  Time: 16:43
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
    <title>知识中心</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <link rel="stylesheet" type="text/css" href="ui/themes/icon.css">
    <script src="js/jquery.min.js"></script>
    <%--<script src="js/jquery.easyui.min.1.5.2.js"></script>--%>
    <script src="ui/jquery.easyui.min.js"></script>

    <script src="js/pxzn.util.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
    <script type="text/javascript" src="js/search_history.js"></script>
    <script>
        $(function () {
            $('#history').bind('click', function () {
                $('#page_show').attr('src', './views/resource/knowledgeCenter/search_history.jsp');
            });
            $('#collection').bind('click', function () {
                $('#page_show').attr('src', './views/resource/knowledgeCenter/my_save.jsp');

            });
            $('#search').bind('click', function () {
                $('#page_show').attr('src', './views/resource/knowledgeCenter/my_search.jsp');

            });
        });
    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout" style="width: 100%;height:100%">
<%--<div data-options="region:'north'" class="layout-north" style="width: 100%;height:5%">--%>
    <%--&lt;%&ndash;<a href="./views/resource/knowledgeCenter/search_history.jsp">&ndash;%&gt;--%>
    <%--&lt;%&ndash;搜索记录&ndash;%&gt;--%>
    <%--&lt;%&ndash;</a>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<a href="./views/resource/knowledgeCenter/my_save.jsp">&ndash;%&gt;--%>
    <%--&lt;%&ndash;我的收藏&ndash;%&gt;--%>
    <%--&lt;%&ndash;</a>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<a href="./views/resource/knowledgeCenter/my_search.jsp">&ndash;%&gt;--%>
    <%--&lt;%&ndash;我的搜索&ndash;%&gt;--%>
    <%--&lt;%&ndash;</a>&ndash;%&gt;--%>
    <%--<a id="history" href="javaScript:void(0)" class="easyui-linkbutton c1" style="width:120px">搜索记录</a>--%>
    <%--<a id="collection" href="javaScript:void(0)" class="easyui-linkbutton c2" style="width:120px">我的收藏</a>--%>
    <%--<a id="search" href="javaScript:void(0)" class="easyui-linkbutton c3" style="width:120px">我的搜索</a>--%>
<%--</div>--%>
<div data-options="region:'center'" class="layout-center" style="width: 100%;height:95%">
    <div data-options="">
        <div id="tabs" class="easyui-tabs" data-options="tools:'#tab-tools',selected:0" style="width:100%;height: 100%">
            <div title="我的搜索" style="padding:10px;">
                <iframe  src="./views/resource/knowledgeCenter/my_search.jsp" frameborder="0"
                         style="width: 100%;height:100%"></iframe>
            </div>
            <div title="我的收藏" style="padding:10px;">
                <iframe src="./views/resource/knowledgeCenter/my_save.jsp" frameborder="0"
                        style="width: 100%;height:100%"></iframe>
            </div>
            <div title="搜索记录" style="padding:10px;">
                <iframe src="./views/resource/knowledgeCenter/search_history.jsp" frameborder="0"
                        style="width: 100%;height:100%"></iframe>
            </div>

        </div>


    </div>


    <%--<iframe id="page_show" src="./views/resource/knowledgeCenter/my_search.jsp" frameborder="0"--%>
            <%--style="width: 100%;height:100%"></iframe>--%>
</div>

</body>
</html>
