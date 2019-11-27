<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-15
  Time: 18:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName=request.getParameter("div-id");
    if(userName == null){
        userName = "px_id";
    }
    System.out.println("id是："+userName);
%>
<html>
<head>
    <script src="js/px-tool/tree.js"></script>
    <script>
        var treeJson = [{
            "id":1,
            "text":"Folder1",
            "iconCls":"icon-save",
            "children":[{
                "text":"File1",
                "checked":true
            },{
                "text":"Books",
                "state":"open",
                "attributes":{
                    "url":"/demo/book/abc",
                    "price":100
                },
                "children":[{
                    "text":"PhotoShop",
                    "checked":true
                },{
                    "id": 8,
                    "text":"Sub Bookds",
                    "state":"closed"
                }]
            }]
        },{
            "text":"Languages",
            "state":"closed",
            "children":[{
                "text":"Java"
            },{
                "text":"C#"
            }]
        }];
        var asd = "px_id";
    </script>
</head>
<body>
    <ul id="<%=userName%>" class="easyui-tree" data-options=""></ul>
</body>
</html>
