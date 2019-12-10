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
            /**
             * 获取库目录
             */
            loadTree();//树目录在库目录获取完成后再进行获取
            // /**
            //  * 获取树目录
            //  */
            // getTree();

            //初始化创建索引库窗口
            $('#saveIndexDlg').dialog({
                title: '创建索引库',//窗口标题
                // width: w,//窗口宽度
                // height: 100,//窗口高度
                closed: true,//窗口是是否为关闭状态, true：表示关闭
                modal: true//模式窗口
            });


        });

        function getTree() {
            var node = $('#tt').tree('getSelected');
            if (node == null) {
                return;
            }
            var indexName = node.text;

            $('#' + treeId).tree({
                url: 'menu/listTree?indexName=' + indexName,
                method: "get",
                checkbox: false,
                multiple: false,
                onClick: function (node) {
                    //点击事件 获取dataList
                    loadDataList(node.id);

                    //将目录名称显示在顶部
                    document.getElementById("index").innerHTML = "";
                    $('#index').append('<span>/' + node.text + '</span>')
                }
            });
        }

        /**
         * 绑定搜索按钮
         */
        function searchFile() {
            //获取input中的值
            var search = document.getElementById('search').value;
            // $('#mygrid').datagrid('reload', {json: JSON.stringify({search:search})});
            var searchJson = JSON.stringify({search: search});
            console.log(searchJson);
            $.ajax({
                url: 'fileSearch/filePageList',
                method: 'GET',
                contentType: 'application/json',
                data: 'search=' + search,
                dataType: 'json',
                success: function (result) {
                    dataShow(result);
                }
            });
        }

        /**
         * 获取数据
         */
        function loadDataList(menuId) {
            /**
             * 获取基础字段的数据, 展示数据网格
             */
            $('#mygrid').datagrid({
                url: "file/fileList?menuId=" + menuId, // 文档表
                type: "GET",
                dataType: 'json',
                contentType: "application/json",

                columns: [[
                    {field: 'fileName', title: '名称', width: 180, align: 'center'},

                    {field: 'fileNameSuffix', title: '类型', width: 180, align: 'center'},
                    {field: 'keyword', title: '关键词', width: 180, align: 'center'},

                    {field: 'pageTotal', title: '页面总数', width: 180, align: 'center'},
                    {
                        field: 'creationTime', title: '创建时间', width: 180, align: 'center',
                        // formatter: function (value) {
                        //     var date = new Date(value);
                        //     var y = date.getFullYear();
                        //     var M = date.getMonth() + 1;
                        //     var d = date.getDate();
                        //     var H = date.getHours();
                        //     var m = date.getMinutes();
                        //     var s = date.getSeconds();
                        //     return y + '-' + M + '-' + d + ' ' + H + ':' + m + ':' + s;
                        // }
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
                                    fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                            return fmt;
                        }
                    },
                    {field: 'indexName', title: '所在库', width: 180, align: 'center'},
                    {field: 'filePath', title: '文件路径', width: 180, align: 'center'},
                    {
                        field: 'fileSize', title: '文件大小', width: 180, align: 'center',
                        formatter: function (value) {
                            if (null == value || value == '') {
                                return "0 Bytes";
                            }
                            var unitArr = new Array("Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB");
                            var index = 0;
                            var srcsize = parseFloat(value);
                            index = Math.floor(Math.log(srcsize) / Math.log(1024));
                            var size = srcsize / Math.pow(1024, index);
                            size = size.toFixed(2);//保留的小数位数
                            return size + unitArr[index];
                        }
                    },
                    {field: 'author', title: '作者', width: 180, align: 'center'},
                    {field: 'authorName', title: '上传人员', width: 180, align: 'center'},
                    {field: 'content', title: '正文', width: 300, align: 'center'},
                    {
                        field: 'operate', title: '操作', align: 'center', width: $(this).width() * 0.1,
                        formatter: function (value, row, index) {
                            var str = '<a href="javaScript:void(0)" onclick="file_show(\'' + row.fileId + '\')" name="opera" class="easyui-linkbutton" ></a>';
                            return str;
                        }
                    },
                ]],
                rownumbers: true,
                title: '文档列表',
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                striped: true,
                loading: true,
                emptyMsg: "没有获取到数据",
                loadMsg: "正在努力加载数据,表格渲染中...",
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                onLoadSuccess: function (data) {
                    // alert("加载完成");
                    $("a[name='opera']").linkbutton({text: '预览', plain: true, iconCls: '/images/px-icon/yulan.png'});
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
         * 文件预览
         */
        function file_show(fileId, pageNo) {
            window.location.href = "./views/resource/knowledgeCenter/file_show.jsp?fileId=" + fileId + "&pageNo=" + pageNo
        }

        //时间戳转日期格式
        function formatDate(time, format) {
            var t = new Date(time);
            var tf = function (i) {
                return (i < 10 ? '0' : '') + i
            };
            return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function (a) {
                switch (a) {
                    case 'yyyy':
                        return tf(t.getFullYear());
                        break;
                    case 'MM':
                        return tf(t.getMonth() + 1);
                        break;
                    case 'mm':
                        return tf(t.getMinutes());
                        break;
                    case 'dd':
                        return tf(t.getDate());
                        break;
                    case 'HH':
                        return tf(t.getHours());
                        break;
                    case 'ss':
                        return tf(t.getSeconds());
                        break;
                }
            })
        };

        //格式化文件大小
        function renderSize(value) {
            if (null == value || '' === value) {
                return "0 Bytes";
            }
            var unitArr = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
            var index = 0;
            var srcsize = parseFloat(value);
            index = Math.floor(Math.log(srcsize) / Math.log(1024));
            var size = srcsize / Math.pow(1024, index);
            size = size.toFixed(2);//保留的小数位数
            return size + unitArr[index];
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
            //打开之前加载select
            $('#filetype').combobox({
                url: 'fileType/listFileType',
                method: 'get',
                valueField: 'id',
                textField: 'text',
                panelHeight: 'auto',
                editable: false,
                // readonly: 'true',
                onChange: function () {
                    console.log('changed');
                    var getText = $('#type').combobox('getText');
                    var getValue = $('#type').combobox('getValue');
                    console.log('索引名称:' + getText + ', 索引docId:' + getValue);
                }
            });

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
            // $('#saveFolder-button').linkbutton('enable');
            var node = $('#' + treeId).tree('getSelected');
            var node2 = $('#tt').tree('getSelected');

            if (node2 == null) {
                message_Show('请选择index库');
                return;
            }
            if (node == null) {
                node = {id: 'root'}
            }
            $('#folder_dialog_form').form('clear');
            $('#folder_dialog_form').form('load', {
                pid: node.id,
                indexName: node2.text

            });
            $('#folder_dialog').dialog('open').dialog('center').dialog('setTitle', '新建文件夹');
        }

        /**
         * 编辑目录
         */
        //打开
        function editFolder() {
            // $('#saveFolder-button').linkbutton('enable');
            var node = $('#' + treeId).tree('getSelected');
            var node2 = $('#tt').tree('getSelected');
            if (node2 == null) {
                message_Show('请选择有效的目录');
                return;
            }

            //如果选择的是根节点,
            if (('000000000000000000') === (node.pid)) {
                message_Show('当前节点禁止编辑, 请重新选择');
                return;
            }

            $('#folder_dialog_form').form('clear');
            $('#folder_dialog_form').form('load', {
                id: node.id,
                pid: node.pid,
                text: node.text,
                url: node.url,
                status: node.status,
                state: node.state,
                indexName: node2.text
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
                        url: 'menu/delete',
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
        var menu_submit_flag = true;//用来防止多次点击发送请求

        function folder_dialog_ok() {
            if (menu_submit_flag) {
                menu_submit_flag = false;
                $("#folder_dialog_form").form("submit", {
                    url: "menu/submit",
                    onSubmit: function () {
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
                        menu_submit_flag = true;
                    },
                    error: function () {
                        $.messager.alert("系统提示", "异常，请重新的登录后尝试!");
                    }
                });
            }
        }


        //取消
        function folder_dialog_close() {
            $('#folder_dialog').dialog('close');
        }

        //文件上传界面保存按钮
        var file_upload_flag = true;

        function file_dialog_ok() {
            if (file_upload_flag) {
                file_upload_flag = false;

                //组装数据
                var formData = new FormData();
                var node = $('#' + treeId).tree('getSelected');
                var menuId = node.id;
                formData.append('file', $('#file')[0].files[0]);
                formData.append('menuId', menuId);
                formData.append('keyword', $('#keyword').val());
                formData.append('author', $('#author').val());
                formData.append('professional', $('#professional').val());
                formData.append('switchbutton', $('#switchbutton').val());
                formData.append('filetype', $('#filetype').val());

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
                        file_upload_flag = true;
                    }
                });
            }
        }

        //取消
        function file_dialog_close() {
            $('#file_dialog').dialog('close');
        }

        /**
         * 文件离散接口
         *
         * @param fileInfo
         */
        function fileSpread(fileInfo) {
            console.log(fileInfo);

            $.ajax({
                url: 'file/fileAnalyzer',
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                data: JSON.stringify(fileInfo),
                // async: false,
                contentType: "application/json",
                success: function (result) {
                    //成功后右下角窗口提醒
                    message_Show(result.message)
                },
                error: function () {
                    alert('文件离散失败, 改文件可能是只读文件, 不可执行其他操作')
                }
            })
        }

        //index操作

        /**
         *加载索引列表的树形菜单,
         *  加载完成后, 选中第一条数据
         *  将索引库名称显示在顶部
         */
        function loadTree() {

            $('#tt').tree({
                url: 'indexMenu/listIndexMenu',
                method: 'get',
                onClick: function (node) {
                    // alert(node.text)

                    //将索引名称显示在顶部
                    document.getElementById("indexName").innerHTML = "";
                    $('#indexName').append('<span>' + node.text + '</span>')

                    //获取上树
                    getTree();
                },
                //加载完tree型菜单后, 选中第一条数据
                onLoadSuccess: function (node, data) {
                    //什么都不干

                    if (data.length > 0) {
                        //找到第一个元素
                        var n = $('#tt').tree('find', data[0].id);
                        //调用选中事件
                        $('#tt').tree('select', n.target);

                        getTree();

                        //将索引库名称显示在顶部
                        document.getElementById("indexName").innerHTML = "";
                        $('#indexName').append('<span>' + data[0].text + '</span>')
                    }
                }
            });

            /**
             * 提交按钮绑定
             * 2019年10月15日
             */
            $('#btnSaveIndex').bind('click', function () {
                //把表单数据转换成json对象
                // var data = JSON.stringify($('#saveIndex').serializeJSON());
                $('#saveIndex').form('submit', {
                    url: 'indexMenu/create',
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

        }


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
                            url: 'indexMenu/delete?indexName=' + node.text,
                            dataType: 'json',
                            type: 'POST',
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
    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="easyui-layout" style="width: 200px; height: 100%;">
        <div data-options="region:'north'" style="height: 50%;">
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
        <div data-options="region:'south'" style="height: 50%">
            <%--操作栏--%>
            <div style="margin:5px 0;border-bottom:1px ">
                <div id="toolbar3">
                    <img src="images/px-icon/shuaxin.png" style="padding:0 10px"
                         class="easyui-tooltip div-toolbar-img-first"
                         onclick="$('#tt').tree('reload');" title="刷新">
                    <img src="images/px-icon/newFolder.png" style="padding: 0px 10px;"
                         class="easyui-tooltip div-toolbar-img-next"
                         onclick="addIndex()" title="新建索引">
                    <img src="images/px-icon/shanchu.png" style="padding: 0px 10px;"
                         class="easyui-tooltip div-toolbar-img-next"
                         onclick="deleteIndex()" title="删除索引">
                </div>
            </div>

            <div id="nav">
                <ul id="tt"></ul>
            </div>
        </div>
    </div>
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

<%--新增文件--%>
<div id="file_dialog" class="easyui-dialog"
     data-options="closed:true, modal:true,border:'thin', buttons:'#file_dialog_button'">
    <form id="file_dialog_upload" method="post" enctype="multipart/form-data">

        <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;">
            <input id="menuId" name="menuId" type="hidden">

            <tr>
                <td>
                    作者
                </td>
                <td>
                    <input id="author" class="easyui-textbox" style="width:100%;"
                           name="author">
                </td>
            </tr>

            <tr>
                <td>
                    文档类型
                </td>
                <td>
                    <input id="filetype" class="easyui-combobox" style="width:100%;"
                           name="filetype"/>
                </td>
            </tr>

            <tr>
                <td>
                    专业
                </td>
                <td>
                    <input id="professional" class="easyui-textbox" style="width:100%;"
                           name="professional">
                </td>
            </tr>

            <tr>
                <td class="pe-label">
                    <span class="sp_waning">
                       <%--<input id="switchbutton" name="switchbutton" class="easyui-switchbutton" data-options="onText:'摘要',offText:'关键词', ">--%>
                        摘要或关键词
                    </span>
                </td>
                <td class="pe-content" colspan="6">
                    <input id="keyword" class="easyui-textbox" name="keyword" style="width:100%;height:60px"
                           data-options="multiline:true,prompt:'...'">
                </td>
            </tr>
            <tr>
                <td class="pe-label">文 件 上 传：</td>
                <td class="pe-content" colspan="6">
                    <input id="file" name="file" class="easyui-file" type="file"
                           style="width:100%">
                </td>
            </tr>
        </table>

    </form>
    <div id="file_dialog_button" class="pxzn-dialog-buttons">
        <input type="button" onclick="file_dialog_ok()" value="保存" class="pxzn-button">
        <input type="button" onclick="file_dialog_close()" value="取消" style="margin-left:40px;"
               class="pxzn-button">
    </div>
</div>

<%-- 创建索引库 --%>
<div id="saveIndexDlg">
    <form id="saveIndex" method="post">
        <%--<input name="uuid" type="hidden">--%>
        <table>
            <tr>
                <td>索引名称</td>
                <td><input name="indexName" class="easyui-validatebox"
                           data-options="required:true,missingMessage:'索引名称不能为空!'" placeholder=""></td>
            </tr>
        </table>
        <button id="btnSaveIndex" type="button">保存</button>
    </form>
</div>

</body>
</html>
