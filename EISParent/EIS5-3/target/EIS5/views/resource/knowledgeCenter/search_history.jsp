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

            loadTree(treeData());
            // //加载数据
            // loadGrid();
        });

        function treeData() {
            //当前月
            var year = currentYear();
            var month = currentMonth();
            // 定义年数组
            var text = [];
            //当前年依次减一获取数组
            for (var i = 0; i < 10; i++) {
                month--;
                if (month < 1) {
                    month = 12;
                    year--;
                }
                if (month < 10) {
                    month = '0' + month;
                }
                text.push(year + '/' + month);
            }
            //组装tree.json
            var tree = [
                {
                    id: 1,
                    text: "今天"
                },
                {
                    id: 2,
                    text: "昨天"
                }, {
                    id: 3,
                    text: "过去一周"
                }, {
                    id: 4,
                    text: "过去一月"
                }, {
                    id: 5,
                    text: "更早",
                    state: "closed",
                    "children": [
                        {
                            // id: 1,
                            text: text[0]
                        }, {
                            // id: 1,
                            text: text[1]
                        }, {
                            // id: 1,
                            text: text[2]
                        }, {
                            // id: 1,
                            text: text[3]
                        }, {
                            // id: 1,
                            text: text[4]
                        }, {
                            // id: 1,
                            text: text[5]
                        }, {
                            // id: 1,
                            text: text[6]
                        }, {
                            // id: 1,
                            text: text[7]
                        }, {
                            // id: 1,
                            text: text[8]
                        }, {
                            // id: 1,
                            text: text[9]
                        }
                        , {
                            // id: 1,
                            text: '加载全部'
                        }
                    ]
                },

            ];
            return tree;
        }

        function loadTree(data) {
            $('#tt').tree({
                // url: 'indexMenu/listIndexMenu',
                method: 'POST',
                data: data,

                onClick: function (node) {
                    // alert(node.text)

                    // //将索引名称显示在顶部
                    // document.getElementById("indexName").innerHTML = "";
                    // $('#indexName').append('<span>' + node.text + '</span>')
                    //
                    // //获取上树
                    // getTree();
                    loadGrid();
                },
                //加载完tree型菜单后, 选中第一条数据
                onLoadSuccess: function (node, data) {
                    //什么都不干

                    if (data.length > 0) {
                        //找到第一个元素
                        var n = $('#tt').tree('find', data[0].id);
                        //调用选中事件
                        $('#tt').tree('select', n.target);

                        loadGrid();
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


        function CurrentTime() {
            var now = new Date();
            var year = now.getFullYear();       //年
            var month = now.getMonth() + 1;     //月
            var day = now.getDate();            //日
            var hh = now.getHours();            //时
            var mm = now.getMinutes();          //分
            var ss = now.getSeconds();           //秒
            var clock = year + "-";
            if (month < 10)
                clock += "0";
            clock += month + "-";
            if (day < 10)
                clock += "0";
            clock += day + " ";
            if (hh < 10)
                clock += "0";
            clock += hh + ":";
            if (mm < 10) clock += '0';
            clock += mm + ":";
            if (ss < 10) clock += '0';
            clock += ss;
            return (clock);
        }

        function currentMonth() {
            var now = new Date();
            // var year = now.getFullYear();       //年
            var month = now.getMonth() + 1;     //月
            // var clock = year + "-";
            // var clock = '';
            // if (month < 10)
            //     clock += "0";
            // // clock += month + "-";
            // clock += month;
            return (month);
        }

        function currentYear() {
            var now = new Date();
            var year = now.getFullYear();       //年
            // var month = now.getMonth() + 1;     //月
            // var clock = year + "-";
            // var clock = '';
            // if (month < 10)
            //     clock += "0";
            // // clock += month + "-";
            // clock += month;
            return (year);
        }

        function getDay(day) {

            var today = new Date();

            var targetday_milliseconds = today.getTime() + 1000 * 60 * 60 * 24 * day;

            today.setTime(targetday_milliseconds); //注意，这行是关键代码

            var tYear = today.getFullYear();

            var tMonth = today.getMonth();

            var tDate = today.getDate();

            tMonth = doHandleMonth(tMonth + 1);

            tDate = doHandleMonth(tDate);

            return tYear + "-" + tMonth + "-" + tDate;

        }

        function doHandleMonth(month) {

            var m = month;

            if (month.toString().length == 1) {

                m = "0" + month;

            }

            return m;

        }


        //加载表数据
        function loadGrid() {

            var data = time_deal();
            var startTime = data.startTime;
            var endTime = data.endTime;

            /**
             * 展示数据网格
             */
            $('#mygrid').datagrid({
                // url: "logInfo/listLogInfo?search=" + search + "&status=" + status + "&startTime=" + startTime + "&endTime=" + endTime, //日志列表
                url: "logInfo/listLogInfo?status=1&startTime=" + startTime + "&endTime=" + endTime, //日志列表
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
                idField: 'id',
                treeField: 'operationDate',

                loadMsg: "正在努力加载数据,表格渲染中...",
                onLoadSuccess: function (data) {
                    // alert("加载完成");
                    //固定表格
                    $('#mygrid').datagrid('fixRowHeight');
                },
            });
        }

        function time_deal() {
            //获取目录text
            var node = $('#tt').tree('getSelected');
            if (!node) {
                return {startTime: null, endTime: null};
            }
            var text = node.text;//今天 昨天 过去一周 过去一月 2019/12
            var startTime = '';
            var endTime = '';
            //处理text
            if (text.indexOf('/') === -1) {
                switch (text) {
                    case '今天':
                        startTime = getDay(-0) + ' 00:00:00';
                        endTime = CurrentTime();
                        break;
                    case '昨天':
                        startTime = getDay(-1) + ' 00:00:00';
                        endTime = getDay(-0) + ' 00:00:00';
                        break;
                    case '过去一周':
                        startTime = getDay(-7) + ' 00:00:00';
                        endTime = CurrentTime();
                        break;
                    case '过去一月':
                        startTime = getDay(-30) + ' 00:00:00';
                        endTime = CurrentTime();
                        break;
                }
            } else {
                //2020/01
                text = text.replace('/', '-');
                startTime = text + '-01 00:00:00';
                endTime = text + '-30 00:00:00';
            }
            return {startTime: startTime, endTime: endTime};
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
         * 搜索
         */
        function search_log() {
            //获取search
            var search = $("#operator").val();
            //获取status
            // var status = $("#status").combobox('getValue');
            //获取startTime
            // var startTime = $("#startTime").datetimebox('getValue');
            //获取endTime
            // var endTime = $("#endTime").datetimebox('getValue');

            var data = {
                search: search,
                // status: status,
                // startTime: startTime,
                // endTime: endTime
            };
            // alert(JSON.stringify(data));
            $('#mygrid').datagrid('load', data);
            // loadGrid(search, status, startTime, endTime);
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
    <table id="toolbar" style="padding:10px 5px;width: 100%;background-color: blue;margin: auto;">
        <tr>
            <td style="width: 60%;">
                <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
                     onclick="$('#mygrid').datagrid('reload')" title="刷新">
                <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
                     onclick="deleteField()" title="删除字段">
            </td>
            <td style="width: 60%;">

                <span>操作人员:</span>
                <input id="operator" class="easyui-textbox" name="operator"/>
                <a href="javaScript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="search_log()">Search</a>

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
    <%--<table id="mygrid" class="easyui-datagrid" style="height:450px"--%>
    <%--data-options="toolbar:'#toolbar',footer:'#footer'">--%>
    <table id="mygrid" class="easyui-datagrid" style="height:450px"
           data-options="
                toolbar:'#toolbar',
                <%--footer:'#footer',--%>
                animate: true,
                collapsible: true,
                fitColumns: true,
            ">
        <thead>
            <tr>
                <th data-options="field:'name',width:180">Task Name</th>
                <th data-options="field:'persons',width:60,align:'right'">Persons</th>
                <th data-options="field:'begin',width:80">Begin Date</th>
                <th data-options="field:'end',width:80">End Date</th>
                <th data-options="field:'progress',width:120">Progress</th>
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
