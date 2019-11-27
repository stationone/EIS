<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-15
  Time: 16:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName=request.getParameter("div-id");
    String toolbar = request.getParameter("datagrid-toolbar");
    if(toolbar == null){
        toolbar = "";
    }
    if(userName == null){
        userName = "px_id";
    }

%>
<html>
<head>
    <%--<title>datagrid</title>--%>
    <%--<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">--%>
    <%--<link rel="stylesheet" type="text/css" href="css/px-style.css">--%>
    <%--<script src="js/jquery.min.js"></script>--%>
    <%--<script src="js/jquery.easyui.min.1.5.2.js"></script>--%>
    <script src="js/px-tool/datagrid.js"></script>

    <script>
        var fields1 = [  {id:"resId",name:"编号"}
                        ,{id:"resName",name:"资源名称"}
                        ,{id:"resType",name:"资源类型"}
                        ,{id:"inputUser",name:"上传者"}
                        ,{id:"inputDate",name:"上传日期"}
                        ,{id:"svnURL",name:"资源地址"}
                        ,{id:"svnVersion",name:"svn版本号"}
                        ,{id:"remark",name:"备注"}
                     ];

        var fields2 = [  {id:"a1",name:"编号"}
                        ,{id:"a2",name:"资源名称"}
                        ,{id:"a3",name:"资源类型"}
                        ,{id:"a4",name:"上传者"}
                       ];
    </script>
</head>
<body>
    <table id="<%=userName%>" class="easyui-datagrid" data-options="fitColumns:true,pagination:true,fit:true,toolbar:'#<%=toolbar%>'"></table>
</body>
</html>
