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
    <title>日志界面</title>

    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <link rel="stylesheet" type="text/css" href="ui/themes/icon.css">
    <script src="js/jquery.min.js"></script>
    <%--<script src="js/jquery.easyui.min.1.5.2.js"></script>--%>
    <script src="ui/jquery.easyui.min.js"></script>

    <script src="js/pxzn.util.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
    <script type="text/javascript" src="js/search_history.js"></script>
    <script>
        /**
         * 入口函数
         */
        $(function () {
            //跳转刷新监听
            // window.onbeforeunload = onbeforeunload_handler;
            // window.onunload = onunload_handler;
            // function onbeforeunload_handler() {
            //     var warning = "";
            //     return warning;
            // }
            //
            // function onunload_handler() {
            //     var warning = "";
            // }
            //时间控件 按钮
            var buttons = $.extend([], $.fn.datebox.defaults.buttons);
            buttons.splice(1, 0, {
                text: '清空',
                handler: function(target){
                    $('#date').datebox('clear');
                }
            });
            $('#date').datebox({
                buttons: buttons
            });
            //加载树
            loadTree(treeData());
            // //加载数据
            loadGrid();
            user_sort(1);

            //加载完表格后隐藏其一
            var dateOrUser = $("#dateOrUser").combobox('getValue');
            if (dateOrUser == 0) {
                //切换表格, 用户分类
                $('#sort_grid').css('display', 'none');
                $('#my_grid').css('display', 'block');
            } else if (dateOrUser == 1) {
                //切换表格, 用户分类
                $('#my_grid').css('display', 'none');
                $('#sort_grid').css('display', 'block');
            }
        });

        function loadTree(data) {
            $('#tt').tree({
                // url: 'indexMenu/listIndexMenu',
                method: 'POST',
                data: data,

                onClick: function (node) {

                    // //将索引名称显示在顶部
                    // document.getElementById("indexName").innerHTML = "";
                    // $('#indexName').append('<span>' + node.text + '</span>')
                    //
                    // //获取上树
                    // getTree();
                    // var dateOrUser = $("#dateOrUser").combobox('getValue');
                    // if (dateOrUser == 0) {
                    //     loadGrid();
                    // } else {
                    //     user_sort(1);
                    // }
                    sort_search();
                },
                //加载完tree型菜单后, 选中第一条数据
                onLoadSuccess: function (node, data) {
                    //什么都不干

                    if (data.length > 0) {
                        //找到第一个元素
                        var n = $('#tt').tree('find', data[0].id);
                        //调用选中事件
                        $('#tt').tree('select', n.target);
                        //
                        //     getTree();
                        //
                        //     //将索引库名称显示在顶部
                        //     document.getElementById("indexName").innerHTML = "";
                        //     $('#indexName').append('<span>' + data[0].text + '</span>')
                    }
                }
            });
        }

        //加载表数据
        function loadGrid() {

            /**
             * 展示数据网格
             */
            $('#mygrid').treegrid({
                // url: "logInfo/listLogInfo?search=" + search + "&status=" + status + "&startTime=" + startTime + "&endTime=" + endTime, //日志列表
                url: "logInfo/listSearchLog?status=1", //日志列表
                type: "POST",
                // data: data,
                dataType: 'json',
                contentType: "application/json",
                columns: [[
                    {field: 'text', title: '日期', width: 100},
                    {field: 'operator', title: '操作人员', width: 100},
                    {field: 'search', title: '检索词', width: 100},
                    {field: 'operationResult', title: '操作结果', width: 100},
                    // {field: 'indexName', title: '索引库名称', width: 180, align: 'center'}
                    {field: 'ip', title: 'IP地址', width: 100}
                ]],
                // rownumbers: true,
                // title: '文档基础属性',
                // singleSelect: true,
                // collapsible: true,
                // nowrap: true,
                // striped: true,
                loading: true,
                // pagination: true,
                // pageList: [50,100,200],
                // idField: 'id',
                // treeField: 'text',

                loadMsg: "正在努力加载数据,表格渲染中...",
                onLoadSuccess: function (data) {
                    //固定表格
                    // $('#mygrid').treegrid('fixRowHeight');
                },
            });
        }

        /**
         * 删除
         */
        function deleteField() {
            var gridNode = $('#mygrid').treegrid('getSelected');
            if (gridNode == null) {
                $.messager.alert('提示消息', '请先选择一行数据！');
            } else {
                $.messager.confirm("确认", "确认要删除吗？", function (yes) {
                    if (yes) {
                        $.ajax({
                            url: 'logInfo/delete?id=' + gridNode.id,
                            dataType: 'json',
                            type: 'post',
                            success: function (data) {
                                //var data = eval('(' + data + ')');
                                $.messager.alert("提示", data.message, 'info', function () {
                                    //刷新表格数据
                                    // loadGrid();
                                    $('#mygrid').treegrid('reload');
                                });
                            }
                        });
                    }
                });
            }
        }

        /**
         * 搜索
         */
        function search_log(gridId) {
            var dateOrUser = $("#dateOrUser").combobox('getValue');
            //获取search
            var search = $("#operator").val();
            //获取status
            // var status = $("#status").combobox('getValue');
            //获取startTime
            var date = $("#date").datebox('getValue');
            //获取endTime
            // var endTime = $("#endTime").datetimebox('getValue');
            var result = time_deal();
            var startTime = result.startTime;
            var endTime = result.endTime;

            var data = {
                search: search,
                date: date,
                dateOrUser: dateOrUser,
                startTime:startTime,
                endTime:endTime,
            };
            $('#' + gridId).treegrid('load', data);
            // loadGrid(search, status, startTime, endTime);
        }

        function sort_search() {
            //获取状态码
            var dateOrUser = $("#dateOrUser").combobox('getValue');
            var gridId = '';
            if (dateOrUser == 0) {
                //切换表格, 用户分类
                $('#sort_grid').css('display', 'none');
                $('#my_grid').css('display', 'block');
                gridId = 'mygrid';

            } else if (dateOrUser == 1) {
                //切换表格, 用户分类
                $('#my_grid').css('display', 'none');
                $('#sort_grid').css('display', 'block');
                gridId = 'sortgrid';
            }
            //执行search_log方法
            search_log(gridId);
        }

        //加载表数据
        function user_sort(dateOrUser) {
            var startTime = '';
            var endTime = '';
            /**
             * 展示数据网格
             */
            $('#sortgrid').treegrid({
                // url: "logInfo/listLogInfo?search=" + search + "&status=" + status + "&startTime=" + startTime + "&endTime=" + endTime, //日志列表
                url: "logInfo/listSearchLog?status=1&dateOrUser=" + dateOrUser, //日志列表
                type: "POST",
                // data: data,
                dataType: 'json',
                contentType: "application/json",
                columns: [[
                    {field: 'text', title: '操作人员', width: 100},
                    {field: 'timeStr', title: '日期', width: 100},
                    {field: 'search', title: '检索词', width: 100},
                    {field: 'operationResult', title: '操作结果', width: 100},
                    // {field: 'indexName', title: '索引库名称', width: 180, align: 'center'}
                    {field: 'ip', title: 'IP地址', width: 100}
                ]],
                // rownumbers: true,
                // title: '文档基础属性',
                // singleSelect: true,
                // collapsible: true,
                // nowrap: true,
                // striped: true,
                loading: true,
                // pagination: true,
                // pageList: [50,100,200],
                // idField: 'id',
                // treeField: 'text',

                loadMsg: "正在努力加载数据,表格渲染中...",
                onLoadSuccess: function (data) {
                    //固定表格
                    // $('#mygrid').treegrid('fixRowHeight');
                },
            });
        }


    </script>
</head>
<body id="resource_admin_layout" class="easyui-layout">

<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        历史
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('resource_admin_layout','west')"
             class="layout-title-img">
    </div>
    <%--操作栏--%>
    <div style="margin:5px 0;border-bottom:1px ">
        <%--<div id="toolbar1">--%>
        <%--<img src="images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"--%>
        <%--onclick="$('#tt').tree('reload');" title="刷新">--%>
        <%--</div>--%>
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
    <table style="padding:10px 5px;width: 100%;margin: auto;">
        <tr>
            <td style="width: 15%;">
                <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
                     onclick="$('#mygrid').datagrid('reload')" title="刷新">
                <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
                     onclick="deleteField()" title="删除字段">
            </td>
            <td style="width: 25%">
                <span>日期:</span>
                <input id="date" class="easyui-datebox" editable="false" name="date" data-options="onChange:sort_search">
            </td>
            <td style="width: 25%;">

                <span>用户:</span>
                <input id="operator" class="easyui-textbox" name="operator" data-options="onChange:sort_search"/>

            </td>
            <td style="width: 25%;">
                <span>分类():</span>
                <select id="dateOrUser" class="easyui-combobox" name="dateOrUser" editable="false"
                        data-options="onChange:sort_search" style="width: 50%;">
                    <option value="0" selected>时间</option>
                    <option value="1" >用户</option>
                </select>
            </td>

            <td style="width: 10%">
                <a href="javaScript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="sort_search()">search</a>
            </td>
        </tr>

    </table>
    <%--<div >--%>
    <%--<img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"--%>
    <%--onclick="$('#mygrid').datagrid('reload')" title="刷新">--%>
    <%--<img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"--%>
    <%--onclick="deleteField()" title="删除字段">--%>

    <%--<span>起始时间:</span>--%>
    <%--<input id="startTime" class="easyui-datetimebox" editable="false" name="startTime"--%>
    <%--data-options="onChange:search_log">--%>
    <%--<span>结束时间:</span>--%>
    <%--<input id="endTime" class="easyui-datetimebox" editable="false" name="endTime"--%>
    <%--data-options="onChange:search_log">--%>
    <%--<span>查询类型:</span>--%>
    <%--<select id="status" class="easyui-combobox" name="status" editable="false" data-options="onChange:search_log">--%>
    <%--<option value="0" selected>全部</option>--%>
    <%--<option value="1">检索日志</option>--%>
    <%--<option value="2">操作日志</option>--%>
    <%--</select>--%>

    <%--<span>操作人员:</span>--%>
    <%--<input id="operator" class="easyui-textbox" name="operator"/>--%>
    <%--<a href="javaScript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="search_log()">Search</a>--%>

    <%--</div>--%>

    <%--<div id="mygrid" style="height: 450px"></div>--%>
    <%--<table id="mygrid" class="easyui-datagrid" style="height:450px"--%>
    <%--data-options="toolbar:'#toolbar',footer:'#footer'">--%>
    <div id="my_grid">

        <table id="mygrid" style="height:450px"
               data-options="
           iconCls: 'icon-ok',
           rownumbers: true,
                toolbar:'#toolbar',
                <%--footer:'#footer',--%>
                animate: true,
                collapsible: true,
                fitColumns: true,
                idField: 'id',
				treeField: 'text',
                <%--lines: true,--%>
                pagination: true,
                pageList: [100,200,300],
                singleSelect: true,
            ">
        </table>


    </div>
    <div id="sort_grid">
        <table id="sortgrid" style="height:450px"
               data-options="
                iconCls: 'icon-ok',
                rownumbers: true,
                toolbar:'#toolbar',
                <%--footer:'#footer',--%>
                animate: true,
                collapsible: true,
                fitColumns: true,
                idField: 'id',
				treeField: 'text',
                <%--lines: true,--%>
                pagination: true,
                pageList: [100,200,300],
                singleSelect: true,

            ">
        </table>
    </div>

    <%--<div id="toolbar" style="padding:2px 5px;">--%>
    <%--<span>起始时间:</span>--%>
    <%--<input id="startTime" class="easyui-datetimebox" editable="false" name="startTime" data-options="onChange:search_log">--%>
    <%--<span>结束时间:</span>--%>
    <%--<input id="endTime" class="easyui-datetimebox" editable="false" name="endTime" data-options="onChange:search_log">--%>
    <%--<span>查询类型:</span>--%>
    <%--<select id="status" class="easyui-combobox" name="status" editable="false" data-options="onChange:search_log">--%>
    <%--<option value="0" selected>全部</option>--%>
    <%--<option value="1">检索日志</option>--%>
    <%--<option value="2">操作日志</option>--%>
    <%--</select>--%>
    <%--<span>操作人员:</span>--%>
    <%--<input id="operator" class="easyui-textbox" name="operator" editable="false"/>--%>
    <%--<a href="#" class="easyui-linkbutton" iconCls="icon-search">Search</a>--%>
    <%--<a href="javaScript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="search_log()">Search</a>--%>

    <%--</div>--%>
    <%--<div id="footer" style="padding:2px 5px;">--%>
    <%--<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"></a>--%>
    <%--<a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true"></a>--%>
    <%--<a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true"></a>--%>
    <%--<a href="#" class="easyui-linkbutton" iconCls="icon-cut" plain="true"></a>--%>
    <%--<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true"></a>--%>
    <%--</div>--%>

</div>
</body>
</html>
