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
    <%--<script>--%>
        <%--/**--%>
         <%--* 入口函数--%>
         <%--*/--%>
        <%--$(function () {--%>
            <%--var h = 300;--%>
            <%--var w = 350;--%>
            <%--if (typeof(height) != "undefined") {--%>
                <%--h = height;--%>
            <%--}--%>

            <%--if (typeof(width) != "undefined") {--%>
                <%--w = width;--%>
            <%--}--%>

            <%--//初始化保存窗口--%>
            <%--$('#saveIndexDlg').dialog({--%>
                <%--title: '创建索引库',//窗口标题--%>
                <%--width: w,//窗口宽度--%>
                <%--// height: 100,//窗口高度--%>
                <%--closed: true,//窗口是是否为关闭状态, true：表示关闭--%>
                <%--modal: true//模式窗口--%>
            <%--});--%>

            <%--$('#saveDocumentDlg').dialog({--%>
                <%--title: '新增',//窗口标题--%>
                <%--width: w,//窗口宽度--%>
                <%--//height: 100,//窗口高度--%>
                <%--closed: true,//窗口是是否为关闭状态, true：表示关闭--%>
                <%--modal: true//模式窗口--%>
            <%--});--%>
            <%--$('#updateDocumentDlg').dialog({--%>
                <%--title: '更新',//窗口标题--%>
                <%--width: w,//窗口宽度--%>
                <%--//height: 100,//窗口高度--%>
                <%--closed: true,//窗口是是否为关闭状态, true：表示关闭--%>
                <%--modal: true//模式窗口--%>
            <%--});--%>
            <%--$('#saveFiledDlg').dialog({--%>
                <%--title: '新增',//窗口标题--%>
                <%--width: w,//窗口宽度--%>
                <%--//height: 100,//窗口高度--%>
                <%--closed: true,//窗口是是否为关闭状态, true：表示关闭--%>
                <%--modal: true//模式窗口--%>
            <%--});--%>

            <%--/**--%>
             <%--* createMapping的表单提交--%>
             <%--* 2019年10月15日--%>
             <%--*/--%>
            <%--$('#btnSaveFiled').bind('click', function () {--%>
                <%--//提取下拉框选项--%>
                <%--//提交表单--%>
                <%--$('#saveFiled').form('submit', {--%>
                    <%--url: 'fileBase/save',--%>
                    <%--type: 'post',--%>
                    <%--onSubmit: function () {--%>
                        <%--// do some checked--%>
                        <%--//做表单字段验证，当所有字段都有效的时候返回true。该方法使用validatebox(验证框)插件。--%>
                        <%--var isValid = $('#saveFiled').form('validate');--%>
                        <%--if (isValid == false) {--%>
                            <%--return;--%>
                        <%--}--%>
                        <%--// return false to prevent submit;--%>
                    <%--},--%>
                    <%--success: function (data) {--%>
                        <%--var data = eval('(' + data + ')');--%>
                        <%--$.messager.alert("提示", data.message, 'info', function () {--%>
                            <%--//成功的话，我们要关闭窗口--%>
                            <%--$('#saveFiledDlg').dialog('close');--%>
                            <%--//刷新表格数据--%>
                            <%--$("#mygrid").datagrid('reload');--%>
                        <%--});--%>
                    <%--}--%>
                <%--});--%>
            <%--});--%>
            <%--//加载数据--%>
            <%--loadGrid();--%>
        <%--});--%>

        <%--//加载表数据--%>
        <%--function loadGrid() {--%>
            <%--/**--%>
             <%--* 获取基础字段的数据, 展示数据网格--%>
             <%--*/--%>
            <%--$('#mygrid').datagrid({--%>
                <%--url: "fileBase/fileBaseList", // 获取基础字段表--%>
                <%--type: "GET",--%>
                <%--dataType: 'json',--%>
                <%--contentType: "application/json",--%>
                <%--columns: [[--%>
                    <%--{field: 'filename', title: '名称', width: 180, align: 'center'},--%>
                    <%--{field: 'type', title: '类型', width: 180, align: 'center'},--%>
                    <%--{field: 'scope', title: '取值范围', width: 180, align: 'center'},--%>
                    <%--{field: 'desc', title: '备注', width: 180, align: 'center'}--%>
                <%--]],--%>
                <%--rownumbers: true,--%>
                <%--title: '文档基础属性',--%>
                <%--singleSelect: true,--%>
                <%--collapsible: true,--%>
                <%--nowrap: true,--%>
                <%--striped: true,--%>
                <%--loading: true,--%>

                <%--loadMsg: "正在努力加载数据,表格渲染中...",--%>
                <%--success: function (data) {--%>
                    <%--//清空数据表格, 再进行填充--%>
                    <%--clearDataGrid();--%>

                    <%--$("#mygrid").datagrid('loadData', data);--%>
                <%--},--%>
                <%--error: function () {--%>
                    <%--clearDataGrid();--%>
                <%--}--%>
            <%--});--%>
        <%--}--%>

        <%--/*清除数据表格中的数据*/--%>
        <%--function clearDataGrid() {--%>
            <%--//获取当前页的记录数--%>
            <%--var item = $("#mygrid").datagrid('getRows');--%>
            <%--for (var i = item.length - 1; i >= 0; i--) {--%>
                <%--var index = $("#mygrid").datagrid('getRowIndex', item[i]);--%>
                <%--$("#mygrid").datagrid('deleteRow', index);--%>
            <%--}--%>
        <%--}--%>

        <%--/**--%>
         <%--* 清空添加字段的表单项--%>
         <%--*/--%>
        <%--function addField() {--%>
            <%--// var treeNode = $('#tt').tree('getSelected');--%>
            <%--// if (treeNode == null)--%>
            <%--//     $.messager.alert('提示消息', '请先选择索引！');--%>
            <%--// else {--%>
            <%--$('#saveFiled').form('clear');--%>
            <%--//加载数据--%>
            <%--// $('#saveFiled').form('load', {indexName: treeNode.text});--%>
            <%--$('#saveFiledDlg').dialog('open');--%>
            <%--// }--%>
        <%--}--%>

        <%--/**--%>
         <%--* 编辑--%>
         <%--*/--%>
        <%--function updateField() {--%>
            <%--var gridNode = $('#mygrid').datagrid('getSelected');--%>
            <%--console.log(gridNode);--%>
            <%--if (gridNode == null) {--%>
                <%--$.messager.alert('提示消息', '请先选择一行数据！');--%>
            <%--} else {--%>
                <%--$('#saveFiled').form('clear');--%>
                <%--//加载数据--%>
                <%--$('#saveFiled').form('load', gridNode);--%>
                <%--// $('#updateDocument').form('clear');--%>
                <%--$('#saveFiledDlg').dialog('open');--%>
            <%--}--%>
        <%--}--%>

        <%--/**--%>
         <%--* 删除--%>
         <%--*/--%>
        <%--function deleteField() {--%>
            <%--var gridNode = $('#mygrid').datagrid('getSelected');--%>
            <%--if (gridNode == null) {--%>
                <%--$.messager.alert('提示消息', '请先选择一行数据！');--%>
            <%--} else {--%>
                <%--$.messager.confirm("确认", "确认要删除吗？", function (yes) {--%>
                    <%--if (yes) {--%>
                        <%--$.ajax({--%>
                            <%--url: 'fileBase/deleteField?id=' + gridNode.id,--%>
                            <%--dataType: 'json',--%>
                            <%--type: 'post',--%>
                            <%--success: function (data) {--%>
                                <%--//var data = eval('(' + data + ')');--%>
                                <%--$.messager.alert("提示", data.message, 'info', function () {--%>
                                    <%--//刷新表格数据--%>
                                    <%--// loadGrid();--%>
                                    <%--$('#mygrid').datagrid('reload');--%>
                                <%--});--%>
                            <%--}--%>
                        <%--});--%>
                    <%--}--%>
                <%--});--%>
            <%--}--%>


        <%--}--%>

        <%--// $("#tt").tree({--%>
        <%--//     onLoadSuccess: function () {--%>
        <%--//         $(".tree-title").mouseover(function () {--%>
        <%--//             alert("哈哈哈");--%>
        <%--//         });--%>
        <%--//     }--%>
        <%--// });--%>

    <%--</script>--%>
</head>
<body id="resource_admin_layout" class="easyui-layout">

<%--文档正在解析中......--%>
<%--<div data-options="region:'center'">--%>
    <%--<div id="toolbar">--%>
        <%--<div class="datagrid-title-div" id="indexName"><span>基础字段</span></div>--%>
        <%--<img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"--%>
             <%--onclick="$('#mygrid').datagrid('reload')" title="刷新">--%>
        <%--<img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"--%>
             <%--onclick="addField()" title="新增字段">--%>
        <%--<img src="images/px-icon/bianji.png" class="easyui-tooltip div-toolbar-img-next"--%>
             <%--onclick="updateField()" title="编辑字段">--%>
        <%--&lt;%&ndash;<img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"&ndash;%&gt;--%>
        <%--&lt;%&ndash;onclick="addDocument()" title="新增数据">&ndash;%&gt;--%>
        <%--<img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"--%>
             <%--onclick="deleteField()" title="删除字段">--%>
    <%--</div>--%>
    <%--<table id="mygrid" style="height: 450px"></table>--%>

<%--</div>--%>
<%--</div>--%>
<%--<div id="saveFiledDlg">--%>
    <%--<form id="saveFiled" method="post">--%>
        <%--<table>--%>
            <%--<tr>--%>
                <%--<td>id</td>--%>
                <%--<td><input name="id" class="easyui-validatebox"--%>
                           <%--data-options="" type="hidden"></td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td>字段名称</td>--%>
                <%--<td><input name="filename" class="easyui-validatebox"--%>
                           <%--data-options="required:false,missingMessage:'字段名称不能为空!'"></td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td>字段类型</td>--%>
                <%--<td><input name="type" class="easyui-validatebox"--%>
                           <%--data-options="required:false,missingMessage:'字段类型不能为空!'"></td>--%>
            <%--</tr>--%>

            <%--<tr>--%>
                <%--<td>取值范围</td>--%>
                <%--<td><input name="scope" class="easyui-validatebox"--%>
                           <%--data-options="required:false,missingMessage:''"></td>--%>
            <%--</tr>--%>

            <%--<tr>--%>
                <%--<td>备注</td>--%>
                <%--<td><input name="desc" class="easyui-validatebox"--%>
                           <%--data-options="required:false,missingMessage:''"></td>--%>
            <%--</tr>--%>
        <%--</table>--%>
        <%--<button id="btnSaveFiled" type="button">保存</button>--%>
    <%--</form>--%>
<%--</div>--%>

</body>
</html>
