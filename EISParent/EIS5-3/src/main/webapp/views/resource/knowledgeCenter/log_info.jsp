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
    <%--<link rel="stylesheet" type="text/css" href="css/easyui.css">--%>
    <%--<link rel="stylesheet" type="text/css" href="css/px-style.css">--%>
    <%--<link rel="stylesheet" type="text/css" href="ui/themes/icon.css">--%>
    <%--<script type="text/javascript" src="ui/jquery.min.js"></script>--%>
    <%--<script type="text/javascript" src="ui/jquery.easyui.min.js"></script>--%>
    <%--<script type="text/javascript" src="ui/locale/easyui-lang-zh_CN.js"></script>--%>
    <%--<script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>--%>
    <%--<script src="js/px-tool/px-util.js"></script>--%>
    <%--<script src="js/pxzn.easyui.util.js"></script>--%>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <link rel="stylesheet" type="text/css" href="ui/themes/icon.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/pxzn.util.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
    <script>
        /**
         * 入口函数
         */
        $(function () {
            // //加载数据
            loadGrid();
        })
        ;

        //加载表数据
        function loadGrid() {
            // var data = {
            //     search: search,
            //     status: status,
            //     startTime: startTime,
            //     endTime: endTime
            // };
             /*
            data: [
                {f1:'value11', f2:'value12'},
                {f1:'value21', f2:'value22'}
            ]
            /*
            /**
             * 展示数据网格
             */
            $('#mygrid').datagrid({
                // url: "logInfo/listLogInfo?search=" + search + "&status=" + status + "&startTime=" + startTime + "&endTime=" + endTime, //日志列表
                url: "logInfo/listLogInfo", //日志列表
                type: "POST",
                // data: data,
                dataType: 'json',
                contentType: "application/json",
                columns: [[
                    {
                        field: 'operationDate', title: '操作时间', width: 180, align: 'center', sortable: true,//可排序
                        formatter: function (value, fmt) {
                            //固定日期格式
                            fmt = 'yyyy-MM-dd hh:mm:ss';
                            var date = new Date(value);
                            var o = {
                                "M+": date.getMonth() + 1,     //月份
                                "d+": date.getDate(),     //日
                                "h+": date.getHours(),     //小时
                                "m+": date.getMinutes(),     //分
                                "s+": date.getSeconds(),     //秒
                                "q+": Math.floor((date.getMonth() + 3) / 3), //季度
                                "S": date.getMilliseconds()    //毫秒
                            };
                            if (/(y+)/.test(fmt))
                                fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
                            for (var k in o)
                                if (new RegExp("(" + k + ")").test(fmt))
                                    fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                            return fmt;
                        }
                    },
                    {field: 'operator', title: '操作人员', width: 180, align: 'center'},
                    {field: 'operationType', title: '操作类型', width: 180, align: 'center'},
                    {field: 'operationResult', title: '操作结果', width: 180, align: 'center'},
                    {field: 'ip', title: '操作人IP地址', width: 180, align: 'center'},
                    // {field: 'indexName', title: '索引库名称', width: 180, align: 'center'}
                    {field: 'search', title: '参数', width: 180, align: 'center'},
                ]],
                rownumbers: true,
                // title: '文档基础属性',
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                striped: true,
                loading: true,
                pagination: true,

                loadMsg: "正在努力加载数据,表格渲染中...",
                onLoadSuccess: function (data) {
                    // alert("加载完成");
                    //固定表格
                    $('#mygrid').datagrid('fixRowHeight');
                },
            });
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
                            url: 'indexMenu/delete?indexName=' + gridNode.indexName,
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

        /**
         * 高级检索
         */
        function search_log() {
            //获取search
            var search = $("#operator").val();
            //获取status
            var status = $("#status").combobox('getValue');
            //获取startTime
            var startTime = $("#startTime").datetimebox('getValue');
            //获取endTime
            var endTime = $("#endTime").datetimebox('getValue');

            var data = {
                search: search,
                status: status,
                startTime: startTime,
                endTime: endTime
            };
            // alert(JSON.stringify(data));
            $('#mygrid').datagrid('load', data);
            // loadGrid(search, status, startTime, endTime);
        }



    </script>
</head>
<body id="resource_admin_layout" class="easyui-layout">

<div data-options="region:'center'">
    <div id="toolbar" style="padding:10px 5px;">
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#mygrid').datagrid('reload')" title="刷新">
        <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="deleteField()" title="删除字段">

        <span>起始时间:</span>
        <input id="startTime" class="easyui-datetimebox" editable="false" name="startTime" data-options="onChange:search_log">
        <span>结束时间:</span>
        <input id="endTime" class="easyui-datetimebox" editable="false" name="endTime" data-options="onChange:search_log">
        <span>查询类型:</span>
        <select id="status" class="easyui-combobox" name="status" editable="false" data-options="onChange:search_log">
            <option value="0" selected>全部</option>
            <option value="1">检索日志</option>
            <option value="2">操作日志</option>
        </select>
        <span>操作人员:</span>
        <input id="operator" class="easyui-textbox" name="operator"/>
        <a href="javaScript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="search_log()">Search</a>

    </div>


    <div id="tb" style="padding:3px">
        <%--<span>操作人员:</span>--%>
        <%--<input id="operator" class="easyui-textbox" name="operator" editable="false"/>--%>
        <%--<span>查询类型:</span>--%>
        <%--<select id="status" class="easyui-combobox" name="status" editable="false" data-options="onChange:search_log">--%>
            <%--<option value="0" selected>全部</option>--%>
            <%--<option value="1">检索日志</option>--%>
            <%--<option value="2">操作日志</option>--%>
        <%--</select>--%>
        <%--<span>起始时间:</span>--%>
        <%--<input id="startTime" class="easyui-datetimebox" editable="false" name="startTime" data-options="onChange:search_log">--%>
        <%--<span>结束时间:</span>--%>
        <%--<input id="endTime" class="easyui-datetimebox" editable="false" name="endTime" data-options="onChange:search_log">--%>
        <%--<a href="javaScript:void(0)" class="easyui-linkbutton" onclick="search_log()">查询</a>--%>
    </div>
    <%--<div id="mygrid" style="height: 450px"></div>--%>
    <table id="mygrid" class="easyui-datagrid" style="height:450px"
           data-options="toolbar:'#toolbar',footer:'#footer'">
        <thead>
        <tr>
            <th data-options="field:'itemid',width:80">Item ID</th>
            <th data-options="field:'productid',width:100">Product</th>
            <th data-options="field:'listprice',width:80,align:'right'">List Price</th>
            <th data-options="field:'unitcost',width:80,align:'right'">Unit Cost</th>
            <th data-options="field:'attr1',width:240">Attribute</th>
            <th data-options="field:'status',width:60,align:'center'">Status</th>
        </tr>
        </thead>
    </table>
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
    <div id="footer" style="padding:2px 5px;">
        <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"></a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true"></a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true"></a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-cut" plain="true"></a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true"></a>
    </div>

</div>
</body>
</html>
