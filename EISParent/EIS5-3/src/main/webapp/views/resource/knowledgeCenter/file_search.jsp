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
            var resu = param_sub();
            // alert(resu);
            //设置value
            $("#search").attr("value", resu.search);
            //调用搜索接口
            // searchFile(1, 10);
            loadTree();
        });

        /**
         *加载索引列表的树形菜单,
         *  加载完成后, 选中第一条数据
         *  将索引库名称显示在顶部
         */
        function loadTree() {
            $('#tt').tree({
                url: 'indexMenu/listIndexMenu',
                method: 'POST',

                onClick: function (node) {
                    // alert(node.text)

                    // //将索引名称显示在顶部
                    // document.getElementById("indexName").innerHTML = "";
                    // $('#indexName').append('<span>' + node.text + '</span>')
                    //
                    // //获取上树
                    // getTree();
                },
                //加载完tree型菜单后, 选中第一条数据
                onLoadSuccess: function (node, data) {
                    //什么都不干

                    // if (data.length > 0) {
                    //     //找到第一个元素
                    //     var n = $('#tt').tree('find', data[0].id);
                    //     //调用选中事件
                    //     $('#tt').tree('select', n.target);
                    //
                    //     getTree();
                    //
                    //     //将索引库名称显示在顶部
                    //     document.getElementById("indexName").innerHTML = "";
                    //     $('#indexName').append('<span>' + data[0].text + '</span>')
                    // }
                }
            });
        }

        /**
         * 网页跳转携带参数处理
         */
        function param_sub() {
            var url = location.search; //获取url中"?"符后的字串, 包含?
            console.log(url);
            var theRequest = new Object();
            if (url.indexOf("?") != -1) {
                var str = url.substr(1);
                strs = str.split("&");
                for (var i = 0; i < strs.length; i++) {
                    theRequest[strs[i].split("=")[0]] = decodeURIComponent(strs[i].split("=")[1]);
                }
            }
            return theRequest;
        }

        /**
         * 搜索
         */
        function searchFile(page, rows) {
            //获取input中的值
            var search = document.getElementById('search').value;
            // $('#mygrid').datagrid('reload', {json: JSON.stringify({search:search})});
            var searchJson = JSON.stringify({search: search});
            console.log(searchJson);
            $.ajax({
                url: 'fileSearch/fileList',
                method: 'GET',
                contentType: 'application/json',
                data: 'search=' + search + "&page=" + page + "&size=" + rows,
                dataType: 'json',
                success: function (result) {
                    dataShow(result);

                    //分页栏
                    $('#pagination').pagination({
                        total: result.total,
                        pageSize: [10, 20, 30, 40, 50],
                        /*
                            list：页面尺寸列表。
                            sep：页面按钮分割。
                            first：第一个按钮。
                            prev：前一个按钮。
                            next：后一个按钮。
                            last：最后一个按钮。
                            refresh：刷新按钮。
                            manual：允许输入域页码的手动页码输入框。
                            links：页码链接。
                         */
                        // layout:['sep','first','prev','links','next','last','manual','list','refresh'],//
                        onSelectPage: function (page, size) {
                            searchFile(page, size);
                            // $('#content').panel('refresh', 'show_content.php?page='+pageNumber);
                        }
                    });
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
            if (result.total === 0) {

            }
            //清除
            $('#dataList').remove();
            //创建
            $('#dataParent').append('<ul id="dataList">\n' +
                '        <%--正文内容--%>\n' +
                '    </ul>');
            //遍历
            var data = result.rows;
            if (data.length === 0) {
                return
            }
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
    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <%--<div class="layout-title-div">--%>
    <%--ES索引--%>
    <%--<img src="images/px-icon/hide-left-black.png" onclick="layoutHide('resource_admin_layout','west')"--%>
    <%--class="layout-title-img">--%>
    <%--</div>--%>
    <%--操作栏--%>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px"
                 class="easyui-tooltip div-toolbar-img-first"
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

    <%--<div style="margin-top: 10px;"></div>--%>
    <div style="width: 90%;">
        <div id="permissionSet_dg_toolbar">
            <%--<div class="datagrid-title-div"><span>文件列表</span></div>--%>
            <%--<div style="float: left;">--%>
                <%--<img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"--%>
                     <%--onclick="$('#'+datagridId1).datagrid('reload');" title="刷新">--%>
            <%--</div>--%>

            <%--<div style="float: right;">--%>
                <%--&lt;%&ndash; 搜索框 &ndash;%&gt;--%>
                <%--<input id="search" class="div-toolbar-span"--%>
                       <%--style="margin-right: 5px;margin-top: 2px; width:300px;height:30px"/>--%>
                <%--<a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton"--%>
                   <%--style="width:80px;height: 29px;" onclick="searchFile(1,10)">搜索</a>--%>
            <%--</div>--%>

                <table style="width: 100%;">
                    <tr>
                        <td>
                            <div style="float: left;">
                                <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
                                     onclick="$('#'+datagridId1).datagrid('reload');" title="刷新">
                            </div>
                        </td>
                        <td style="text-align: right;margin-right: 0px;">
                            <div style="float: right;">
                                <%-- 搜索框 --%>
                                <input id="search" class="div-toolbar-span"
                                       style="margin-right: 5px;margin-top: 2px; width:300px;height:30px"/>
                                <a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton"
                                   style="width:80px;height: 29px;" onclick="searchFile(1,10)">搜索</a>
                            </div>
                        </td>
                    </tr>
                </table>
        </div>

        <%--//正文--%>
        <div id="dataParent">
            <ul id="dataList"></ul>
        </div>
        <div style="margin:20px 0;"></div>
        <%--分页栏--%>
        <div id="pagination"></div>
    </div>

</div>
</body>
</html>
