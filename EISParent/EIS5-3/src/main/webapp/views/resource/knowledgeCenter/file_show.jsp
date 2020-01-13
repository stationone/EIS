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
    <link rel="stylesheet" type="text/css" href="ui/themes/icon.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/pxzn.util.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>


    <script>
        var treeId = "<%=treeId%>";
        var datagridId1 = "<%=datagridId1%>";

        /**
         * 入口函数
         */
        $(function () {
            //获取页面跳转携带的参数
            var resu = param_sub();

            console.log(resu);
            docShow(resu.fileId);

            //监听鼠标
            // mouseEnter();
            // select_indexName();

            file_type();

            $("#reviewInfoList").datagrid({
                url: 'review/reviewInfoList?fileId=' + resu.fileId,
                method: 'GET',
                contentType: 'application/json',
                dataType: 'json',
                columns: [[
                    // {field: 'rejectCount', title: '审批次数', width: 80, align: 'center'},
                    {field: 'reviewer', title: '审批人', width: 100, align: 'center'},
                    {
                        field: 'status', title: '审核结果', width: 100, align: 'center',
                        formatter: function (value) {
                            if (value === '3') {
                                return '<span style="color:red;">驳回</span>'
                            } else {
                                return '<span style="color:green;">入库</span>'
                            }

                        }
                    },
                    {field: 'reviewIdea', title: '审批意见', width: 200, align: 'left'},

                ]],

                rownumbers: true,
                singleSelect: true,
                readonly: true,
                collapsible: true,
                nowrap: true,
                // striped: true,
                loading: true,
                fit: true,//自适应高度
                emptyMsg: "没有获取到数据",
                loadMsg: "正在努力加载数据,表格渲染中...",
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                onLoadSuccess: function (data) {
                    //固定表格
                    $('#reviewInfoList').datagrid('fixRowHeight');
                },
                onLoadError: function () {
                    // clearDataGrid();
                }
            })


            //初始化审核窗口
            $('#reviewDlg').dialog({
                title: '审核',//窗口标题
                width: 500,
                height: 300,
                // height: 100,//窗口高度
                closed: true,//窗口是是否为关闭状态, true：表示关闭
                // modal: true//模式窗口
            });
            //按钮绑定
            $('#agree').bind('click', function () {

                $.messager.confirm('继续操作', '确定执行<span style="color: green;">入库</span>操作吗?', function (r) {
                    if (r) {

                        //表单数据设置(fileId, status)
                        $('#review_form').form('load', {
                            status: '4',
                        });

                        //做表单字段验证，当所有字段都有效的时候返回true。该方法使用validatebox(验证框)插件。
                        var isValid = $('#review_form').form('validate');
                        // alert(isValid);
                        if (isValid == false) {
                            return;
                        }
                        //提交表单
                        $('#review_form').form('submit', {
                            url: 'review/save',
                            type: 'post',
                            success: function (data) {
                                var data = eval('(' + data + ')');
                                $.messager.alert("提示", data.message, 'info', function () {
                                    //成功的话，我们要关闭窗口
                                    $('#reviewDlg').dialog('close');
                                    //刷新
                                    // $("#mygrid").datagrid('reload');
                                    location.reload();
                                    //入库离散检索
                                    //审核入库, 解析
                                    var fileInfo = data.data;
                                    fileSpread(fileInfo.fileId);
                                });
                            }
                        });
                    }

                })
            });

            $('#disagree').bind('click', function () {
                $.messager.confirm('继续操作', '确定执行<span style="color: red;">驳回</span>操作吗?', function (r) {
                    if (r) {

                        //表单数据设置(fileId, status)
                        $('#review_form').form('load', {
                            status: '3',
                        });
                        //做表单字段验证，当所有字段都有效的时候返回true。该方法使用validatebox(验证框)插件。
                        var isValid = $('#review_form').form('validate');
                        // alert(isValid);
                        if (isValid == false) {
                            return;
                        }
                        //提交表单
                        $('#review_form').form('submit', {
                            url: 'review/save',
                            type: 'post',
                            success: function (data) {
                                var data = eval('(' + data + ')');
                                $.messager.alert("提示", data.message, 'info', function () {
                                    //成功的话，我们要关闭窗口
                                    $('#reviewDlg').dialog('close');
                                    //刷新
                                    // $("#mygrid").datagrid('reload');
                                    location.reload();
                                });
                            }
                        });
                    }
                })
            });


        })
        ;

        function review_button() {
            //窗口打开前加载表单数据
            //获取该文档的id值
            var data = ($('#file_dialog_upload').serializeJSON());
            var fileId = data.fileId;
            // alert(fileId);

            //表单数据设置(fileId, status)
            $('#review_form').form('load', {
                fileId: fileId,
            });
            $('#reviewDlg').dialog('open');
        }

        /**
         * 文件预览
         */
        // function file_show(fileId, pageNo) {
        //     $.ajax({
        //         url: 'file/fileDetail',
        //         method: 'GET',
        //         contentType: 'application/json',
        //         data: 'fileId=' + fileId,
        //         dataType: 'json',
        //         success: function (result) {
        //             //数据展示
        //             dataShow(result, pageNo);
        //         }
        //     });
        //     console.log(fileId, pageNo);
        // }

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

        //文件大小格式化
        function formatSize(value) {
            if (null == value || '' === value) {
                return "0 Bytes";
            }
            var unitArr = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
            var index = 0;
            var srcsize = parseFloat(value);
            index = Math.floor(Math.log(srcsize) / Math.log(1024));
            var size = srcsize / Math.pow(1024, index);
            size = size.toFixed(2);//保留的小数位数
            return size + unitArr[index];
        }

        /**
         * 文档展示
         * @param fileId
         */
        function docShow(fileId) {
            if (fileId == null) {
                return;
            }
            $.ajax({
                url: 'file/fileDetail',
                method: 'GET',
                contentType: 'application/json',
                data: 'fileId=' + fileId,
                dataType: 'json',
                success: function (result) {
                    //其他按钮按状态显隐
                    switch (result.status) {
                        case 1:
                            $('#submit').show();//提交
                            $('#review_button').hide();//入库
                            $('#check').hide();//驳回
                            break;
                        case 2:
                            $('#submit').hide();//提交
                            $('#review_button').show();//入库
                            $('#check').show();//驳回
                            break;
                        case 3:
                            $('#submit').show();//提交
                            $('#review_button').hide();//入库
                            $('#check').hide();//驳回
                            //让驳回高亮
                            break;
                        case 4:
                            $('#submit').hide();//提交
                            $('#review_button').show();//入库
                            $('#check').hide();//驳回
                            break;
                    }
                    if (result.author != null) {
                        var textHtml = '';
                        textHtml += '<tr>';
                        textHtml += '<td class="pe-label" style="width: 40%">文档作者(author)</td>';
                        textHtml += '<td><input id="author" name="author" class="easyui-textbox" style="width:100%;height:25px"></td>';
                        textHtml += '</tr>';
                        $('#filedTable').html(textHtml);
                    }

                    console.log(result);
                    //数据展示
                    // dataShow(result, pageNo);
                    if (result.src != null)
                        $('#preSee').attr('src', result.src); //成功后替换页面
                    //成功后填充表单
                    // var formatDate = formatDate(result.creationTime, 'yyyy-MM-dd HH:mm:dd');
                    // var formatSize = formatSize(result.fileSize);
                    $('#file_dialog_upload').form('load', {
                        keyword: result.keyword,
                        fileAbstract: result.fileAbstract,
                        id: result.id,
                        fileId: result.fileId,
                        menuId: result.menuId,
                        fileNamePrefix: result.fileNamePrefix,
                        hashCode: result.hashCode,
                        src: result.src,
                        webPath: result.webPath,
                        status: formatStatus(result.status),
                        /*
                        formatter: function (value) {//上传中、离散中、待提交、待审核、驳回、入库 6种状态；
                            if (value === 0) {
                                return '离散中';
                            } else if (value === 1) {
                                return '待提交';
                            } else if (value === 2) {
                                return '待审核';
                            } else if (value === 3) {
                                return '驳回';
                            } else if (value === 4) {
                                return '入库';
                            } else {
                                return '上传中';
                            }

                        }
                         */
                        //上边是    隐藏属性
                        fileName: result.fileName,
                        fileSize: formatSize(result.fileSize),//大小需要格式化
                        creationTime: formatDate(result.creationTime, 'yyyy-MM-dd HH:mm:dd'),//日期需要格式化
                        lastUpdateTime: formatDate(result.lastUpdateTime, 'yyyy-MM-dd HH:mm:dd'),//日期需要格式化

                        // creationTime: result.creationTime,
                        filePath: result.filePath,
                        fileNameSuffix: result.fileNameSuffix,
                        indexName: result.indexName,
                        author: result.author,
                        uploadUser: result.uploadUser,
                        //868.80  920.80 3539.30   960 4499.30    6217 0028 3000 7124 573

                    });

                }
            });

        }

        //格式化状态
        function formatStatus(value) {//上传中、离散中、待提交、待审核、驳回、入库 6种状态；
            if (value === 0) {
                return '离散中';
            } else if (value === 1) {
                return '待提交';
            } else if (value === 2) {
                return '待审核';
            } else if (value === 3) {
                return '驳回';
            } else if (value === 4) {
                return '入库';
            } else {
                return '上传中';
            }

        }


        //文件上传界面保存按钮
        var file_upload_flag = true;//用来防止多次点击发送请求的标记
        function file_dialog_ok(status) {
            if (file_upload_flag) {
                file_upload_flag = false;

                var str = JSON.stringify($('#file_dialog_upload').serializeJSON());
                console.log(str);
                $.ajax({
                    url: 'file/fileForm?status=' + status,
                    type: 'POST',
                    dataType: 'JSON',
                    // contentType: 'application/json',
                    data: {json: str},
                    success: function (result) {
                        console.log(result);
                        if (result) {

                        }
                        message_Show(result.message);
                        if (result.success == false) {
                            return;
                        }
                        file_upload_flag = true;
                        //跳转到文件列表页面
                        // window.location.href = "./views/resource/knowledgeCenter/knowledgeCenterMultiple.jsp";

                        //刷新当前页面
                        location.reload();

                        //如果文档入库,调取接口解析文件
                        console.log(result.data);
                        var data = result.data;
                        console.log(data.fileId);
                        if (data.status === 4) {
                            // //审核入库, 解析
                            // fileSpread(data.fileId);
                        }

                    }
                });
            }
        }

        /**
         * 文件离散接口
         *
         * @param fileInfo
         */
        function fileSpread(fileId) {
            console.log(fileId);

            $.ajax({
                url: 'file/fileAnalyzer?fileId=' + fileId,
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                // data: {'fileId': fileId},
                success: function (result) {
                    if (result == null) {
                        return;
                    }
                    //成功后右下角窗口提醒
                    message_Show(result.message);
                },
                error: function () {
                    alert('文件离散失败, 该文件可能是只读文件, 不可执行其他操作')
                }
            })
        }

        function mouseEnter() {
            var tabs = $('#tabs').tabs().tabs('tabs');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].panel('options').tab.unbind().bind('mouseenter', {index: i}, function (e) {
                    $('#tabs').tabs('select', e.data.index);
                });
            }
        };

        function file_type() {
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
                    //选择框值发生改变时

                    $('#filedTable').html('');
                    var getText = $('#filetype').combobox('getText');
                    if (getText == null || getText.length == 0) {
                        return;
                    }
                    console.log(getText);


                    //动态生成表单
                    $.ajax({
                        url: 'file/getFormField?indexName=' + getText,
                        dataType: 'json',
                        success: function (datas) {
                            if (datas.length === 0) {
                                return;
                            }
                            //表单列替换
                            var textHtml = "";
                            var data = datas;
                            for (var i = 0; i < data.length; i++) {
                                var field = data[i];
                                // var ignore = ['content', 'directory', 'discreteTool', 'jsp', 'library', '', 'path', 'type', 'uploadTime', 'lightWeightURL', 'lightWeightConversion'];
                                // if (ignore.indexOf(field.filename) !== -1) {
                                //     continue;
                                // }
                                textHtml += '<tr>';
                                textHtml += '<td class="pe-label" style="width: 40%">' + field.desc + '(' + field.filename + ')</td>';
                                // if (field.filename === 'abstract') {
                                //     textHtml += '<td><input id="' + field.filename + '" name="' + field.filename + '" class="easyui-textbox" style="width:100%;height:25px"  ></td>';
                                // }else {
                                //
                                //     textHtml += '<td><input id="' + field.filename + '" name="' + field.filename + '" class="easyui-textbox" style="width:100%;height:25px"  ></td>';
                                // }
                                textHtml += '<td><input id="' + field.filename + '" name="' + field.filename + '" class="easyui-textbox" style="width:100%;height:25px"  ></td>';
                                textHtml += '</tr>';
                            }
                            // if (temp.length > 0) {
                            //     console.log(temp[0].path);
                            // }

                            $('#filedTable').html(textHtml);
                        }
                    });

                }
            })
        }

        function downloadFile() {
            var fileId = document.getElementById("fileId").value;
            console.log(fileId);
            // return;
            $.ajax({
                url: "file/fileDownload?fileId=" + fileId,
                dataType: 'json',
                type: 'POST',
                contentType: 'application/octet-stream',
                success: function (result) {
                    if (!result.success) {
                        message_Show(result.message)
                    }
                }
            });

            // $("#downloadForm").form("submit", {
            //     url: "file/fileDownload?fileId=" + fileId,
            //     onSubmit: function () {
            //         $.messager.alert('系统提示', '开始下载');
            //         return $(this).form("validate");
            //     },
            //     success: function (data) {
            //         if (data == "") {
            //             serverError();
            //             return;
            //         }
            //         data = eval('(' + data + ')');
            //         data = returnMessager(data);
            //         if (data == null) {
            //             return;
            //         }
            //     }
            // });
        }

        function downloadFileByForm() {
            var str_a = "magnet:?xt=urn:btih:";
            var str_b = "0002405ceeb0de28e3e05ddc901038081a36d99e";
            alert(str_a + str_b);


            //此处data是需要传递的数据
            var fileId = document.getElementById("fileId").value;
            var url = "file/fileDownload"; //提交数据和下载地址
            var form = $("<form></form>").attr("action", url).attr("method", "post");
            //将数据赋值给Input进行form表单提交数据
            form.append($("<input></input>").attr("type", "hidden").attr("name", "fileId").attr("value", fileId));
            form.appendTo('body').submit().remove(); //模拟提交
        }


    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'center'">
    <div class="easyui-layout" data-options="fit:true">

        <div id="permissionSet_dg_toolbar" data-options="region:'north'">

            <div class="datagrid-title-div" style="width: 100%;">
                <span style="width: 70%">文件详情</span>
                <span style="float: right; margin-right: 10px;">
                    <%--<a href="javascript:history.go(-1)">--%>
                    <%--<img src="images/px-icon/zuojiantou.png" style="padding:0 10px;width: 5px;height: 5px;"--%>
                         <%--class="easyui-tooltip div-toolbar-img-first" title="返回">--%>
                <%--</a>--%>
                <%--<a href="javascript:location.reload()">--%>
                    <%--<img src="images/px-icon/shuaxin.png" style="padding:0 10px;margin-left: 5px;"--%>
                         <%--class="easyui-tooltip div-toolbar-img-first" title="刷新">--%>
                <%--</a>--%>
                <%--<a href="javascript:history.go(-2);">返回前两页</a>--%>
                                                <%--// window.location.href = "./views/resource/knowledgeCenter/knowledgeCenterMultiple.jsp";--%>
<%--./views/resource/knowledgeCenter/knowledgeCenterMultiple.jsp--%>
                <a href="./views/resource/knowledgeCenter/knowledgeCenterMultiple.jsp">
                    <img src="images/px-icon/zuojiantou.png"
                         style="padding:0 10px;margin-left: 5px;width: 25px;height: 25px;"
                         class="easyui-tooltip div-toolbar-img-first"
                         title="返回文档管理页">
                </a>
                <%--<a href="javascript:self.location=document.referrer;">--%>
                    <%--<img src="images/px-icon/zuojiantou.png"--%>
                         <%--style="padding:0 10px;margin-left: 5px;width: 25px;height: 25px;"--%>
                         <%--class="easyui-tooltip div-toolbar-img-first"--%>
                         <%--title="返回上一页并刷新">--%>
                <%--</a>--%>
                <a href="javascript:location.reload()">
                    <img src="images/px-icon/shuaxin.png"
                         style="padding:0 10px;margin-left: 5px;width: 25px;height: 25px;"
                         class="easyui-tooltip div-toolbar-img-first" title="刷新">
                </a>
                </span>
            </div>
        </div>
        <div data-options="region:'west'" style="width: 65%;padding-left: 5px">
            <div id="dataParent">
                <div class="easyui-tabs" style="width: 100%;">
                    <div title="文件预览" data-options="closable:false" style="overflow:hidden">
                        <iframe id="preSee" scrolling="yes" frameborder="0"
                                src=""
                                style="width:100%;height:94%;"></iframe>
                    </div>
                </div>
            </div>
        </div>


        <div data-options="region:'east'" style="width:35%">

            <%-- tab页 --%>
            <div data-options="buttons:'#file_dialog_button'">
                <form id="file_dialog_upload" method="post" enctype="multipart/form-data">
                    <%--<input id="menuId" name="menuId" type="hidden">--%>
                    <input id="id" name="id" type="hidden">
                    <input id="fileId" name="fileId" type="hidden">
                    <input id="fileNamePrefix" name="fileNamePrefix" type="hidden">
                    <input id="hashCode" name="hashCode" type="hidden">
                    <input id="src" name="src" type="hidden">
                    <input id="webPath" name="webPath" type="hidden">
                    <input id="status" name="status" type="hidden">
                    <%--<input id="filePath" name="filePath" type="hidden">--%>


                    <div id="tabs" class="easyui-tabs" data-options="tools:'#tab-tools'" style="width:100%;height: 92%">
                        <div title="基本属性" style="padding:10px;">
                            <table cellspacing="10" class="pxzn-dialog-font" style="margin: auto;" width='100%'>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文件名称:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="fileName" class="easyui-textbox"
                                               style="width:90%;padding-left: 5px;"
                                               name="fileName"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文件大小:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="fileSize" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="fileSize"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            创建时间:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="creationTime" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="creationTime"/>
                                        <%--<input class="easyui-datebox" style="width:90%;" name="creationTime"--%>
                                        <%--data-options="formatter:myformatter,parser:myparser" >--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            最后更新时间:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="lastUpdateTime" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="lastUpdateTime"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文件暂存路径 :
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="filePath" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="filePath"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                            文档类型:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="fileNameSuffix" class="easyui-textbox"
                                               style="width:90%;" readonly
                                               name="fileNameSuffix"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                             所属文件库:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input class="easyui-textbox" readonly style="width:90%;padding-left: 5px;"
                                               name="indexName"/>
                                        <%--<input id="indexName" class="easyui-combobox" editable="false"--%>
                                        <%--style="width:90%;" readonly--%>
                                        <%--name="indexName"/>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                             上传人员:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input class="easyui-textbox" readonly style="width:90%;padding-left: 5px;"
                                               name="uploadUser"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pe-label" style="text-align-last:justify;padding-right: 25px">
                                         <span>
                                             状态:
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="detail_status" class="easyui-textbox" readonly
                                               style="width:90%;padding-left: 5px;"
                                               name="status"/>
                                    </td>

                                </tr>

                            </table>
                        </div>
                        <div title="关键词和摘要" data-options="tools:'#tab-tools',closable:false"
                             style="padding:10px;width:100%;height:100%">
                            <table cellspacing="10" class="pxzn-dialog-font" style="margin: auto;" width='100%'>
                                <tr>
                                    <td class="pe-content" colspan="6" aria-colspan="2">
                                        <input id="keyword" label="关键词:" labelPosition="top" class="easyui-textbox"
                                               style="width:90%;height:120px" multiline="true"
                                               name="keyword"/>
                                    </td>
                                </tr>
                                <tr>
                                    <%--<td class="pe-label" style="width: 40%">--%>
                                    <%--摘要--%>
                                    <%--</td>--%>
                                    <td class="pe-content" colspan="6" aria-colspan="2">
                                        <input id="fileAbstract" label="摘要:" labelPosition="top" class="easyui-textbox"
                                               style="width:90%;height:120px" multiline="true"
                                               name="fileAbstract"/>
                                    </td>
                                </tr>

                            </table>
                        </div>
                        <div title="其他属性" data-options="closable:false" style="padding:10px">

                            <table cellspacing="10" class="pxzn-dialog-font" style="margin: auto;" width='100%'>
                                <tr>
                                    <td class="pe-label" style="width: 40%">
                                        <span style="font-size: 15px;">
                                            选择文档类型
                                        </span>
                                    </td>
                                    <td class="pe-content" colspan="6">
                                        <input id="filetype" class="easyui-combobox" style="width:100%;"
                                               name="filetype"/>
                                    </td>
                                </tr>
                            </table>

                            <table id="filedTable" cellspacing="10" class="pxzn-dialog-font" style="margin: auto;"
                                   width='100%'>
                            </table>
                        </div>
                        <div title="审批记录" data-options="closable:false" style="padding:10px">
                            <div id="reviewInfoList">

                            </div>
                        </div>
                    </div>
                </form>
                <div id="file_dialog_button" class="pxzn-dialog-buttons">
                    <input id="save" type="button" onclick="file_dialog_ok()" value="保存" class="pxzn-button">
                    <input id="submit" type="button" onclick="file_dialog_ok(2)" value="提交" style="margin-left:10px;"
                           class="pxzn-button">
                    <%--<input id="check" type="button" onclick="file_dialog_ok(3)" value="驳回" style="margin-left:10px;"--%>
                    <%--class="pxzn-button">--%>
                    <%--<input id="saveIndex" type="button" onclick="file_dialog_ok(4)" value="入库" style="margin-left:10px;"--%>
                    <%--class="pxzn-button">--%>
                    <input id="download" type="button" onclick="downloadFileByForm()" value="下载"
                           style="margin-left:10px;"
                           class="pxzn-button">
                    <input id="review_button" type="button" onclick="review_button()" value="审核"
                           style="margin-left:10px;"
                           class="pxzn-button">
                </div>
            </div>
        </div>
    </div>
</div>

<div id="reviewDlg" class="easyui-dialog" style="width:400px"
     data-options="modal:true,closed:true,buttons:'#download-btns'">
    <form id="review_form" method="post" novalidate style="margin:0;padding:20px 50px">
        <div style="margin-bottom:10px;font-size:14px;"></div>
        <div style="margin-bottom:5px;">
            <input name="fileId" type="hidden">
            <input name="status" type="hidden">
        </div>
        <table cellspacing="10" class="pxzn-dialog-font" style="margin: auto;" width='100%'>
            <tr>
                <td class="pe-content" colspan="6" aria-colspan="2">
                    <input id="reviewIdea" label="审批意见:" labelPosition="top" class="easyui-textbox"
                           style="width:90%;height:120px" multiline="true" required
                           name="reviewIdea"/>
                </td>
            </tr>
        </table>
    </form>
    <div id="download-btns" style="text-align: center; margin-right:10px; margin-bottom: 5px;">
        <a id="agree" href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok"
           style="width:90px;color: green;">入库</a>
        <a id="disagree" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
           style="width:90px;margin-left: 60px;color: red;">驳回</a>
    </div>
</div>
</body>
</html>
