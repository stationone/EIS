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
            var h = 300;
            var w = 350;
            if (typeof(height) != "undefined") {
                h = height;
            }

            if (typeof(width) != "undefined") {
                w = width;
            }

            //初始化保存窗口
            $('#saveIndexDlg').dialog({
                title: '创建索引库',//窗口标题
                width: w,//窗口宽度
                // height: 100,//窗口高度
                closed: true,//窗口是是否为关闭状态, true：表示关闭
                modal: true//模式窗口
            });

            $('#saveDocumentDlg').dialog({
                title: '新增',//窗口标题
                width: w,//窗口宽度
                //height: 100,//窗口高度
                closed: true,//窗口是是否为关闭状态, true：表示关闭
                modal: true//模式窗口
            });
            $('#updateDocumentDlg').dialog({
                title: '更新',//窗口标题
                width: w,//窗口宽度
                //height: 100,//窗口高度
                closed: true,//窗口是是否为关闭状态, true：表示关闭
                modal: true//模式窗口
            });
            $('#saveFiledDlg').dialog({
                title: '新增',//窗口标题
                width: w,//窗口宽度
                //height: 100,//窗口高度
                closed: true,//窗口是是否为关闭状态, true：表示关闭
                modal: true//模式窗口
            });

            /**
             * createMapping的表单提交
             * 2019年10月15日
             */
            $('#btnSaveFiled').bind('click', function () {
                //提取下拉框选项
                //提交表单
                $('#saveFiled').form('submit', {
                    url: 'fileBase/save',
                    type: 'post',
                    onSubmit: function () {
                        // do some checked
                        //做表单字段验证，当所有字段都有效的时候返回true。该方法使用validatebox(验证框)插件。
                        var isValid = $('#saveFiled').form('validate');
                        if (isValid == false) {
                            return;
                        }
                        // return false to prevent submit;
                    },
                    success: function (data) {
                        var data = eval('(' + data + ')');
                        $.messager.alert("提示", data.message, 'info', function () {
                            //成功的话，我们要关闭窗口
                            $('#saveFiledDlg').dialog('close');
                            //刷新表格数据
                            $("#mygrid").datagrid('reload');
                        });
                    }
                });
            });

            //获取树
            getTree();
        });

        function getTree() {
            $('#' + treeId).tree({
                    url: 'fileType/listFileType',
                    method: "GET",
                    checkbox: false,
                    multiple: false,
                    onClick: function (node) {
                        loadDataList(node.text);
                    },
                    onLoadSuccess: function (node, data) {
                        //什么都不干

                        if (data.length > 0) {
                            //找到第一个元素
                            var n =  $('#' + treeId).tree('find', data[0].id);
                            //调用选中事件
                            $('#' + treeId).tree('select', n.target);

                        }
                        loadDataList(n.text);
                    }
                }
            );
        }

        /**
         * 获取数据
         */
        function loadDataList(text) {
            /**
             * 获取基础字段的数据, 展示数据网格
             */
            $('#mygrid').datagrid({
                url: "fileBase/fileBaseList?indexName=" + text, // 索引信息
                type: "POST",
                dataType: 'json',
                contentType: "application/json",
                columns: [[
                    {field: 'filename', title: '字段名称', width: 180, align: 'center'},
                    {field: 'type', title: '类型', width: 180, align: 'center'},
                    {field: 'scope', title: '取值范围', width: 180, align: 'center'},
                    {field: 'desc', title: '备注', width: 180, align: 'center'},
                    {field: 'indexName', title: '索引库名称', width: 180, align: 'center'}
                ]],
                rownumbers: true,
                title: '自定义扩展字段名称信息',
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                striped: true,
                // pagination: true,
                loading: true,
                emptyMsg: "没有获取到数据",
                loadMsg: "正在努力加载数据,表格渲染中...",
                onLoadSuccess: function (data) {

                },
                onLoadError: function () {
                    clearDataGrid();
                }
            });

        }

        /**
         * 清空添加字段的表单项
         */
        function addField() {
            var treeNode = $('#' + treeId).tree('getSelected');
            if (treeNode == null)
                $.messager.alert('提示消息', '请先选择索引！');
            else {
            $('#saveFiled').form('clear');
            //加载数据
            $('#saveFiled').form('load', {indexName: treeNode.text});
            $('#saveFiledDlg').dialog('open');
            }
        }

        /**
         * 编辑
         */
        function updateField() {
            var gridNode = $('#mygrid').datagrid('getSelected');
            console.log(gridNode);
            if (gridNode == null) {
                $.messager.alert('提示消息', '请先选择一行数据！');
            } else {
                $('#saveFiled').form('clear');
                //加载数据
                $('#saveFiled').form('load', gridNode);
                // $('#updateDocument').form('clear');
                $('#saveFiledDlg').dialog('open');
            }
        }

        /**
         * 删除
         */
        function deleteField() {
            var gridNode = $('#mygrid').datagrid('getSelected');
            if (gridNode == null) {
                $.messager.alert('提示消息', '请先选择一行数据！');
            } else {
                $.messager.confirm("确认", "确认要删除吗？", function (yes) {
                    if (yes) {
                        $.ajax({
                            url: 'fileBase/deleteField?id=' + gridNode.id,
                            dataType: 'json',
                            type: 'post',
                            success: function (data) {
                                //var data = eval('(' + data + ')');
                                $.messager.alert("提示", data.message, 'info', function () {
                                    //刷新表格数据
                                    // loadGrid();
                                    $('#mygrid').datagrid('reload');
                                });
                            }
                        });
                    }
                });
            }


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
         * 提交目录表单 创建新的类型
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
             onclick="$('#mygrid').datagrid('reload');" title="刷新">
        <img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="addField()" title="添加字段">
        <img src="images/px-icon/bianji.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="updateField()" title="编辑字段">
        <%--<img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"--%>
        <%--onclick="addDocument()" title="新增数据">--%>
        <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="deleteField()" title="删除字段">
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
<div id="saveFiledDlg">
    <form id="saveFiled" method="post">
        <table>
            <tr>
                <%--<td>id</td>--%>
                <td><input name="id" class="easyui-validatebox"
                           data-options="" type="hidden"></td>
            </tr>
            <tr>
                <td>字段名称</td>
                <td><input name="filename" class="easyui-validatebox"
                           data-options="required:false,missingMessage:'字段名称不能为空!'"></td>
            </tr>
            <tr>
                <td>字段类型</td>
                <td><input name="type" class="easyui-validatebox"
                           data-options="required:false,missingMessage:'字段类型不能为空!'"></td>
            </tr>

            <tr>
                <td>取值范围</td>
                <td><input name="scope" class="easyui-validatebox"
                           data-options="required:false,missingMessage:''"></td>
            </tr>

            <tr>
                <td>备注</td>
                <td><input name="desc" class="easyui-validatebox"
                           data-options="required:false,missingMessage:''"></td>
            </tr>
            <tr>
                <%--<td>索引库名称</td>--%>
                <td><input name="indexName" class="easyui-validatebox"
                           data-options="required:false,missingMessage:''" type="hidden"></td>
            </tr>
        </table>
        <button id="btnSaveFiled" type="button">保存</button>
    </form>
</div>
</body>
</html>
