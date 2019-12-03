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
             * 获取树目录
             */
            $('#' + treeId).tree({
                url: 'menu/listTree',
                method: "get",
                checkbox: false,
                multiple: false,
                onClick: function (node) {
                    //点击事件 获取dataList
                    loadDataList(node.id)
                }
            });
        });

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

                /*
                "id": "1912021334119160534",
                "hashCode": "25a8981c7cd501cd54055ad91db06a04",
                "file": null,
                "fileName": "ES说明V4.docx",
                "filePath": "E:/knowledgeCenterFileManger/word/ES说明V4.docx",
                "fileNameSuffix": "docx",
                "fileNamePrefix": "ES说明V4",
                "creationTime": 1575264896119,
                "lastAccessTime": null,
                "fileSize": 47975,
                "pageTotal": 13,
                "keyword": "ES说明开发说明",
                "content": "1:关于 ES： \r\nElasticsearch 是 面 向 文 档 型 数 据 库 ， 一 条 json 数 据 就 是 一 个 文 档 ， 例 ：\r\n \r\nElasticsearch ⇒索引(Index) ⇒类型(type)⇒文档(Documents)⇒字段(Fields) \r\n因为在 ES 的后续版本中去掉了 Type，所以一个 Index 只能存储一个类型的对象，类比\r\nmysql中的一张表。一个 Document则类比为 mysql中的一行数据。 \r\n2: Mapping的说明： \r\n在 ES中， Mapping的作用就是约束，用来定义 index（这个是 Document？是\r\nindex，类比 mysql中的一张表）下的字段名， \r\n定义字段类型，比如数值型、浮点型、布尔型等 \r\n定义倒排索引相关的设置，比如是否索引、分词方式等 \r\n \r\n其中“analyzer”即为分词方式， “store”为是否存储默认 false，“type”为字段\r\n类型，text即文本，keyword即主键。 \r\n注： \r\n......",
                "menuId": "1911291618059855632",
                "authorName": null,
                "pageList": null,
                "pageIds": "1912021335687882073,1912021336853034301,1912021336447147905,1912021336338270572,1912021336979173966,1912021336737549641,1912021336977084038,1912021336424251953,1912021337123468930,1912021337534860778,1912021337373429448,1912021337211524568,1912021337080393874,",
                "pdfFilePath": "E:/knowledgeCenterFileManger/webDoc/25a8981c7cd501cd54055ad91db06a04/25a8981c7cd501cd54055ad91db06a04.pdf",
                "downloadPath": null,
                "fileHtml": null,
                "filePdf": "../knowledgeCenterFileManger/webDoc/25a8981c7cd501cd54055ad91db06a04/25a8981c7cd501cd54055ad91db06a04.pdf",
                "downloadCount": 0,
                "fileId": "1912021334119160534"
            }
                 */
                columns: [[
                    {field: 'fileName', title: '名称', width: 180, align: 'center'},
                    {field: 'fileNameSuffix', title: '类型', width: 180, align: 'center'},
                    {field: 'keyword', title: '关键词', width: 180, align: 'center'},

                    {field: 'pageTotal', title: '页面总数', width: 180, align: 'center'},
                    {
                        field: 'creationTime', title: '创建时间', width: 180, align: 'center',
                        formatter: function (value) {
                            var date = new Date(value);
                            var y = date.getFullYear();
                            var M = date.getMonth() + 1;
                            var d = date.getDate();
                            var H = date.getHours();
                            var m = date.getMinutes();
                            var s = date.getSeconds();
                            return y + '-' + M + '-' + d + ' ' + H + ':' + m + ':' + s;
                        }
                    },
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
                    {field: 'authorName', title: '作者', width: 180, align: 'center'},
                    {field: 'content', title: '摘要', width: 300, align: 'center'},
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

        function h() {
            alert("失败")
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
            <%--//清除--%>
            <%--$('#dataList').remove();--%>
            <%--//创建--%>
            <%--$('#dataParent').append('<ul id="dataList">\n' +--%>
            <%--'        &lt;%&ndash;正文内容&ndash;%&gt;\n' +--%>
            <%--'    </ul>');--%>
            // $('#dataList').append('我就是文件, 你要预览的就是我');
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
            if (node == null) {
                message_Show('请选择父级目录');
                return;
            }
            $('#folder_dialog_form').form('clear');
            $('#folder_dialog_form').form('load', {
                pid: node.id
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
            if (node == null) {
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
                state: node.state
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
        var isClick = true;//手动延迟

        function folder_dialog_ok() {
            if (isClick) {
                isClick = false;
                //提交表单事件
                // console.log($(this).attr("data-val"));
                $("#folder_dialog_form").form("submit", {
                    url: "menu/submit",
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
                    },
                    error: function () {
                        $.messager.alert("系统提示", "异常，请重新的登录后尝试!");
                    }
                });

                //定时器
                setTimeout(function () {
                    isClick = true;
                }, 1000);//一秒内不能重复点击
            }
        }


        //取消
        function folder_dialog_close() {
            $('#folder_dialog').dialog('close');
        }

        //文件上传界面保存按钮
        function file_dialog_ok() {
            if (isClick) {
                isClick = false;

                //组装数据
                var formData = new FormData();
                var node = $('#' + treeId).tree('getSelected');
                var menuId = node.id;
                formData.append('file', $('#file')[0].files[0]);
                formData.append('menuId', menuId);
                formData.append('keyword', $('#keyword').val());

                // console.log(formData);

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
                    }
                });
                //定时器
                setTimeout(function () {
                    isClick = true;
                }, 1000);//一秒内不能重复点击
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
        $('#tt').tree({
            url: 'indexMenu/listIndexMenu',
            method: 'get',
            onClick: function (node) {
                alert(node.text)
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
        <div class="datagrid-title-div"><span>文件列表</span></div>
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
                <td class="pe-label"><span class="sp_waning"></span>简介(关键词)：</td>
                <td class="pe-content" colspan="6">
                    <input id="keyword" class="easyui-textbox" name="keyword" style="width:100%;height:60px"
                           data-options="multiline:true,prompt:'随便写点儿介绍关键词什么的用于被检索...'">
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

</body>
</html>
