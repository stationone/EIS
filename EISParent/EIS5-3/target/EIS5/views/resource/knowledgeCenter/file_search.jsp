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
            $.ajax({
                url: 'file/fileList?menuId=' + menuId,
                method: 'GET',
                contentType: 'application/json',
                success: function (result) {
                    dataShow(result);
                }
            })

        }

        /**
         * 数据展示
         */
        function dataShow(result) {
            if (result === null) {
                return;
            }
            if (result.total === 0) {

            }
            /*
            authorName: null
            content: "说明：
            ↵这里搭建的是一个简单的集群，没有做集群节点角色的区分，所以 3个节点默认
            ↵的角色有主节点、<tag style="color: red;">数据</tag>节点、协调节点
            ↵选举 ES 主节点的逻辑：
            ↵选举的大概逻辑，它会根据分片的<tag style="color: red;">数据</tag>的前后新鲜程度来作为选举的一个重要逻（日志、<tag style="color: red;">数据</tag>、时间都会作为集群 master 全局的重要指标）
            ↵因为考虑到数据一致性问题，当然是用最新的<tag style="color: red;">数据</tag>节点作为 master，然后进行
            ↵新<tag style="color: red;">数据</tag>的复制和刷新其他 node。"
            creationTime: 1574424767753
            directoryNodeIds: "29,30,"
            downloadCount: 0
            fileId: "1911222012753723197"
            fileName: "测试6.docx"
            keyword: ""
            knowledge: null
            nodeList: null
            pageNO: 12
            pageTotal: 13
            path: "E:/knowledgeCenterPdfFile/254613f9925a078a587cbf1cf24b56d8/254613f9925a078a587cbf1cf24b56d8_12.pdf"
            pdfPage: "E:\knowledgeCenterPdfFile\254613f9925a078a587cbf1cf24b56d8\254613f9925a078a587cbf1cf24b56d8_12.pdf"
            tNO: 1911222014472415000
           */

            //清除
            $('#dataList').remove();
            //创建
            $('#dataParent').append('<ul id="dataList">\n' +
                '        <%--正文内容--%>\n' +
                '    </ul>');
            //遍历
            var data = result.rows;

            for (var i = 0; i < result.total; i++) {
                var time = data[i].creationTime
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
                //文档路径
                var pdfFilePath = data[i].pdfFilePath == null ? 'javaScript:void(0)' : data[i].pdfFilePath;
                $('#dataList').append(' <li value="' + i + '">\n' +
                    '            <dt>\n' +
                    '                <p class="fl">\n' +
                    '                    <a href="../knowledgeCenterFileManger/htmlFile.htm"\n' +
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
            console.log(node.id)
            $('#file_dialog').dialog('open').dialog('center').dialog('setTitle', '文件上传');
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
                    alert('文件离散失败')
                }
            })
        }

    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">

<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        资源目录
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('permissionSet_layout','west')"
             class="layout-title-img">
    </div>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#'+treeId).tree('reload')" title="刷新">
            <img src="images/px-icon/newFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
                 onclick="newFolder()" title="添加">
            <img src="images/px-icon/editFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
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

    <%--<jsp:include page="/px-tool/px-datagrid.jsp">--%>
    <%--<jsp:param value="<%=datagridId1%>" name="div-id"/>--%>
    <%--</jsp:include>--%>

    <%--数据列表 (当前目录里边的所有文档)--%>
    <%--<div id="datalist" class="easyui-datalist" title="文件列表" style="width:100%; height:80%">--%>


    <%--<li value="2">--%>
    <%--<dt>--%>
    <%--<p class="fl">--%>
    <%--<a href="#"--%>
    <%--title="2018年最新房本翻译件(不动产权证) 申请英国欧洲签..." style="font-size: 15px">--%>
    <%--2018年最新房本翻译件(不动产权证) 申请英国欧洲签...标题--%>
    <%--</a>--%>
    <%--</p>--%>
    <%--<p class="fr">关键词:--%>
    <%--<span class="score">没有关键词</span>--%>
    <%--</p>--%>
    <%--</dt>--%>
    <%--<dd class="clearfix">--%>
    <%--<p style="font-size: 10px">2018年最新房本翻译件(不动产权证) 申请英国欧洲签证用 正文- Cover: <em>Page</em>1--%>
    <%--ThePeople’sRepublicofChina--%>
    <%--RealPropertyOwnershipCe...</p>--%>
    <%--<div style="color: grey;font-size: 5px;">--%>
    <%--2019-11-16--%>
    <%--<i>|</i>共7页<i>|</i>0次下载<i>|</i>--%>
    <%--0下载券<i>|</i>--%>
    <%--作者：<a href="#">--%>
    <%--暂时没有作者--%>
    <%--</a>--%>
    <%--</div>--%>
    <%--</dd>--%>
    <%--</li>--%>
    <%--</div>--%>

    <div id="dataParent">
        <ul id="dataList">
            <%--正文内容--%>
        </ul>
    </div>
    <%--<script>--%>
    <%--for (var i = 0; i < 9; i++) {--%>

    <%--}--%>
    <%--//直接添加--%>
    <%--$('#dataList').append(' <li value="2">\n' +--%>
    <%--'            <dt>\n' +--%>
    <%--'                <p class="fl">\n' +--%>
    <%--'                    <a href="#"\n' +--%>
    <%--'                       title="2018年最新房本翻译件(不动产权证) 申请英国欧洲签..." style="font-size: 15px">\n' +--%>
    <%--'                        2018年最新房本翻译件(不动产权证) 申请英国欧洲签...标题\n' +--%>
    <%--'                    </a>\n' +--%>
    <%--'                </p>\n' +--%>
    <%--'                <p class="fr">关键词:\n' +--%>
    <%--'                    <span class="score">没有关键词</span>\n' +--%>
    <%--'                </p>\n' +--%>
    <%--'            </dt>\n' +--%>
    <%--'            <dd class="clearfix">\n' +--%>
    <%--'                <p style="font-size: 10px">2018年最新房本翻译件(不动产权证) 申请英国欧洲签证用 正文- Cover: <em>Page</em>1\n' +--%>
    <%--'                    ThePeople’sRepublicofChina\n' +--%>
    <%--'                    RealPropertyOwnershipCe...</p>\n' +--%>
    <%--'                <div style="color: grey;font-size: 5px;">\n' +--%>
    <%--'                    2019-11-16\n' +--%>
    <%--'                    <i>|</i>共7页<i>|</i>0次下载<i>|</i>\n' +--%>
    <%--'                    0下载券<i>|</i>\n' +--%>
    <%--'                    作者：<a href="#">\n' +--%>
    <%--'                    暂时没有作者\n' +--%>
    <%--'                </a>\n' +--%>
    <%--'                </div>\n' +--%>
    <%--'            </dd>\n' +--%>
    <%--'        </li>');--%>

    <%--</script>--%>

    <%--<dl>--%>
    <%--<dt class="logFirstClickTime mb6 clearfix">--%>
    <%--<p class="fl">--%>
    <%--<span title="doc" class="ic ic-doc"></span>--%>
    <%--<a href="https://wenku.baidu.com/view/19525066ab00b52acfc789eb172ded630a1c986e.html?from=search"--%>
    <%--data-flag="25" title="2018年最新房本翻译件(不动产权证) 申请英国欧洲签证用" target="_blank" data-docid="7011933507"--%>
    <%--data-edocid="19525066ab00b52acfc789eb172ded630a1c986e" class="log-xsend tiaoquan act-xsend"--%>
    <%--data-index="7"--%>
    <%--data-logxsend="[1, 100055, {&quot;score_mode&quot;: &quot;4&quot;, &quot;price_data&quot;: &quot;25&quot;, &quot;doc_id&quot;: &quot;7011933507&quot;, &quot;index&quot;:&quot;8&quot;, &quot;page_number&quot;:&quot;&quot;, &quot;small_flow_flag&quot;: &quot;&quot;}]">--%>
    <%--2018年最新房本翻译件(不动产权证) 申请英国欧洲签...--%>
    <%--</a>--%>
    <%--</p>--%>
    <%--<p class="fr">--%>
    <%--<span class="score">暂无评分</span>--%>
    <%--</p>--%>
    <%--</dt>--%>
    <%--<dd class="clearfix">--%>
    <%--<div class="summary-box fl">--%>
    <%--<p class="summary lh21">2018年最新房本翻译件(不动产权证) 申请英国欧洲签证用 - Cover: <em>Page</em>1 ThePeople’sRepublicofChina--%>
    <%--RealPropertyOwnershipCe...</p>--%>
    <%--<div class="detail lh21">--%>
    <%--<div class="detail-info">--%>
    <%--2019-11-16--%>
    <%--<i>|</i>共7页<i>|</i>0次下载<i>|</i>--%>
    <%--0下载券<i>|</i>--%>
    <%--贡献者：<a href="/u/ok欣欣向荣369?from=wenku" data-logsend="{'send':['view','user',{l:''}]}"--%>
    <%--class="Author logSend" target="_blank">--%>
    <%--ok欣欣向荣369--%>
    <%--</a>--%>
    <%--</div>--%>
    <%--<div class="summary-recommend clearfix"></div>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--</dd>--%>
    <%--</dl>--%>
</div>


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

</body>
</html>
