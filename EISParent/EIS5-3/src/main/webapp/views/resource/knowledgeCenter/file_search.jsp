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
            // searchFile();
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
                url: 'fileSearch/fileList',
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
            uploadUser: null
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
                var time = data[i].creationTime;
                //格式化日期
                var dateFormat = formatDate(time, 'yyyy-MM-dd HH:mm:ss');
                //作者
                var author = data[i].uploadUser == null ? '佚名' : data[i].uploadUser;
                //正文
                var content = data[i].content == null ? '' : data[i].content;
                //文件名
                var filename = data[i].fileName == null ? '' : data[i].fileName;
                //关键词
                var keyword = data[i].keyword == null ? '' : data[i].keyword;

                var pageNO = data[i].pageNO == null ? '' : data[i].pageNO;

                var fileId = '\'' + data[i].fileId + '\'';

                var wordCount = data[i].wordCount == null ? '无' : data[i].wordCount;
                //文档路径
                var pdfFilePath = data[i].pdfFilePath == null ? 'javaScript:void(0)' : data[i].pdfFilePath;
                $('#dataList').append(' <li value="' + i + '">\n' +
                    '            <dt>\n' +
                    '                <p class="fl">\n' +
                    '                    <a onclick="file_show(' + fileId + ', ' + pageNO + ')" href="javaScript:void(0)"\n' +
                    '                       title="' + filename + '" style="font-size: 15px">\n' +
                    '                        ' + filename + '\n' +
                    '                    </a> (词频: ' + wordCount + ')\n' +
                    '                </p>\n' +
                    '                <p style="color: grey;font-size: 5px;" class="fr">关键词:\n' +
                    '                    <span class="score">' + keyword + '</span>\n' +
                    '                </p>\n' +
                    '            </dt>\n' +
                    '            <dt class="fl">\n' +
                    '                <p style="font-size: 10px">' + content + '......</p>\n' +
                    '                <div style="color: grey;font-size: 5px;">\n' +
                    '                    ' + dateFormat + '\n' +
                    '                    <i> &nbsp;&nbsp;&nbsp; </i><i>&nbsp;&nbsp;&nbsp;</i>' + data[i].downloadCount + '次下载<i>&nbsp;&nbsp;&nbsp; </i>\n' +
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

<div data-options="region:'center'">
    <div id="permissionSet_dg_toolbar">
        <div class="datagrid-title-div"><span>文件列表</span></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#'+datagridId1).datagrid('reload');" title="刷新">
        <%--&lt;%&ndash; 搜索框 &ndash;%&gt;--%>
        <%--<a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton"--%>
           <%--style="float: right;margin-top: 8px;margin-right: 20px;width:80px" onclick="searchFile()">查询文档</a>--%>
        <%--<input id="search" class="div-toolbar-span" style="float: right;margin-top: 8px;width:200px;height:25px"/>--%>

    </div>
    <div style="width: 90%;">
        <div id="dataParent">
            <%-- 搜索框 --%>
            <input id="search" class="div-toolbar-span" style="margin-top: 10px;width:200px;height:25px"/>
            <a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton"
            style="width:80px" onclick="searchFile()">查询文档</a>

            <ul id="dataList"></ul>
        </div>
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

</body>
</html>
