<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-24
  Time: 11:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>传输列表</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>
    <script>
        /**
         * 绘制上传进度界面
         * [{id:'f_21212156212',name:'文件名称1',code:'2'}]
         *
         */
        function setUploadProgressPage(dataArray){
            var uploadPlan = "";
            $('#fileUpload_div').html("");
            uploadPlan+='<table  style="width: 100%" cellspacing="0" cellpadding="0">';

            //最新版
            for(var i = 0;i<dataArray.length;i++){
                var pro = '<div id="pg_'+dataArray[i].id+'" class="easyui-progressbar" data-options="value:0" style="width:100%;height:15px;"></div>';
                var message = "正在上传";
                if(dataArray[i].code == 1){
                    message = "上传完成";
                    pro = '<div id="pg_'+dataArray[i].id+'" class="easyui-progressbar" data-options="value:100" style="width:100%;height:15px;"></div>';
                }else if(dataArray[i].code ==  3){
                    message = "正在同步版本库";
                    pro = '<div id="pg_'+dataArray[i].id+'" class="easyui-progressbar" data-options="value:100" style="width:100%;height:15px;"></div>';
                }

                uploadPlan+='<tr>'
                    +'<td style="width: 20px; padding: 0 5px 0 14px;border-bottom: 1px solid #F5F5F5">'
                    +'<img src="images/px-icon/upload-img.png" style="width: 20px;">'
                    +'</td>'
                    +'<td style="border-bottom: 1px solid #F5F5F5">'
                    +'<div style="overflow: hidden;height: 20px;font-size: 14px">'
                    +'<span title="'+dataArray[i].name+'" class="easyui-tooltip">'
                    + dataArray[i].name
                    +'</span>'
                    +'</div>'
                    +'<div style="height: 20px;font-size: 14px">'
                    +'<span  style="font-size: 12px;color: #B4B4B4;font-weight: bold;" >3.26MB</span>'
                    +'</div>'
                    +'</td>'
                    +'<td style="width: 250px;border-bottom: 1px solid #F5F5F5;padding-right: 20px">'
                    + pro
                    +'<div style="margin-top: 3px;">'
                    +'<span id="'+dataArray[i].id+'message" style="font-size: 12px;color: #B4B4B4;font-weight: bold;">'
                    +message
                    +'</span>'
                    +'</div>'
                    +'</td>'
                    +'</tr>';
            }
            uploadPlan+='</table>';


            //前一版本
            // for(var i = 0;i<dataArray.length;i++){
            //     var pro = '<progress max="100" value="0" style="width:100%;" id="pg_'+dataArray[i].id+'">';
            //     var message = "正在上传";
            //     if(dataArray[i].code == 1){
            //         message = "上传完成";
            //         pro = '<progress max="100" value="100" style="width:100%;" id="pg_'+dataArray[i].id+'">';
            //     }else if(dataArray[i].code ==  3){
            //         message = "正在同步版本库";
            //         pro = '<progress max="100" value="100" style="width:100%;" id="pg_'+dataArray[i].id+'">';
            //     }
            //
            //     uploadPlan+='<div id="'+dataArray[i].id+'" class="fileUploadPlan_div">'
            //         +'<div class="fileUpload_name_div">'
            //         +'<span class="fileUpload_name">'
            //         +dataArray[i].name
            //         +'</span>'
            //         +'</div>'
            //         +'<div id="'+dataArray[i].id+'message" class="fileUploadText" >'
            //         + message
            //         +'</div>'
            //         +'<div class="fileUploadPlan_show">'
            //         + pro
            //         +'</div>'
            //         +'</progress>'
            //         +'</div>';
            //
            // }
            $('#fileUpload_div').append(uploadPlan);
            $.parser.parse('#fileUpload_div');
        }
    </script>
</head>
<body class="easyui-layout">
    <jsp:include page="/px-tool/px-uploadProgress.jsp"/>
</body>
</html>
