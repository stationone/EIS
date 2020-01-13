<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-17
  Time: 14:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String treeId = "pxTool-tree";
    String datagridId1 = "res_datagrid";
    String datagridId2 = "download_datagrid";
    String toolbar = "toolbar";


%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>搜索界面</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script type="text/javascript" src="ui/jquery.min.js"></script>
    <script type="text/javascript" src="ui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="ui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script>

        /**
         * 加载数据
         * @param text
         */
        function loadGrid(text) {
            $.ajax({
                // url: "elasticsearch/getTitle?indexName=" + text, //更改了请求路径
                url: "elasticsearch/getTitle?indexName=" + text, // 获取列名
                type: "GET",
                dataType: 'json',
                success: function (title) {
                    //获取表头数据成功后，使用easyUi的datagrid去生成表格
                    $('#mygrid').datagrid({
                        url: "elasticsearch/getList?indexName=" + text, //更改了请求路径
                        method: "GET",
                        contentType: "application/json",
                        columns: title,//外层ajax请求的表头json
                        pagination: true,
                        title: '数据列表',
                        rownumbers: true,
                        singleSelect: true,
                        collapsible: true,
                        nowrap: true,
                        striped: true,
                        loading: true,
                        pageNumber: 1,
                        pageSize: 10,
                        pageList: [10, 20, 30, 40, 50],
                        loadMsg: "正在努力加载数据,表格渲染中...",
                        singleSelect: true
                    });
                },
                error: function (e) {
                    // console.log(e);
                }
            });
        }

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
                title: '新增',//窗口标题
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
             *加载索引列表的树形菜单,
             *  加载完成后, 选中第一条数据
             */
            $('#tt').tree({
                url: 'elasticsearch/getIndexList',
                method: 'get',
                onClick: function (node) {
                    //alert(node.text)
                    loadGrid(node.text);
                    //$('#mygrid').datagrid('reload');
                    document.getElementById("indexName").innerHTML = "";
                    //将索引名称显示在顶部
                    $('#indexName').append('<span>'+node.text+'</span>')
                },
                //加载完tree型菜单后, 选中第一条数据
                onLoadSuccess: function (node, data) {
                    if (data.length > 0) {
                        //找到第一个元素
                        var n = $('#tt').tree('find', data[0].id);
                        //调用选中事件
                        $('#tt').tree('select', n.target);
                        loadGrid(data[0].text);
                        //将索引库名称显示在顶部
                        document.getElementById("indexName").innerHTML = "";
                        $('#indexName').append('<span>'+data[0].text+'</span>')
                    }
                }
            });

            /**
             * createIndex的表单提交, 改了url请求地址
             * 2019年10月15日
             */
            $('#btnSaveIndex').bind('click', function () {
                //把表单数据转换成json对象
                var data = JSON.stringify($('#saveIndex').serializeJSON());
                $('#saveIndex').form('submit', {
                    url: 'elasticsearch/createIndex',
                    type: 'post',
                    onSubmit: function () {
                        // do some checked
                        //做表单字段验证，当所有字段都有效的时候返回true。该方法使用validatebox(验证框)插件。
                        var isValid = $('#saveIndex').form('validate');
                        if (isValid == false) {
                            return;
                        }
                        // return false to prevent submit;
                    },
                    success: function (data) {
                        var data = eval('(' + data + ')');
                        $.messager.alert("提示", data.message, 'info', function () {
                            //成功的话，我们要关闭窗口
                            $('#saveIndexDlg').dialog('close');
                            //刷新表格数据
                            $('#tt').tree('reload');
                        });
                    }
                });
            });

            /**
             * insert字段的表单提交, 改了url请求地址
             * 2019年10月15日
             */
            $('#btnSaveFiled').bind('click', function () {
                //提取下拉框选项
                var treeNode = $('#tt').tree('getSelected');
                //提交表单
                $('#saveFiled').form('submit', {
                    // url: 'column/addFiled',
                    url: 'elasticsearch/createMapping',
                    //queryParams:'{indexName :' +treeNode.indexName+'}',
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
                            //$('#tt').tree('reload');
                        });
                    }
                });
            });

            /**
             * 点击保存数据按钮函数
             */
            $('#btnSaveDocument').bind('click', function () {
                var isValid = $('#saveDocument').form('validate');
                if (isValid == true) {
                    var treeNode = $('#tt').tree('getSelected');
                    //var json = $('#saveDocument').serializeJSON();
                    var data = JSON.stringify($('#saveDocument').serializeJSON());
                    // console.log(data);
                    $.ajax({
                        url: 'elasticsearch/addDocument',
                        dataType: 'json',
                        type: 'post',
                        data: {json: data, indexName: treeNode.text},
                        success: function (data) {
                            //var data = eval('(' + data + ')');
                            $.messager.alert("提示", data.message, 'info', function () {
                                //成功的话，我们要关闭窗口
                                $('#saveDocumentDlg').dialog('close');

                                //刷新数据
                                //alert(treeNode.text);
                                loadGrid(treeNode.text);
                                $('#mygrid').datagrid('reload');
                            });
                        }
                    });
                }
            });
            $('#btnSearch').bind('click', function () {
                //把表单数据转换成json对象
                // var str = JSON.stringify($('#searchForm').serializeJSON());
                //获取input中的值
                var search = document.getElementById('search').value;

                //$('#searchForm').form('clear');
                //alert(str);
                //console.log(JSON.stringify($('#searchForm').serializeJSON()));
                $('#mygrid').datagrid('reload', {json: JSON.stringify({search:search})});
            });

            $('#btnUpdateDocument').bind('click', function () {
                var isValid = $('#updateDocument').form('validate');
                if (isValid == true) {
                    var treeNode = $('#tt').tree('getSelected');
                    var data = JSON.stringify($('#updateDocument').serializeJSON());
                    var gridNode = $('#mygrid').datagrid('getSelected');
                    // console.log(gridNode);
                    $.ajax({
                        url: 'elasticsearch/updateDocument',
                        dataType: 'json',
                        type: 'post',
                        data: {json: data, indexName: treeNode.text, id: gridNode.id},
                        success: function (data) {
                            //var data = eval('(' + data + ')');
                            $.messager.alert("提示", data.message, 'info', function () {
                                //成功的话，我们要关闭窗口
                                $('#updateDocumentDlg').dialog('close');

                                //刷新数据
                                //alert(treeNode.text);
                                loadGrid(treeNode.text);
                                $('#mygrid').datagrid('reload');
                            });
                        }
                    });
                }
            });

        });

        /**
         * 删除文档
         */
        function deleteDocument() {
            var treeNode = $('#tt').tree('getSelected');
            var gridNode = $('#mygrid').datagrid('getSelected');
            if (treeNode == null)
                $.messager.alert('提示消息', '请先选择索引！');
            else if (gridNode == null) {
                $.messager.alert('提示消息', '请先选择一行数据！');
            } else {
                $.messager.confirm("确认", "确认要删除吗？", function (yes) {
                    if (yes) {
                        //var treeNode = $('#tt').tree('getSelected');
                        //var gridNode = $('#mygrid').datagrid('getSelected');
                        //console.log(treeNode);
                        //console.log(gridNode);
                        $.ajax({
                            url: 'elasticsearch/deleteDocument?indexName=' + treeNode.text + "&type=" + gridNode.type + "&gridId=" + gridNode.id,
                            dataType: 'json',
                            //type: 'post',
                            success: function (data) {
                                //var data = eval('(' + data + ')');
                                $.messager.alert("提示", data.message, 'info', function () {
                                    //刷新表格数据
                                    loadGrid(treeNode.text);
                                    $('#mygrid').datagrid('reload');
                                });
                            }
                        });
                    }
                });
            }
        }

        /**
         * 添加数据
         */
        function addDocument() {
            var treeNode = $('#tt').tree('getSelected');
            if (treeNode == null)
                $.messager.alert('提示消息', '请先选择索引！');
            else {
                $.ajax({
                    url: 'elasticsearch/getTitle?indexName=' + treeNode.text,
                    dataType: 'json',
                    //type: 'post',
                    success: function (datas) {
                        $('#saveDocument').form('clear');
                        var textHtml = "";
                        var data = datas[0];
                        for (var i = 0; i < data.length; i++) {
                            var field = data[i];
                            textHtml += '<tr>';
                            textHtml += '<td><span class="pxzn-span-four">' + field.field + '</span>:</td>';
                            textHtml += '<td><input name="' + field.field + '" class="easyui-textbox pxzn-dialog-text" data-options="required:true"></td>';
                            textHtml += '</tr>';
                        }
                        $('#filedTable').html(textHtml);
                        $('#saveDocumentDlg').dialog('open');
                    }
                });

            }
        }

        /**
         * 编辑文档
         */
        function updateDocument() {
            var treeNode = $('#tt').tree('getSelected');
            var gridNode = $('#mygrid').datagrid('getSelected');
            if (treeNode == null)
                $.messager.alert('提示消息', '请先选择索引！');
            else if (gridNode == null) {
                $.messager.alert('提示消息', '请先选择一行数据！');
            } else {
                $.ajax({
                    url: 'elasticsearch/getTitle?indexName=' + treeNode.text,
                    dataType: 'json',
                    //type: 'post',
                    success: function (datas) {
                        var textHtml = "";
                        var data = datas[0];
                        for (var i = 0; i < data.length; i++) {
                            var field = data[i];
                            textHtml += '<tr>';
                            textHtml += '<td><span class="pxzn-span-four">' + field.field + '</span>:</td>';
                            textHtml += '<td><input name="' + field.field + '" class="easyui-textbox pxzn-dialog-text" data-options="required:true"></td>';
                            textHtml += '</tr>';
                        }
                        $('#updateTable').html(textHtml);
                        $('#updateDocument').form('clear');
                        //加载数据
                        $('#updateDocument').form('load', gridNode);
                        // $('#updateDocument').form('clear');
                        $('#updateDocumentDlg').dialog('open');
                    }
                });

            }
        }
    </script>
</head>
<body id="resource_admin_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        文档库
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('resource_admin_layout','west')"
             class="layout-title-img">
    </div>
    <%--操作栏--%>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#tt').tree('reload');" title="刷新">
        </div>
    </div>

    <div id="nav">
        <ul id="tt"></ul>

    </div>
    <%--树目录--%>
    <%--<jsp:include page="/px-tool/px-tree.jsp">
        <jsp:param value="<%=treeId%>" name="div-id"/>
    </jsp:include>--%>

</div>


<div data-options="region:'center'">
    <div id="toolbar">
        <div class="datagrid-title-div" id="indexName">
            <%--<span>资源列表</span>--%>
        </div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#mygrid').datagrid('reload')" title="刷新">
        <%--<img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"--%>
        <%--onclick="addFiled()" title="新增字段及映射">--%>
        <img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="addDocument()" title="新增文档">
        <img src="images/px-icon/bianji.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="updateDocument()" title="编辑文档">
        <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="deleteDocument()" title="删除文档">

        <%-- 搜索框 --%>
        <a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton" style="float: right;margin-top: 8px;margin-right: 20px;width:80px">Search</a>
        <input id="search" class="div-toolbar-span" style="float: right;margin-top: 8px;width:200px;height:25px"/>
    </div>

    <table id="mygrid" style="height: 450px"></table>

</div>
</div>

<div id="saveIndexDlg">
    <form id="saveIndex" method="post">
        <table>
            <tr>
                <td>索引名称</td>
                <td><input name="indexName" class="easyui-validatebox"
                           data-options="required:true,missingMessage:'索引名称不能为空!'"></td>
            </tr>
            <tr>
                <td>分片数</td>
                <td><input name="shardNum" class="easyui-validatebox"
                           data-options="required:false,missingMessage:'默认是5'"></td>
            </tr>
            <tr>
                <td>副本数</td>
                <td><input name="replicaNum" class="easyui-validatebox"
                           data-options="required:false,missingMessage:'默认是1'"></td>
            </tr>

        </table>
        <button id="btnSaveIndex" type="button">保存</button>
    </form>
</div>

<div id="saveDocumentDlg">
    <form id="saveDocument" method="post">
        <table id="filedTable">
        </table>
        <button id="btnSaveDocument" type="button">保存</button>
    </form>
</div>
<div id="updateDocumentDlg">
    <form id="updateDocument" method="post">
        <%--<input name="id" class="easyui-validatebox" readonly="true" hidden="hidden">--%>
        <table id="updateTable">
        </table>
        <button id="btnUpdateDocument" type="button">保存</button>
    </form>
</div>

<div id="saveFiledDlg">
    <form id="saveFiled" method="post">
        <table>
            <tr>
                <td>索引名称</td>
                <td><input name="indexName" class="easyui-validatebox"
                           data-options="required:true,missingMessage:'索引名称不能为空!'" readonly="true"></td>
            </tr>
            <tr>
                <td>字段名称</td>
                <td><input name="filedName" class="easyui-validatebox"
                           data-options="required:true,missingMessage:'字段名称不能为空!'"></td>
            </tr>

            <tr>
                <td>字段类型</td>
                <td><input name="filedType" class="easyui-validatebox"
                           data-options="required:true,missingMessage:'不懂就填text!'"></td>
            </tr>
            <tr>
                <td>是否可检索</td>
                <td><select id="isIndex" class="easyui-combobox" data-options="required:true,editable:false"
                            name="isIndex"
                            style="width:200px;" panelHeight="50">
                    <option value="1">是</option>
                    <option value="0" selected="selected">否</option>
                </select></td>
            </tr>
            <tr>
                <td>是否分词</td>
                <td><select id="isSplit" class="easyui-combobox" data-options="required:true,editable:false"
                            name="isSplit"
                            style="width:200px;" panelHeight="50">
                    <option value="1">是</option>
                    <option value="0" aria-selected="true">否</option>
                </select></td>
            </tr>
            <tr>
                <td>存储分词方式</td>
                <td><select id="ikSave" class="easyui-combobox"
                            data-options="required:false,editable:false,missingMessage:'不分词可以不选择'"
                            name="ikSave"
                            style="width:200px;" panelHeight="50">
                    <option value="ik_max_word" aria-checked="true">ik_max_word</option>
                    <option value="ik_smart">ik_smart</option>
                    <option value="default">default</option>
                </select></td>
            </tr>
            <tr>
                <td>搜索分词方式</td>
                <td><select id="ikSearch" class="easyui-combobox"
                            data-options="required:false,editable:false,missingMessage:'不分词可以不选择'"
                            name="ikSearch"
                            style="width:200px;" panelHeight="50">
                    <option value="ik_max_word">ik_max_word</option>
                    <option value="ik_smart" aria-selected="true">ik_smart</option>
                    <option value="default">default</option>
                </select></td>
            </tr>

        </table>
        <button id="btnSaveFiled" type="button">保存</button>
    </form>
</div>

</body>

</html>
