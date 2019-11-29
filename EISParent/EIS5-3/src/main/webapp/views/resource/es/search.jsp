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
    <link rel="stylesheet" type="text/css" href="ui/themes/icon.css">
    <%--<link rel="stylesheet" type="text/css" href="../demo.css">--%>
    <script type="text/javascript" src="ui/jquery.min.js"></script>
    <script type="text/javascript" src="ui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="ui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script>


        /**
         * 入口函数
         */
        $(function () {
            loadGrid();
            /**
             *加载索引列表的树形菜单,
             *  加载完成后, 选中第一条数据
             */
            $('#tt').tree({
                url: 'elasticsearch/getIndexList',

                method: 'get',
                checkbox: true,
            });

            /**
             * 搜索按钮, 点击事件
             */
            $('#btnSearch').bind('click', function () {
                //把表单数据转换成json对象
                var str = JSON.stringify($('#searchForm').serializeJSON());
                //$('#searchForm').form('clear');
                //alert(str);
                //console.log(JSON.stringify($('#searchForm').serializeJSON()));
                console.log(str);

                var indexNames = getChecked();
                // var indexNames = getSelected();


                loadGrid();
                $('#mygrid').datagrid('reload', {json: str,indexNames:indexNames});
            });

            //加载高级搜索表格
            $("#p").panel({
                collapsible: true,
                closable: true,
                href: 'search/getSearchField',//加载表格数据
                cache: true,//缓存
                extractor : function (data) {
                    var arr = JSON.parse(data);
                    var html = '';
                    for (var i = 0; i < arr.length; i++) {
                        html += ' <input name="'+arr[i].name+'" class="div-toolbar-span" style="width:300px;height:25px;margin-right: 5px"/>'+arr[i].name+'<br>';
                    }

                    return html;
                }
            });
        });

        /**
         * 搜索内容,加载document数据
         */
        function loadGrid() {
            var indexNames = getChecked();
            // var indexNames = getSelected();
            console.log(indexNames);
            $.ajax({
                url: "search/getTitle?indexNames=" + indexNames,
                type: "GET",
                dataType: 'json',
                success: function (title) {
                    //提取表单数据
                    var search = JSON.stringify($('#searchForm').serializeJSON());
                    //获取表头数据成功后，使用easyUi的datagrid去生成表格
                    $('#mygrid').datagrid({
                        // url: "search/getList?indexNames=" + text, //更改了请求路径
                        url: "search/getList",
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
                        // 排序
                        remoteSort: true,
                        multiSort: true,
                        pageNumber: 1,
                        pageSize: 10,
                        pageList: [10, 20, 30, 40, 50],
                        loadMsg: "正在努力加载数据,表格渲染中..."
                    });
                },
                error: function (e) {
                    // console.log(e);
                }
            });
        }

        /**
         *获取选中的index
         *
         */

        function getSelected() {
            var nodes = $('#tt').tree('getSelected');
            if (nodes == null) {
                return "";
            }
            var s = '';
            for (var i = 0; i < nodes.length; i++) {
                if ('' !== s) s += ',';
                s += nodes[i].text;
            }
            console.log(s);
            return s;

        }

        /**
         * 全选/全不选树节点的方法
         * @param ifcheck boolean 是否选中
         * @param treeId String 树id
         */
        function selectAllNode(ifcheck, treeId) {
            var _tree = $('#' + treeId),
                roots = _tree.tree('getRoots');
            if (ifcheck) {
                for (var i = 0; i < roots.length; i++) {
                    _tree.tree('check', roots[i].target);
                }
            } else {
                for (var i = 0; i < roots.length; i++) {
                    _tree.tree('uncheck', roots[i].target);
                }
            }
        }

        /**
         * 反选树节点的方法
         * @param treeId String 树id
         */
        function selectInvert(treeId) {
            var _tree = $('#' + treeId),
                n_checked = _tree.tree('getChecked'),
                n_unchecked = _tree.tree('getChecked', 'unchecked');
            for (var i = 0; i < n_checked.length; i++) {
                _tree.tree('uncheck', n_checked[i].target);
            }
            for (var j = 0; j < n_unchecked.length; j++) {
                _tree.tree('check', n_unchecked[j].target);
            }

        }


        /**
         * 获取复选框
         */
        function getChecked() {
            var nodes = $('#tt').tree('getChecked');

            var s = '';
            for (var i = 0; i < nodes.length; i++) {
                if ('' !== s) s += ',';
                s += nodes[i].text;
            }
            console.log(s);
            return s;
        }
    </script>
</head>
<body id="resource_admin_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        <button onclick="selectAllNode(
            true,'tt'
        )">全选
        </button>
        <button onclick="selectAllNode(
            false,'tt'
        )">全不选
        </button>

        <%--<button onclick="getChecked()">获取选中的</button>--%>
        <button onclick="selectInvert('tt')">反选</button>

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

        <%--<tag style="color: red;">哈哈啊哈哈哈哈</tag>--%>

    </div>
    <%--<jsp:include page="/px-tool/px-datagrid.jsp">
        <jsp:param value="<%=datagridId1%>" name="div-id"/>
        <jsp:param value="<%=toolbar%>" name="datagrid-toolbar"/>
    </jsp:include>--%>

    <div class="easyui-panel" style="padding-left:4px;border-bottom:0px;">
        <%--<div style="height:2px;"></div>--%>
        <form id="searchForm">
            <input name="search" class="div-toolbar-span" style="width:300px;height:25px"/>
            <a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton" style="width:80px">开始搜索</a>
            <div style="margin:20px 0 10px 0;">
                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#p').panel('open')">高级搜索</a>
            </div>



            <div id="p" class="easyui-panel" title="高级搜索" style="width:700px;height:200px;padding:10px;"
                 closed="true">

                <select id="dateScope" class="div-toolbar-span"
                        name="dateScope"
                        style="width:300px;height:25px;margin-right: 5px" panel Height="50">
                    <option value="all">全部时间</option>
                    <option value="week">过去一周</option>
                    <option value="month" aria-selected="true">过去一月</option>
                    <option value="year">过去一年</option>

                </select>时间范围<br>
                <%--<input name="endDate" class="div-toolbar-span" style="width:300px;height:25px;margin-right: 5px"/><br>--%>
            </div>
        </form>

    </div>
    <table id="mygrid" style="height: 450px"></table>

</div>
</div>

</body>
</html>
