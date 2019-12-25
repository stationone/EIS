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
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>


    <script>
        var treeId = "<%=treeId%>";
        var datagridId1 = "<%=datagridId1%>";

        /**
         * 入口函数
         */
        $(function () {
            //获取页面跳转携带的参数
            var resu = param_sub();

            console.log(resu);
            docShow(resu.fileId);

            //监听鼠标
            // mouseEnter();
            // select_indexName();

            file_type();
        });

        /**
         * 文件预览
         */
        // function file_show(fileId, pageNo) {
        //     $.ajax({
        //         url: 'file/fileDetail',
        //         method: 'GET',
        //         contentType: 'application/json',
        //         data: 'fileId=' + fileId,
        //         dataType: 'json',
        //         success: function (result) {
        //             //数据展示
        //             dataShow(result, pageNo);
        //         }
        //     });
        //     console.log(fileId, pageNo);
        // }

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

        //文件大小格式化
        function formatSize(value) {
            if (null == value || '' === value) {
                return "0 Bytes";
            }
            var unitArr = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
            var index = 0;
            var srcsize = parseFloat(value);
            index = Math.floor(Math.log(srcsize) / Math.log(1024));
            var size = srcsize / Math.pow(1024, index);
            size = size.toFixed(2);//保留的小数位数
            return size + unitArr[index];
        }

        /**
         * 文档展示
         * @param fileId
         */
        function docShow(fileId) {
            if (fileId == null) {
                return;
            }
            $.ajax({
                url: 'file/fileDetail',
                method: 'GET',
                contentType: 'application/json',
                data: 'fileId=' + fileId,
                dataType: 'json',
                success: function (result) {
                    if (result.author != null) {
                        var textHtml = '';
                        textHtml += '<tr>';
                        textHtml += '<td class="pe-label" style="width: 40%">文档作者(author)</td>';
                        textHtml += '<td><input id="author" name="author" class="easyui-textbox" style="width:100%;height:25px"></td>';
                        textHtml += '</tr>';
                        $('#filedTable').html(textHtml);
                    }

                    console.log(result);
                    //数据展示
                    // dataShow(result, pageNo);
                    if (result.src != null)
                        $('#preSee').attr('src', result.src); //成功后替换页面
                    //成功后填充表单
                    // var formatDate = formatDate(result.creationTime, 'yyyy-MM-dd HH:mm:dd');
                    // var formatSize = formatSize(result.fileSize);
                    $('#file_dialog_upload').form('load', {
                        keyword: result.keyword,
                        fileAbstract: result.fileAbstract,
                        id: result.id,
                        fileId: result.fileId,
                        menuId: result.menuId,
                        fileNamePrefix: result.fileNamePrefix,
                        hashCode: result.hashCode,
                        src: result.src,
                        webPath: result.webPath,
                        status: result.status,
                        //上边是    隐藏属性
                        fileName: result.fileName,
                        fileSize: formatSize(result.fileSize),//大小需要格式化
                        creationTime: formatDate(result.creationTime, 'yyyy-MM-dd HH:mm:dd'),//日期需要格式化
                        // creationTime: result.creationTime,
                        filePath: result.filePath,
                        fileNameSuffix: result.fileNameSuffix,
                        indexName: result.indexName,
                        author: result.author,
                        uploadUser: result.uploadUser,
                        //868.80  920.80 3539.30   960 4499.30    6217 0028 3000 7124 573

                    });
                }
            });

        }


        //文件上传界面保存按钮
        var file_upload_flag = true;//用来防止多次点击发送请求的标记
        function file_dialog_ok() {
            if (file_upload_flag) {
                file_upload_flag = false;

                var str = JSON.stringify($('#file_dialog_upload').serializeJSON());
                console.log(str);
                $.ajax({
                    url: 'file/fileForm',
                    type: 'POST',
                    dataType: 'JSON',
                    // contentType: 'application/json',
                    data: {json: str},
                    success: function (result) {
                        console.log(result);
                        message_Show(result.message);
                        //关闭窗口, 刷新列表
                        // file_dialog_close();
                        // $('#' + treeId).tree('reload');
                        //调用文件解析接口, 后台自动解析
                        if (result.success == false) {
                            return;
                        }
                        // fileSpread(result.data);
                        file_upload_flag = true;
                        //跳转到文件列表页面
                        window.location.href = "./views/resource/knowledgeCenter/knowledgeCenterMultiple.jsp";
                    }
                });
            }
        }

        function mouseEnter() {
            var tabs = $('#tabs').tabs().tabs('tabs');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].panel('options').tab.unbind().bind('mouseenter', {index: i}, function (e) {
                    $('#tabs').tabs('select', e.data.index);
                });
            }
        };

        function file_type() {
            //打开之前加载select
            $('#filetype').combobox({
                url: 'fileType/listFileType',
                method: 'get',
                valueField: 'id',
                textField: 'text',
                panelHeight: 'auto',
                editable: false,
                // readonly: 'true',
                onChange: function () {
                    //选择框值发生改变时

                    $('#filedTable').html('');
                    var getText = $('#filetype').combobox('getText');
                    if (getText == null || getText.length == 0) {
                        return;
                    }
                    console.log(getText);


                    //动态生成表单
                    $.ajax({
                        url: 'file/getFormField?indexName=' + getText,
                        dataType: 'json',
                        success: function (datas) {
                            if (datas.length === 0) {
                                return;
                            }
                            //表单列替换
                            var textHtml = "";
                            var data = datas;
                            for (var i = 0; i < data.length; i++) {
                                var field = data[i];
                                // var ignore = ['content', 'directory', 'discreteTool', 'jsp', 'library', '', 'path', 'type', 'uploadTime', 'lightWeightURL', 'lightWeightConversion'];
                                // if (ignore.indexOf(field.filename) !== -1) {
                                //     continue;
                                // }
                                textHtml += '<tr>';
                                textHtml += '<td class="pe-label" style="width: 40%">' + field.desc + '(' + field.filename + ')</td>';
                                // if (field.filename === 'abstract') {
                                //     textHtml += '<td><input id="' + field.filename + '" name="' + field.filename + '" class="easyui-textbox" style="width:100%;height:25px"  ></td>';
                                // }else {
                                //
                                //     textHtml += '<td><input id="' + field.filename + '" name="' + field.filename + '" class="easyui-textbox" style="width:100%;height:25px"  ></td>';
                                // }
                                textHtml += '<td><input id="' + field.filename + '" name="' + field.filename + '" class="easyui-textbox" style="width:100%;height:25px"  ></td>';
                                textHtml += '</tr>';
                            }
                            // if (temp.length > 0) {
                            //     console.log(temp[0].path);
                            // }

                            $('#filedTable').html(textHtml);
                        }
                    });

                }
            })
        }

        /**
         * 文档提交
         */
        function file_commit() {
            //保存按钮
            alert('提交' == '' ? 'confirm' : '不为空');

        }
    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'center'">
    <div class="easyui-layout" data-options="fit:true">

        <div id="permissionSet_dg_toolbar" data-options="region:'north'">
            <div class="datagrid-title-div"><span>文件详情</span></div>
        </div>
        <div data-options="region:'west'" style="width: 65%;padding-left: 5px">
            <div id="dataParent">
                <%--<div id="dataList">--%>
                <%----%>
                <%----%>
                <%--</div>--%>
                <div class="easyui-tabs" style="width: 100%;">
                    <div title="文件预览" data-options="closable:false" style="overflow:hidden">
                        <iframe id="preSee" scrolling="yes" frameborder="0"
                                src="./../201912102.html"
                                style="width:100%;height:94%;"></iframe>
                    </div>
                </div>
            </div>
        </div>


        <div data-options="region:'east'" style="width:35%">

            <%-- tab页 --%>
            <div data-options="buttons:'#file_dialog_button'">
                <form id="file_dialog_upload" method="post" enctype="multipart/form-data">
                    <%--<input id="menuId" name="menuId" type="hidden">--%>
                    <input id="id" name="id" type="hidden">
                    <input id="fileId" name="fileId" type="hidden">
                    <input id="fileNamePrefix" name="fileNamePrefix" type="hidden">
                    <input id="hashCode" name="hashCode" type="hidden">
                    <input id="src" name="src" type="hidden">
                    <input id="webPath" name="webPath" type="hidden">
                    <input id="status" name="status" type="hidden">
                    <%--<input id="filePath" name="filePath" type="hidden">--%>


                    <div id="tabs" class="easyui-tabs" data-options="tools:'#tab-tools'" style="width:100%;height:85%">
                        <div title="基本属性" style="padding:10px;">
                            <table cellspacing="10" class="pxzn-dialog-font" style="margin: auto;" width='100%'>
                                <%--<tr>--%>
                                <%--<td class="pe-label" style="width: 40%" colspan="2">--%>
                                <%--<input id="file" name="file" type="file" style="width:100%; text-align: center"--%>
                                <%--onchange="file_upload_pre()">--%>
                                <%--</td>--%>
                                <%--</tr>--%>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文件名称:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="fileName" class="easyui-textbox"
                                               style="width:90%;padding-left: 5px;"
                                               name="fileName"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文件大小:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="fileSize" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="fileSize"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            上传时间:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="creationTime" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="creationTime"/>
                                        <%--<input class="easyui-datebox" style="width:90%;" name="creationTime"--%>
                                        <%--data-options="formatter:myformatter,parser:myparser" >--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文件暂存路径 :
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="filePath" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="filePath"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文档类型:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="fileNameSuffix" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="fileNameSuffix"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                             所属文件库:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input class="easyui-textbox" readonly style="width:90%;padding-left: 5px;"
                                               name="indexName"/>
                                        <%--<input id="indexName" class="easyui-combobox" editable="false"--%>
                                        <%--style="width:90%;" readonly--%>
                                        <%--name="indexName"/>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                             上传人员:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input class="easyui-textbox" readonly style="width:90%;padding-left: 5px;"
                                               name="uploadUser"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                             状态:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input class="easyui-textbox" readonly style="width:90%;padding-left: 5px;"
                                               name="status"/>
                                    </td>
                                </tr>

                            </table>
                        </div>
                        <div title="关键词和摘要" data-options="tools:'#tab-tools',closable:false"
                             style="padding:10px;width:100%;height:100%">
                            <table cellspacing="10" class="pxzn-dialog-font" style="margin: auto;" width='100%'>
                                <tr>
                                    <td class="pe-content" colspan="6" aria-colspan="2">
                                        <input id="keyword" label="关键词:" labelPosition="top" class="easyui-textbox"
                                               style="width:90%;height:120px" multiline="true"
                                               name="keyword"/>
                                    </td>
                                </tr>
                                <tr>
                                    <%--<td class="pe-label" style="width: 40%">--%>
                                    <%--摘要--%>
                                    <%--</td>--%>
                                    <td class="pe-content" colspan="6" aria-colspan="2">
                                        <input id="fileAbstract" label="摘要:" labelPosition="top" class="easyui-textbox"
                                               style="width:90%;height:120px" multiline="true"
                                               name="fileAbstract"/>
                                    </td>
                                </tr>

                            </table>
                        </div>
                        <div title="其他属性" data-options="closable:false" style="padding:10px">

                            <table cellspacing="10" class="pxzn-dialog-font" style="margin: auto;" width='100%'>
                                <tr>
                                    <td class="pe-label" style="width: 40%">
                                        <span style="font-size: 15px;">
                                            选择文档类型
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="filetype" class="easyui-combobox" style="width:100%;"
                                               name="filetype"/>
                                    </td>
                                </tr>
                            </table>

                            <table id="filedTable" cellspacing="10" class="pxzn-dialog-font" style="margin: auto;"
                                   width='100%'>
                            </table>
                        </div>
                    </div>
                </form>
                <div id="file_dialog_button" class="pxzn-dialog-buttons">
                    <input type="button" onclick="file_dialog_ok()" value="保存" class="pxzn-button">
                    <input type="button" onclick="file_commit()" value="提交" style="margin-left:80px;"
                           class="pxzn-button">
                </div>
            </div>


        </div>


    </div>
</div>
</body>
</html>
