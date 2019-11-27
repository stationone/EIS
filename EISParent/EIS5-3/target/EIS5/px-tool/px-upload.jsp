<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-17
  Time: 15:29
  maeeager: 使用此上传模板，禁止一个界面中出现2次，否则可能会有异常
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<html>
<head>
    <%--<base href="<%=basePath%>">--%>
    <title>上传控件</title>
    <%--<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">--%>
    <%--<link rel="stylesheet" type="text/css" href="css/px-style.css">--%>
    <%--<script src="js/jquery.min.js"></script>--%>
    <%--<script src="js/jquery.easyui.min.1.5.2.js"></script>--%>

    <style>
        .font-size{
            font-size: 14px;
        }
    </style>
    <script>
        //选择文件
        function selectFiles() {
            document.getElementById('files_Batch').value = "";
            document.getElementById('files_Batch').click();
        }

        //文件对象数组
        var fileArray = [];

        //保存文件名称和随机编号的对应关系[{id: "s_3571428845", name: "XXHash32.java"}]
        var fileLists = [];

        //文件大小
        var fileAllSize = 0;

        //选择文件改变时
        function fileChange() {
            fileAllSize = 0;
            var file = document.getElementById("files_Batch");
            var files = file.files;

            fileArray = [];
            Array.prototype.push.apply(fileArray, files);

            $('#files_Text').empty();
            if (fileArray.length > 0) {

                for (var i = 0; i < fileArray.length; i++) {
                    var fileRelevance = {};
                    fileRelevance.id = getId("s_");
                    fileRelevance.name = fileArray[i].name;
                    fileLists.push(fileRelevance);
                    $('#files_Text').append('<div id="' + fileRelevance.id + '" class="default" style="margin-top:5px;margin-left:8px;margin-right: 8px;" title="' + fileArray[i].name + '" class="easyui-tooltip" ><div style="float: left; width:279px;height:20px;font-size:14px;overflow:hidden;padding:3px 0;">' + fileArray[i].name + '</div><img style="width:20px;float:right" class="pointer" onmouseenter="pitchOn(this)" onmouseleave="uncheck(this)" onclick="removeDiv(\'' + fileRelevance.id + '\')" src="images/px-icon/delete.png"></div>');
                }

                setFileNumber();
                setFileSize();


            } else {
                $('#fileNumber').text("");
                $('#fileAllSize').text("");
            }
        }

        //删除
        function removeDiv(id) {

            $("#" + id).remove();
            for (var i = 0; i < fileLists.length; i++) {
                var fileObject = fileLists[i];
                if (id == fileObject.id) {
                    //一样的
                    for (var y = 0; y < fileArray.length; y++) {
                        if (fileObject.name == fileArray[y].name) {

                            fileArray.splice(y, 1);
                            fileLists.splice(i, 1);
                            break;
                        }
                    }
                    break;
                }
            }

            setFileNumber();
            setFileSize();
        }

        //设置文件数量
        function setFileNumber() {
            if (fileArray.length == 0) {
                $('#fileNumber').text("");
                return;
            }

            $('#fileNumber').text(fileArray.length);
        }

        //设置文件大小
        function setFileSize() {
            if (fileArray.length == 0) {
                $('#fileAllSize').text("");
                return;
            }
            fileAllSize = 0;
            for (var s = 0; s < fileArray.length; s++) {
                fileAllSize += fileArray[s].size;
            }

            if (fileAllSize >= 1048576 && fileAllSize < 1073741824) {
                //大于等于1M,小于1G
                $('#fileAllSize').text(Math.round(fileAllSize / 1024 / 1024) + "MB");
            } else if (fileAllSize < 1048576) {
                //小于1M
                $('#fileAllSize').text(Math.ceil(fileAllSize / 1024) + "KB");
            } else {
                //大于1G
                $('#fileAllSize').text(Math.round(fileAllSize / 1024 / 1024 / 1024) + "GB");
            }
        }

        //鼠标移上
        function pitchOn(event) {
            $(event).attr('src', "images/px-icon/delete-red.png");
        }

        //取消选中
        function uncheck(event) {
            $(event).attr('src', "images/px-icon/delete.png");
        }

        /**
         * 随机数
         * 1231231343
         */
        function getId(start){
            var id = "";
            if(start != null){
                id = start;
            }
            for(var i= 0;i<10;i++){
                id += Math.round(Math.random()*9);
            }
            return id;
        }
    </script>
</head>
<body>
<input id="files_id" name="resId" type="hidden">
<input id="files_catalogNO" name="catalogNO" type="hidden">
<input id="files_catalogPath" name="catalogPath" type="hidden">
<input id="files_Batch" name="file" style="display: none" type="file" multiple="multiple"
       onchange="fileChange()">
<table cellspacing="5" class="font-size">
    <tr>
        <td valign="top" style="padding-left: 12px">
            文件名:
        </td>
        <td>
            <div id="files_Text"
                 style="width: 350px;height: 150px;border:1px solid #DADADA; overflow-y: auto"></div>
        </td>
        <td>
            <input type="button" value="选择文件" style="width: 71px;height: 150px;border: 0px;outline:none;"
                   onclick="selectFiles()"/>
        </td>
    </tr>
    <tr>
        <td valign="top" style="padding-left: 12px" >
            文件数量:
        </td>
        <td>
            <span id="fileNumber"></span>
        </td>
    </tr>
    <tr>
        <td valign="top" style="padding-left: 12px" >
            文件大小:
        </td>
        <td>
            <span id="fileAllSize"></span>
        </td>
    </tr>
</table>
<div id="progress_bottom1" class="progress-bottom" style="display: none;padding-top: 14px;">
    <div style="width:100%;position:absolute;top: 95px;display: none">
        <san id="progress_span1" style="font-size: 22px;">1%</san>
    </div>
    <div id="progress_span_ok12" style="width: 100%;position:absolute;top: 121px;display:block">
        <span id="progress_span_text112" style="font-size: 16px;font-weight: 800;color:#122b39"></span>
    </div>

</div>

</body>
</html>
