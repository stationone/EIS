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
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/pxzn.util.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>

    <script>
        var treeId = "<%=treeId%>";
        var datagridId1 = "<%=datagridId1%>";

        /**
         * 入口函数
         */
        $(function () {
            //获取页面跳转携带的参数
            var resu = param_sub();
            //请求文件详情服务
            file_show(resu.fileId, resu.pageNo);
            console.log(resu);

        });

        /**
         * 文件预览
         */
        function file_show(fileId, pageNo) {
            $.ajax({
                url: 'file/fileDetail',
                method: 'GET',
                contentType: 'application/json',
                data: 'fileId=' + fileId,
                dataType: 'json',
                success: function (result) {
                    //数据展示
                    dataShow(result, pageNo);

                }
            });

            console.log(fileId, pageNo);
        }

        /**
         * 网页跳转携带参数处理
         */
        function param_sub() {
            var url = location.search; //获取url中"?"符后的字串, 包含?
            console.log(url);
            var theRequest = new Object();
            if (url.indexOf("?") != -1) {
                var str = url.substr(1);
                strs = str.split("&");
                for (var i = 0; i < strs.length; i++) {
                    theRequest[strs[i].split("=")[0]] = decodeURIComponent(strs[i].split("=")[1]);
                }
            }
            return theRequest;
        }

        //时间戳转日期格式
        function formatDate(time, format) {
            var t = new Date(time);
            var tf = function (i) {
                return (i < 10 ? '0' : '') + i
            };
            return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function (a) {
                switch (a) {
                    case 'yyyy':
                        return tf(t.getFullYear());
                        break;
                    case 'MM':
                        return tf(t.getMonth() + 1);
                        break;
                    case 'mm':
                        return tf(t.getMinutes());
                        break;
                    case 'dd':
                        return tf(t.getDate());
                        break;
                    case 'HH':
                        return tf(t.getHours());
                        break;
                    case 'ss':
                        return tf(t.getSeconds());
                        break;
                }
            })
        };

        /**
         * 数据展示
         * @param result
         */
        function dataShow(result, pageNo) {
            if (result === null) {
                return;
            }
            var no = 1;
            if (pageNo !== 'undefined') {
                no = pageNo;
                console.log(no);
            }
            //清除
            $('#dataList').remove();
            //创建
            $('#dataParent').append('<dev id="dataList">\n' +
                '        <%--正文内容--%>\n' +
                '    </dev>');
            //展示
            var pageList = result.pageList;
            var index = no - 1 < 0 ? 0 : no - 1;//定义索引
            if (index > pageList.length - 1) {
                index = pageList.length - 1;
            }
            console.log("index" + index);
            //获取page对象
            var page = pageList[index];

            var time = result.creationTime;
            // console.log(time);
            //格式化日期
            var dateFormat = formatDate(time, 'yyyy-MM-dd HH:mm:ss');
            // console.log(dateFormat);
            //作者
            var author = result.authorName == null ? '佚名' : result.authorName;
            //文件名
            var filename = result.fileName == null ? '' : result.fileName;

            var pageWebPath = page.pageWebPath;
            console.log(pageWebPath);
            var fileId = result.fileId;
            // console.log(fileId);
            var filePdf = '\'' + result.filePdf + '\'';
            $('#dataList').append('            <div style="color: grey;font-size: 5px;">\n' +
                '                        上传时间: ' + dateFormat + '\n' +
                '                        <i> &nbsp;&nbsp;&nbsp; </i> <i>&nbsp;&nbsp;&nbsp;</i>0次下载<i>&nbsp;&nbsp;&nbsp; </i>\n' +
                '                        作者：\n' +
                '                        <span href="javaScript:void(0)">\n' +
                '                        ' + author + '\n' +
                '                        </span>\n' +
                '                    </div>\n' +
                '\n' +
                '                    <iframe id="iframe" src="' + pageWebPath + '" width="100%" height="90%"\n' +
                '                            frameborder="0">\n' +
                '                        您的浏览器不支持iframe，请升级\n' +
                '                    </iframe>' + ' <button type="button" style="margin-right: 35%" onclick="file_show(\''+fileId+'\', '+index+')">前一页</button>\n' +
                '                    <button type="button" onclick="allFile(' + filePdf + ')">加载整片文档</button>\n' +
                '                    <button type="button" style="margin-right: 0px;float: right;" onclick="file_show(\'' + fileId + '\',' + (index+2) + ')">后一页</button>')

        }

        function before(page) {
            $('#iframe').attr('src', page);

        }

        function after(page) {
            $('#iframe').attr('src', page);
        }

        function allFile(filePdf) {
            $('#iframe').attr('src', filePdf);

        }

    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'center'">
    <div class="easyui-layout" data-options="fit:true">

        <div id="permissionSet_dg_toolbar" data-options="region:'north'">
            <div class="datagrid-title-div"><span>文件详情</span></div>
        </div>
        <div data-options="region:'west'" style="width: 90%;">
            <div id="dataParent">
                <div id="dataList">
                </div>
            </div>
        </div>

        <%--<div data-options="region:'east'" style="background-color: red;height: 50px;width:30%">--%>
        <%--东边展示文件其他东西--%>
        <%--</div>--%>


    </div>


</div>

<%-- 弹出对话框 --%>
<%--目录表单--%>
<div id="folder_dialog" class="easyui-dialog"
     data-options="closed:true, modal:true,border:'thin', buttons:'#folder_dialog_button'">
    <form id="folder_dialog_form" method="post" novalidate>
        <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;">
            <input name="pid" type="hidden">
            <input name="id" type="hidden">
            <tr>
                <td><span class="pxzn-span-two">名称</span></td>
                <td>
                    <input id="text" name="text" class="easyui-textbox pxzn-dialog-text"
                           data-options="required:true,validType:['space','keyword','fileOrCata','length[1,200]']">
                </td>
            </tr>
        </table>
    </form>
    <div id="folder_dialog_button" class="pxzn-dialog-buttons">
        <input type="button" onclick="folder_dialog_ok()" value="保存" class="pxzn-button">
        <input type="button" onclick="folder_dialog_close()" value="取消" style="margin-left:40px;"
               class="pxzn-button">
    </div>
</div>

<%--新增文件--%>
<div id="file_dialog" class="easyui-dialog"
     data-options="closed:true, modal:true,border:'thin', buttons:'#file_dialog_button'">
    <form id="file_dialog_upload" method="post" enctype="multipart/form-data">

        <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;">
            <input id="menuId" name="menuId" type="hidden">
            <tr>
                <td class="pe-label"><span class="sp_waning"></span>简介(关键词)：</td>
                <td class="pe-content" colspan="6">
                    <input id="keyword" class="easyui-textbox" name="keyword" style="width:100%;height:60px"
                           data-options="multiline:true,prompt:'随便写点儿介绍关键词什么的用于被检索...'">
                </td>
            </tr>
            <tr>
                <td class="pe-label">文 件 上 传：</td>
                <td class="pe-content" colspan="6">
                    <input id="file" name="file" class="easyui-file" type="file"
                           style="width:100%">
                </td>
            </tr>
        </table>

    </form>
    <div id="file_dialog_button" class="pxzn-dialog-buttons">
        <input type="button" onclick="file_dialog_ok()" value="保存" class="pxzn-button">
        <input type="button" onclick="file_dialog_close()" value="取消" style="margin-left:40px;"
               class="pxzn-button">
    </div>
</div>

</body>
</html>
