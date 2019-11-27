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

        //加载表数据
        function loadGrid(text) {


            /**
             *加载索引信息的,
             *  加载完成后, 选中第一条数据
             */
            $('#info').tree({
                url: 'elasticsearch/getIndexDetail?indexName=' + text,
                method: 'get',
                onClick: function (node) {
                    loadGrid(node.text);
                },
                // //加载完tree型菜单后, 选中第一条数据
                // onLoadSuccess: function (node, data) {
                //     if (data.length > 0) {
                //         //找到第一个元素
                //         var n = $('#tt').tree('find', data[0].id);
                //         //调用选中事件
                //         $('#tt').tree('select', n.target);
                //         loadGrid(data[0].text)
                //     }
                // }
            });

            /**
             *点击获取索引库详情
             *  返回值的数据结构:
             * {
                	"indexName": "dev",
                	"typeName": null,
                	"list": null,
                	"fieldList": "{description={type=text, analyzer=ik_max_word, search_analyzer=ik_smart}, name={type=text, analyzer=ik_max_word, search_analyzer=ik_smart}, pic={type=text, index=false}, price={type=float}, studymodel={type=keyword}, timestamp={type=date, format=yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis}}",
                	"totals": null,
                	"shards": "1",
                	"replicas": "0",
                	"createTime": "2019-10-17 14:04:20"
                }
             */
            // $('#mygrid').datagrid({
            //     url: "elasticsearch/getIndexDetail?indexName=" + text, // 获取列名
            //     type: "GET",
            //     dataType: 'json',
            //     contentType: "application/json",
            //     columns: [[
            //         {field: 'indexName', title: '索引名称', width: 225, align: 'center'},
            //         {field: 'shards', title: '分片数', width: 225, align: 'center'},
            //         {field: 'replicas', title: '副本数', width: 225, align: 'center'},
            //         {field: 'createTime', title: '创建时间', width: 225, align: 'center'},
            //     ]],
            //
            //     rownumbers: false,
            //     singleSelect: true,
            //     collapsible: true,
            //     nowrap: true,
            //     striped: false,
            //     loading: true,
            //
            //     loadMsg: "正在努力加载数据,表格渲染中...",
            //     success: function (data) {
            //         $("#mygrid").datagrid('loadData', data);
            //     },
            //     error: function (data) {
            //     }
            // });
            /**
             * 清空索引属性, 重新填充索引属性
             */
            $('#indexDetail').html('');
            $.ajax({
                url: "elasticsearch/getIndexDetail?indexName=" + text, // 获取列名
                type: "GET",
                dataType: 'json',
                contentType: "application/json",
                success: function (data) {
                    /**
                     * 填充索引属性
                     */
                    var info = data.rows[0];
                    $('#indexDetail').append(' <br>索引名称<br>\n' +
                        '                    <input type="text" class="easyui-textbox" value="' + info.indexName + '" readonly="true" style="text-align: center;">\n' +
                        '                   ' + ' <br>分片数<br>\n' +
                        '                    <input type="text" value="' + info.shards + '" readonly="true" style="text-align: center;">\n' +
                        '                   ' + ' <br>副本数<br>\n' +
                        '                    <input type="text" value="' + info.replicas + '" readonly="true" style="text-align: center;">\n' +
                        '                   ' + ' <br>创建时间<br>\n' +
                        '                    <input type="text" value="' + info.createTime + '" readonly="true" style="text-align: center;">\n' +
                        '                   ');
                }
            });

            //获取第二个表格
            /**
             * 获取索引库字段映射信息
             */
            $('#mappinggrid').datagrid({
                url: "elasticsearch/getIndexField?indexName=" + text, // 获取字段映射表
                type: "GET",
                dataType: 'json',
                contentType: "application/json",
                columns: [[
                    {field: 'fieldName', title: '字段名称', width: 180, align: 'center'},
                    {field: 'type', title: '字段类型', width: 180, align: 'center'},
                    {field: 'index', title: '是否存储', width: 180, align: 'center'},
                    {field: 'analyzer', title: '存储分词', width: 180, align: 'center'},
                    {field: 'searchAnalyzer', title: '检索分词', width: 180, align: 'center'},
                ]],
                rownumbers: true,
                title: '字段映射',
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                striped: true,
                loading: true,

                loadMsg: "正在努力加载数据,表格渲染中...",
                success: function (data) {
                    //清空数据表格, 再进行填充
                    clearDataGrid();

                    $("#mappinggrid").datagrid('loadData', data);
                },
                error: function () {
                    clearDataGrid();
                }
            });
        }

        /*清除数据表格中的数据*/
        function clearDataGrid() {
            //获取当前页的记录数
            var item = $("#mappinggrid").datagrid('getRows');
            for (var i = item.length - 1; i >= 0; i--) {
                var index = $("#mappinggrid").datagrid('getRowIndex', item[i]);
                $("#mappinggrid").datagrid('deleteRow', index);
            }
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
             *加载索引列表的树形菜单,
             *  加载完成后, 选中第一条数据
             *  将索引库名称显示在顶部
             */
            $('#tt').tree({
                url: 'elasticsearch/getIndexList',
                method: 'get',
                onClick: function (node) {
                    //alert(node.text)
                    loadGrid(node.text);
                    //将索引名称显示在顶部
                    document.getElementById("indexName").innerHTML = "";
                    $('#indexName').append('<span>' + node.text + '</span>')
                },
                //加载完tree型菜单后, 选中第一条数据
                onLoadSuccess: function (node, data) {
                    if (data.length > 0) {
                        //找到第一个元素
                        var n = $('#tt').tree('find', data[0].id);
                        //调用选中事件
                        $('#tt').tree('select', n.target);
                        loadGrid(data[0].text)
                        //将索引库名称显示在顶部
                        document.getElementById("indexName").innerHTML = "";
                        $('#indexName').append('<span>' + data[0].text + '</span>')
                    }
                }
            });


            /**
             * createIndex的表单提交
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
             * createMapping的表单提交
             * 2019年10月15日
             */
            $('#btnSaveFiled').bind('click', function () {
                //提取下拉框选项
                var treeNode = $('#tt').tree('getSelected');
                //提交表单
                $('#saveFiled').form('submit', {
                    url: 'elasticsearch/createMapping',
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
                            $("#mappinggrid").datagrid('reload');
                        });
                    }
                });
            });

        });

        function addIndex() {
            $('#saveIndex').form('clear');
            $('#saveIndexDlg').dialog('open');
        }

        /**
         * 删除索引库
         */
        function deleteIndex() {
            var node = $('#tt').tree('getSelected');
            if (node == null)
                $.messager.alert('提示消息', '请先选择索引！');
            else {
                $.messager.confirm("确认", "确认要删除吗？", function (yes) {
                    if (yes) {
                        $.ajax({
                            url: 'elasticsearch/deleteIndex?indexName=' + node.text,
                            dataType: 'json',
                            success: function (data) {
                                $.messager.alert("提示", data.message, 'info', function () {
                                    //刷新树数据
                                    $('#tt').tree('reload');
                                });
                            }
                        });
                    }
                });
            }
        }

        /**
         * 清空添加字段的表单项
         */
        function addField() {
            var treeNode = $('#tt').tree('getSelected');
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
            $.messager.alert('提示消息', '索引库的结构不能改变!');
        }

        /**
         * 删除
         */
        function deleteField() {
            $.messager.alert('提示消息', '索引库的结构不能改变, 可以删除索引库重新创建再试!');
        }

        $("#tt").tree({
            onLoadSuccess: function () {
                $(".tree-title").mouseover(function () {
                    alert("哈哈哈");
                });
            }
        });

    </script>
</head>
<body id="resource_admin_layout" class="easyui-layout">
<div data-options="region:'west'" style="width: 200px;">
    <div class="easyui-layout" style="width: 200px; height: 100%;">
        <div data-options="region:'north'" style="height: 400px;">
            <div class="layout-title-div">
                ES索引列表
                <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('resource_admin_layout','west')"
                     class="layout-title-img">
            </div>
            <%--操作栏--%>
            <div style="margin:5px 0;border-bottom:1px ">
                <div id="toolbar1">
                    <img src="images/px-icon/shuaxin.png" style="padding:0 10px"
                         class="easyui-tooltip div-toolbar-img-first"
                         onclick="$('#tt').tree('reload');" title="刷新">
                    <img src="images/px-icon/newFolder.png" style="padding: 0px 10px;"
                         class="easyui-tooltip div-toolbar-img-next"
                         onclick="addIndex()" title="新建索引">
                    <%--<img src="images/px-icon/checkout.png" style="padding: 0px 10px;"
                         class="easyui-tooltip div-toolbar-img-next"
                         onclick="checkOutRepository_open()" title="检出工作副本">--%>
                    <img src="images/px-icon/shanchu.png" style="padding: 0px 10px;"
                         class="easyui-tooltip div-toolbar-img-next"
                         onclick="deleteIndex()" title="删除索引">
                </div>
            </div>

            <div id="nav">
                <ul id="tt"></ul>
            </div>
            <%--树目录--%>
            <%--<jsp:include page="/px-tool/px-tree.jsp">--%>
            <%--<jsp:param value="<%=treeId%>" name="div-id"/>--%>
            <%--</jsp:include>--%>
        </div>

        <%----%>


        <div data-options="region:'south'" style="height: 200px;">
            <div style="height: 2px;background-color: black;"></div>
                <from id="indexDetail">

                </from>
        </div>
    </div>
</div>

<div data-options="region:'center'">
    <div id="toolbar">
        <div class="datagrid-title-div" id="indexName"></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#mappinggrid').datagrid('reload')" title="刷新">
        <img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="addField()" title="新增字段">
        <img src="images/px-icon/bianji.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="updateField()" title="编辑字段">
        <%--<img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"--%>
        <%--onclick="addDocument()" title="新增数据">--%>
        <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="deleteField()" title="删除字段">

        <%--<input style="float: right;margin-top: 8px;margin-right: 20px;">--%>
        <a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton"
           style="float: right;margin-top: 8px;margin-right: 20px;width:80px">Search</a>
        <input name="search" class="div-toolbar-span" style="float: right;margin-top: 8px;width:200px;height:25px"/>
    </div>
    <%--<jsp:include page="/px-tool/px-datagrid.jsp">
        <jsp:param value="<%=datagridId1%>" name="div-id"/>
        <jsp:param value="<%=toolbar%>" name="datagrid-toolbar"/>
    </jsp:include>--%>

    <table id="mygrid" style="height: 60px"></table>
    <table id="mappinggrid" style="height: 450px"></table>

</div>
<%--</div>--%>

<div id="saveIndexDlg">
    <form id="saveIndex" method="post">
        <%--<input name="uuid" type="hidden">--%>
        <table>
            <tr>
                <td>索引名称</td>
                <td><input name="indexName" class="easyui-validatebox"
                           data-options="required:true,missingMessage:'索引名称不能为空!'" placeholder=""></td>
            </tr>
            <tr>
                <td>分片数</td>
                <td><input name="shardNum" class="easyui-validatebox"
                           data-options="required:false,missingMessage:'默认是5'" placeholder="不填默认5"></td>
            </tr>
            <tr>
                <td>副本数</td>
                <td><input name="replicaNum" class="easyui-validatebox"
                           data-options="required:false,missingMessage:'默认是1'" placeholder="不填默认1"></td>
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
