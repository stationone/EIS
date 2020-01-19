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
                modal: true,//模式窗口

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
                // modal: true//模式窗口
            });
            $('#saveFiledDlg').dialog({
                title: '编辑',//窗口标题
                // width: w,//窗口宽度
                //height: 100,//窗口高度
                closed: true,//窗口是是否为关闭状态, true：表示关闭
                modal: true//模式窗口
                // modal: true//模式窗口
            });

            /**
             * createMapping的表单提交
             * 2019年10月15日
             */
            $('#btnSaveFiled').bind('click', function () {
                //提取下拉框选项
                //提交表单
                $('#saveFiled').form('submit', {
                    url: 'indexMenu/create',
                    // dataType: 'json',
                    contentType: 'application/json',
                    type: 'POST',

                    onSubmit: function () {
                        // do some checked
                        //做表单字段验证，当所有字段都有效的时候返回true。该方法使用validatebox(验证框)插件。
                        var isValid = $('#saveFiled').form('validate');
                        if (isValid == false) {
                            return;
                        }
                        // return false to prevent submit;
                    },
                    success: function (result) {
                        if (result == null) {
                            return;
                        }
                        // var data = eval('(' + data + ')');
                        var data = JSON.parse(result);
                        message_Show(data.message);
                        //成功的话，我们要关闭窗口
                        $('#saveFiledDlg').dialog('close');
                        //刷新表格数据
                        $("#mygrid").datagrid('reload');

                    }
                });
            });
            //加载数据
            loadGrid();
        })
        ;

        //加载表数据
        function loadGrid(text) {
            /**
             * 获取基础字段的数据, 展示数据网格
             */
            $('#mygrid').datagrid({
                url: "indexMenu/listIndexMenu", // 索引库数据列表
                type: "POST",
                dataType: 'json',
                contentType: "application/json",
                columns: [[
                    {field: 'indexName', title: '名称', width: 180, align: 'center'},
                    {field: 'fileType', title: '文件类型', width: 180, align: 'center'},
                    // {
                    //     field: 'creationTime', title: '创建时间', width: 180, align: 'center',
                    //     formatter: function (value, fmt) {
                    //         //固定日期格式
                    //         fmt = 'yyyy-MM-dd hh:mm:ss';
                    //         var date = new Date(value);
                    //         var o = {
                    //             "M+": date.getMonth() + 1,     //月份
                    //             "d+": date.getDate(),     //日
                    //             "h+": date.getHours(),     //小时
                    //             "m+": date.getMinutes(),     //分
                    //             "s+": date.getSeconds(),     //秒
                    //             "q+": Math.floor((date.getMonth() + 3) / 3), //季度
                    //             "S": date.getMilliseconds()    //毫秒
                    //         };
                    //         if (/(y+)/.test(fmt))
                    //             fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
                    //         for (var k in o)
                    //             if (new RegExp("(" + k + ")").test(fmt))
                    //                 fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                    //         return fmt;
                    //     }
                    // },
                    // {
                    //     field: 'lastUpdateTime', title: '最新修改时间', width: 180, align: 'center',
                    //     formatter: function (value, fmt) {
                    //         //固定日期格式
                    //         fmt = 'yyyy-MM-dd hh:mm:ss';
                    //         var date = new Date(value);
                    //         var o = {
                    //             "M+": date.getMonth() + 1,     //月份
                    //             "d+": date.getDate(),     //日
                    //             "h+": date.getHours(),     //小时
                    //             "m+": date.getMinutes(),     //分
                    //             "s+": date.getSeconds(),     //秒
                    //             "q+": Math.floor((date.getMonth() + 3) / 3), //季度
                    //             "S": date.getMilliseconds()    //毫秒
                    //         };
                    //         if (/(y+)/.test(fmt))
                    //             fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
                    //         for (var k in o)
                    //             if (new RegExp("(" + k + ")").test(fmt))
                    //                 fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                    //         return fmt;
                    //     }
                    // },
                    {field: 'creationTimeStr', title: '创建时间', width: 180, align: 'center'},
                    {field: 'lastUpdateTimeStr', title: '上次修改时间', width: 180, align: 'center'},
                    // {field: 'indexName', title: '索引库名称', width: 180, align: 'center'}
                    {
                        field: 'operate', title: '编辑', align: 'center', width: $(this).width() * 0.1,
                        formatter: function (value, row, index) {
                            var str = '<a href="javaScript:void(0)" onclick="updateField(' + index + ')" name="opera" class="easyui-linkbutton" title="属性查看"></a>';
                            return str;
                        }
                    },
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
                    $("a[name='opera']").linkbutton({
                        text: '编辑',
                        plain: true,
                        iconCls: 'icon-search'

                    });
                    //固定表格
                    $('#mygrid').datagrid('fixRowHeight');
                },
            });
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
         * 清空添加字段的表单项
         */
        function addField() {
            //加载选择框
            file_type();
            // var treeNode = $('#tt').tree('getSelected');
            // if (treeNode == null)
            //     $.messager.alert('提示消息', '请先选择索引！');
            // else {
            $('#saveFiled').form('clear');
            //加载数据
            // $('#saveFiled').form('load', {indexName: treeNode.text});
            $('#saveFiled').form('load', {
                creationTime: new Date()
            });


            $('#saveFiledDlg').dialog('open');
            // }
        }

        /**
         * 编辑
         */
        function updateField(index) {
            file_type();


            //调用选中事件
            $('#mygrid').datagrid('selectRow', index);

            var gridNode = $('#mygrid').datagrid('getSelected');
            var id = gridNode.indexId;

            console.log(gridNode);


            $('#saveFiled').form('clear');
            //打开窗口前加载数据
            var date = gridNode.creationTime;
            console.log(date);
            $('#saveFiled').form('load', {
                id: gridNode.indexId,
                indexId: gridNode.indexId,
                creationTimeStr: gridNode.creationTimeStr,
                fileType: gridNode.fileType,
                indexName: gridNode.indexName,
                lastUpdateTime: gridNode.lastUpdateTime,
                menuRoot: gridNode.menuRoot,
                text: gridNode.text,
                creationTime: new Date(date)
            });
            // $('#updateDocument').form('clear');
            $('#saveFiledDlg').dialog('open');
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

        // $("#tt").tree({
        //     onLoadSuccess: function () {
        //         $(".tree-title").mouseover(function () {
        //             alert("哈哈哈");
        //         });
        //     }
        // });

        function file_type() {
            //打开之前加载select
            $('#fileType').combobox({
                url: 'fileType/listFileType',
                method: 'get',
                valueField: 'text',
                textField: 'text',
                panelHeight: 'auto',
                editable: false,
                onChange: function () {
                    //选择框值发生改变时
                }
            })
        }

    </script>
</head>
<body id="resource_admin_layout" class="easyui-layout">

<div data-options="region:'center'">
    <div id="toolbar">
        <div class="datagrid-title-div" id="indexName"><span>基础字段</span></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#mygrid').datagrid('reload')" title="刷新">
        <img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="addField()" title="新增字段">
        <%--<img src="images/px-icon/bianji.png" class="easyui-tooltip div-toolbar-img-next"--%>
        <%--onclick="updateField()" title="编辑字段">--%>
        <%--<img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"--%>
        <%--onclick="addDocument()" title="新增数据">--%>
        <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="deleteField()" title="删除字段">
    </div>
    <table id="mygrid" style="height: 450px"></table>

</div>
</div>
<div id="saveFiledDlg" style="width:400px" data-options="buttons:'#save_index'">
    <form id="saveFiled" method="post">
        <input id="indexId" name="indexId" type="hidden">
        <input id="id" name="id" type="hidden">
        <input name="creationTime" hidden>
        <table class="pxzn-dialog-font" style="margin: auto;" width='100%'>
            <tr>
                <td>
                    <span>
                        库名称:
                    </span>
                </td>
                <td>
                    <input name="indexName" class="easyui-textbox">
                </td>
            </tr>
            <tr>
                <td>
                    <span>
                        文档类型:
                    </span>
                </td>
                <td >
                    <input id="fileType" class="easyui-combobox" editable="false"
                           name="fileType"/>
                </td>
            </tr>

        </table>
    </form>
    <div id="save_index" class="pxzn-dialog-buttons">
        <input id="btnSaveFiled" type="button" value="保存" class="pxzn-button">
    </div>
</div>

</body>
</html>
