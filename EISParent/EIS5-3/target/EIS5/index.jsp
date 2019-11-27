<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-10
  Time: 22:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/px-tool/datagrid.js"></script>
    <script>
        var fields1 = [  {id:"resId",name:"编号"}
            ,{id:"resName",name:"资源名称"}
            ,{id:"resType",name:"资源类型"}
            ,{id:"inputUser",name:"上传者"}
            ,{id:"inputDate",name:"上传日期"}
            ,{id:"a6",name:"版本号"}
            ,{id:"a7",name:"说明"}
        ];

        $(function(){

            $.ajax({
                url: "views/iframe_datagrid.html?div-id=pxtree",
                cache: false,
                success: function(html){
                    // console.log(html);
                    $("#idv_iframe").html(html);
                    setDatagridField('px_1', fields1);
                }
            });

        })
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'center'" id="idv_iframe">

    </div>
</body>
</html>
