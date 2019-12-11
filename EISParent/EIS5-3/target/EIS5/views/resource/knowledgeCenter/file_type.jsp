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
            getTree();
        });

        function getTree() {
            $('#' + treeId).tree({
                    url: 'fileType/listFileType',
                    method: "GET",
                    checkbox: false,
                    multiple: false,
                    onClick: function (node) {
                        loadDataList(node.id);
                    },
                    onLoadSuccess: function (node, data) {
                        //什么都不干

                        if (data.length > 0) {
                            //找到第一个元素
                            var n =  $('#' + treeId).tree('find', data[0].id);
                            //调用选中事件
                            $('#' + treeId).tree('select', n.target);

                        }
                        loadDataList(n.id);
                    }
                }
            );
        }

        /**
         * 获取数据
         */
        function loadDataList(id) {
            /**
             * 获取基础字段的数据, 展示数据网格
             */
            $('#mygrid').datagrid({
                url: "fileType/fileTypeList?id=" + id, // 索引信息
                type: "POST",
                dataType: 'json',
                contentType: "application/json",

                columns: [[
                    {field: 'filename', title: '字段名称', width: 180, align: 'center'},
                    {field: 'type', title: '类型', width: 180, align: 'center'},
                    {field: 'scope', title: '取值范围', width: 180, align: 'center'},
                    {field: 'desc', title: '备注', width: 180, align: 'center'}
                ]],
                rownumbers: true,
                title: '映射字段名称信息',
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                striped: true,
                // pagination: true,
                loading: true,
                emptyMsg: "没有获取到数据",
                loadMsg: "正在努力加载数据,表格渲染中...",
                onLoadSuccess: function (data) {
                    // // alert("加载完成");
                    // $("a[name='opera']").linkbutton({text: '预览', plain: true, iconCls: '/images/px-icon/yulan.png'});
                },
                onLoadError: function () {
                    clearDataGrid();
                }
            });

        }

        /**
         * 数据展示
         */
        function dataShow(result) {
            if (result === null) {
                return;
            }
            //清除
            $('#dataList').remove();
            //创建
            $('#dataParent').append('<ul id="dataList">\n' +
                '        <%--正文内容--%>\n' +
                '    </ul>');
            //遍历
            var data = result.rows;

            for (var i = 0; i < result.total; i++) {
                var time = data[i].creationTime;
                //格式化日期
                var dateFormat = formatDate(time, 'yyyy-MM-dd HH:mm:ss');
                //作者
                var author = data[i].authorName == null ? '佚名' : data[i].authorName;
                //正文
                var content = data[i].content == null ? '' : data[i].content;
                //文件名
                var filename = data[i].fileName == null ? '' : data[i].fileName;
                //关键词
                var keyword = data[i].keyword == null ? '' : data[i].keyword;

                var pageNO = data[i].pageNO == null ? '' : data[i].pageNO;

                var fileId = '\'' + data[i].fileId + '\'';
                //文档路径
                var pdfFilePath = data[i].pdfFilePath == null ? 'javaScript:void(0)' : data[i].pdfFilePath;
                $('#dataList').append(' <li value="' + i + '">\n' +
                    '            <dt>\n' +
                    '                <p class="fl">\n' +
                    '                    <a onclick="file_show(' + fileId + ', ' + pageNO + ')" href="javaScript:void(0)"\n' +
                    '                       title="' + filename + '" style="font-size: 15px">\n' +
                    '                        ' + filename + '\n' +
                    '                    </a>\n' +
                    '                </p>\n' +
                    '                <p style="color: grey;font-size: 5px;" class="fr">关键词:\n' +
                    '                    <span class="score">' + keyword + '</span>\n' +
                    '                </p>\n' +
                    '            </dt>\n' +
                    '            <dt class="fl">\n' +
                    '                <p style="font-size: 10px">' + content + '</p>\n' +
                    '                <div style="color: grey;font-size: 5px;">\n' +
                    '                    ' + dateFormat + '\n' +
                    '                    <i> &nbsp;&nbsp;&nbsp; </i>   ' + pageNO + '|' + data[i].pageTotal + '页<i>&nbsp;&nbsp;&nbsp;</i>' + data[i].downloadCount + '次下载<i>&nbsp;&nbsp;&nbsp; </i>\n' +
                    '                    作者：<span href="#">\n' +
                    '                    ' + author + '\n' +
                    '                </span>\n' +
                    '                </div>\n' +
                    '            </dt>\n' +
                    '        </li>');
            }

        }

        /**
         * 打开文件上传窗口
         */
        //打开
        function upload_dialog_open() {
            var node = $('#' + treeId).tree('getSelected');
            if (node == null) {
                message_Show('请选择要上传的目录');
                return;
            }
            $('#file_dialog_form').form('clear');
            $('#file_dialog_form').form('load', {
                menuId: node.id

            });
            console.log(node.id);
            $('#file_dialog').dialog('open').dialog('center').dialog('setTitle', '文件上传');
        }


        /*清除数据表格中的数据*/
        function clearDataGrid() {
            //获取当前页的记录数
            var item = $("#mygrid").datagrid('getRows');
            for (var i = item.length - 1; i >= 0; i--) {
                var index = $("#mygrid").datagrid('getRowIndex', item[i]);
                $("#mygrid").datagrid('deleteRow', index);
            }
        }

        /**
         * 新建目录
         */
        //打开
        function newFolder() {
            $('#folder_dialog_form').form('clear');
            $('#folder_dialog_form').form('load', {});
            $('#folder_dialog').dialog('open').dialog('center').dialog('setTitle', '创建类型');
        }

        /**
         * 编辑目录
         */
        //打开
        function editFolder() {
            // $('#saveFolder-button').linkbutton('enable');
            var node = $('#' + treeId).tree('getSelected');
            if (node == null) {
                message_Show('请选择有效的目录');
                return;
            }
            $('#folder_dialog_form').form('clear');
            $('#folder_dialog_form').form('load', {
                id: node.id,
                text: node.text,
                typeName: node.text
            });
            $('#folder_dialog').dialog('open').dialog('center').dialog('setTitle', '编辑文件夹');
        }

        /**
         * 删除选中的目录及其目录下的所有数据
         */
        function deleteFolder() {
            var node = $('#' + treeId).tree('getSelected');
            if (node == null) {
                message_Show('请选择有效的目录');
                return;
            }
            //如果选择的是根节点,
            if (('000000000000000000') === (node.pid)) {
                message_Show('当前节点禁止删除, 请重新选择');
                return;
            }

            $.messager.confirm('系统提示', '此操作会删除该目录下所有数据, 请确认是否删除 <span style="color: red">' + node.text + '</span> ?', function (r) {
                if (r) {
                    $.ajax({
                        type: 'POST',
                        url: 'fileType/delete',
                        dataType: 'JSON',
                        data: {id: node.id},
                        success: function (data) {
                            message_Show(data.message);
                            $('#' + treeId).tree('reload');
                        },
                        error: function () {
                            serverError();
                        }
                    })
                }
            });

        }

        /**
         * 获取树节点
         * 根节点id
         */
        function getParent(node) {
            var rootNode = $('#' + treeId).tree('getParent', node.target);
            if (rootNode == null) {
                return node;
            }
            return getParent(rootNode);
        }

        /**
         * 提交目录表单
         */
        var isClick = true;//用来防止多次点击发送请求

        function folder_dialog_ok() {
            if (isClick) {
                isClick = false;
                //提交表单事件
                // console.log($(this).attr("data-val"));
                $("#folder_dialog_form").form("submit", {
                    url: "fileType/submit",
                    onSubmit: function () {
                        // if ($(this).form("validate")) {
                        //     $('#saveFolder-button').linkbutton('disable');
                        // }
                        return $(this).form("validate");
                    },
                    success: function (result) {
                        // console.log(result);
                        var data = JSON.parse(result);
                        // alert(data.message);
                        message_Show(data.message);
                        // console.log(data);
                        folder_dialog_close();
                        $('#' + treeId).tree('reload');
                        isClick = true;
                    },
                    error: function () {
                        $.messager.alert("系统提示", "异常，请重新的登录后尝试!");
                    }
                });
                console.log("submit");
            }
            console.log("1");
        }


        //取消
        function folder_dialog_close() {
            $('#folder_dialog').dialog('close');
        }

        //文件上传界面保存按钮
        function file_dialog_ok() {
            if (isClick) {
                isClick = false;

                //组装数据
                var formData = new FormData();
                var node = $('#' + treeId).tree('getSelected');
                var menuId = node.id;
                formData.append('file', $('#file')[0].files[0]);
                formData.append('menuId', menuId);
                formData.append('keyword', $('#keyword').val());

                // console.log(formData);

                //提交表单
                $.ajax({
                    url: 'file/fileUpload',
                    processData: false, //因为data值是FormData对象，不需要对数据做处理。
                    contentType: false,
                    cache: false,
                    type: 'POST',
                    data: formData,
                    success: function (result) {
                        console.log(result);
                        message_Show(result.message);
                        //关闭窗口, 刷新列表
                        file_dialog_close();
                        // $('#' + treeId).tree('reload');

                        //调用文件解析接口, 后台自动解析
                        fileSpread(result.data);
                    }
                });
                //定时器
                setTimeout(function () {
                    isClick = true;
                }, 1000);//一秒内不能重复点击
            }
        }

        //取消
        function file_dialog_close() {
            $('#file_dialog').dialog('close');
        }
    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">

    <div class="layout-title-div">
        资源目录
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('permissionSet_layout','west')"
             class="layout-title-img">
    </div>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px"
                 class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#'+treeId).tree('reload')" title="刷新">
            <img src="images/px-icon/newFolder.png" style="padding:0 10px"
                 class="easyui-tooltip div-toolbar-img-next"
                 onclick="newFolder()" title="添加">
            <img src="images/px-icon/editFolder.png" style="padding:0 10px"
                 class="easyui-tooltip div-toolbar-img-next"
                 onclick="editFolder()" title="编辑">
            <img src="images/px-icon/deleteFolder.png" style="padding:0 10px"
                 class="easyui-tooltip div-toolbar-img-next"
                 onclick="deleteFolder()" title="删除">
        </div>
    </div>
    <jsp:include page="/px-tool/px-tree.jsp">
        <jsp:param value="<%=treeId%>" name="div-id"/>
    </jsp:include>
</div>
<div data-options="region:'center'">
    <div id="permissionSet_dg_toolbar">
        <div>
            <span class="datagrid-title-div" id="indexName">
            </span>
            <span class="datagrid-title-div" id="index">
            </span>
            <span class="datagrid-title-div" id="menu">
            </span>
        </div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#'+datagridId1).datagrid('reload');" title="刷新">
        <img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="upload_dialog_open()" title="上传文件">
        <img src="images/px-icon/deleteFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="deleteFile()" title="删除文件">

        <%-- 搜索框 --%>
        <a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton"
           style="float: right;margin-top: 8px;margin-right: 20px;width:80px" onclick="searchFile()">查询文档</a>
        <input id="search" class="div-toolbar-span" style="float: right;margin-top: 8px;width:200px;height:25px"/>

    </div>
    <table id="mygrid" style="height: 450px"></table>


</div>
<%-- 弹出对话框 --%>
<%--目录表单--%>
<div id="folder_dialog" class="easyui-dialog"
     data-options="closed:true, modal:true,border:'thin', buttons:'#folder_dialog_button'">
    <form id="folder_dialog_form" method="post" novalidate>
        <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;">
            <input name="pid" type="hidden">
            <input name="id" type="hidden">
            <input name="indexName" type="hidden">
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
</body>
</html>
