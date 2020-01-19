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
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>

    <script>
        var treeId = "<%=treeId%>";
        var datagridId1 = "<%=datagridId1%>";

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


            /**
             * 提交按钮绑定
             * 2019年10月15日
             */
            $('#btnSaveIndex').bind('click', function () {
                //把表单数据转换成json对象
                // var data = JSON.stringify($('#saveIndex').serializeJSON());
                $('#saveIndex').form('submit', {
                    url: 'userHouse/create',
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


        });

        function getTree() {
            var node = $('#tt').tree('getSelected');
            if (node == null) {
                return;
            }
            var userName = node.text;

            $('#' + treeId).tree({
                url: 'userInfo/listTree?userName=' + userName,
                method: "get",
                checkbox: false,
                multiple: false,
                animate: true,
                onClick: function (node) {
                    //点击事件 获取dataList
                    loadDataList(node.id);
                },
                onLoadSuccess: function (node, data) {
                    //什么都不干
                    if (data.length > 0) {
                        //找到第一个元素
                        var n = $('#' + treeId).tree('find', data[0].id);
                        //调用选中事件
                        $('#' + treeId).tree('select', n.target);
                        loadDataList(n.id);
                        //将索引库名称显示在顶部
                        document.getElementById("indexName").innerHTML = "";
                        $('#indexName').append('<span>' + data[0].text + '</span>')
                    }
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
             * 文档列表
             */
            $('#mygrid').datagrid({
                url: "file/fileList?menuId=" + menuId, // 文档表
                type: "GET",
                dataType: 'json',
                contentType: "application/json",

                columns: [[
                    {field: 'fileName', title: '名称', width: 200, align: 'left'},

                    {field: 'fileNameSuffix', title: '类型', width: 100, align: 'center'},
                    {
                        field: 'creationTime', title: '创建时间', width: 180, align: 'center',
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
                    {
                        field: 'status', title: '状态', width: 130, align: 'center',
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
                    },

                    {
                        field: 'fileSize', title: '文件大小', width: 150, align: 'center',
                        //文件大小格式化
                        formatter: function (value) {
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
                    },
                    {
                        field: 'operate', title: '操作', align: 'left', width: $(this).width() * 0.1,
                        formatter: function (value, row, index) {
                            var str = '<a href="javaScript:void(0)" onclick="file_show(\'' + row.fileId + '\')" name="opera" class="easyui-linkbutton" title="属性查看"></a>';
                            return str;
                        }
                    },
                ]],

                rownumbers: true,
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                // striped: true,
                loading: true,
                fit: false,//自适应高度
                emptyMsg: "没有获取到数据",
                loadMsg: "正在努力加载数据,表格渲染中...",
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
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
                onLoadError: function () {
                    clearDataGrid();
                }
            });
        }

        /**
         * 文件预览
         */
        function file_show(fileId, pageNo) {
            //获取一次文件状态, 不是0就可以跳转
            $.ajax({
                url: 'file/fileDetail?fileId=' + fileId,
                success: function (data) {
                    if (data.status != 0) {
                        window.location.href = "./views/resource/knowledgeCenter/file_show.jsp?fileId=" + fileId + "&pageNo=" + pageNo;
                    } else {
                        message_Show('请等待文件离散完成', '提示消息')
                    }
                }
            })
        }

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
            var nodeIndex = $('#tt').tree('getSelected');
            if (nodeIndex == null) {
                return;
            }
            var indexName = nodeIndex.text;
            fileArray = [];
            $('#files_form').form('clear');
            $('#files_Text').empty();
            $('#fileAllSize').text("");
            $('#fileNumber').text("");

            $('#file_dialog_upload').form('load', {
                indexName: indexName,
            });
            $('#files').dialog('open').dialog('center').dialog('setTitle', '添加文件');
        }

        //选择文件d
        function selectFiles() {
            document.getElementById('files_Batch').value = "";
            document.getElementById('files_Batch').click();
        }

        //文件对象数组
        var fileArray = [];

        //保存文件名称和随机编号的对应关系[{id: "s_3571428845", name: "XXHash32.java"}]
        var fileLists = [];

        //文件大小
        var fileAllSize = 0;

        //选择文件改变时
        function fileChange() {
            fileAllSize = 0;
            var file = document.getElementById("files_Batch");
            var files = file.files;

            fileArray = [];
            Array.prototype.push.apply(fileArray, files);

            $('#files_Text').empty();
            if (fileArray.length > 0) {

                for (var i = 0; i < fileArray.length; i++) {
                    var fileRelevance = {};
                    fileRelevance.id = getId("s_");
                    fileRelevance.name = fileArray[i].name;
                    fileLists.push(fileRelevance);
                    $('#files_Text').append('<div id="' + fileRelevance.id + '" class="default" style="margin-top:5px;margin-left:8px;margin-right: 8px;" title="' + fileArray[i].name + '" class="easyui-tooltip" ><div style="float: left; width:279px;height:20px;font-size:14px;overflow:hidden;padding:3px 0;">' + fileArray[i].name + '</div><img style="width:20px;float:right" class="pointer" onmouseenter="pitchOn(this)" onmouseleave="uncheck(this)" onclick="removeDiv(\'' + fileRelevance.id + '\')" src="/EIS/images/px-icon/delete.png"></div>');
                }

                setFileNumber();
                setFileSize();


            } else {
                $('#fileNumber').text("");
                $('#fileAllSize').text("");
            }
        }

        //删除
        function removeDiv(id) {

            $("#" + id).remove();
            for (var i = 0; i < fileLists.length; i++) {
                var fileObject = fileLists[i];
                if (id == fileObject.id) {
                    //一样的
                    for (var y = 0; y < fileArray.length; y++) {
                        if (fileObject.name == fileArray[y].name) {

                            fileArray.splice(y, 1);
                            fileLists.splice(i, 1);
                            break;
                        }
                    }
                    break;
                }
            }

            setFileNumber();
            setFileSize();
        }

        //设置文件数量
        function setFileNumber() {
            if (fileArray.length == 0) {
                $('#fileNumber').text("");
                return;
            }

            $('#fileNumber').text(fileArray.length);
        }

        //设置文件大小
        function setFileSize() {
            if (fileArray.length == 0) {
                $('#fileAllSize').text("");
                return;
            }
            fileAllSize = 0;
            for (var s = 0; s < fileArray.length; s++) {
                fileAllSize += fileArray[s].size;
            }

            if (fileAllSize >= 1048576 && fileAllSize < 1073741824) {
                //大于等于1M,小于1G
                $('#fileAllSize').text(Math.round(fileAllSize / 1024 / 1024) + "MB");
            } else if (fileAllSize < 1048576) {
                //小于1M
                $('#fileAllSize').text(Math.ceil(fileAllSize / 1024) + "KB");
            } else {
                //大于1G
                $('#fileAllSize').text(Math.round(fileAllSize / 1024 / 1024 / 1024) + "GB");
            }
        }

        //鼠标移上
        function pitchOn(event) {
            $(event).attr('src', "images/px-icon/delete-red.png");
        }

        //取消选中
        function uncheck(event) {
            $(event).attr('src', "images/px-icon/delete.png");
        }

        function files_form_close() {
            $('#files_form').form('clear');
            $('#files_Text').empty();
            $('#files').dialog('close');
        }

        /**
         * 批量上传
         * 一条数据一条数据上传
         */
        function files_form_save() {
            $.messager.confirm('系统提示', "请确认是否开始上传", function (r) {
                if (r) {
                    $.messager.show({
                        title: '系统提示',
                        msg: '开始添加文件',
                        timeout: 1000,
                        showType: 'slide'
                    });
                    var node = $('#' + treeId).tree('getSelected');
                    var node2 = $('#tt').tree('getSelected');
                    var menuId = node.id;
                    var indexName = node2.text;

                    var files = $('#files_Batch')[0].files;
                    if (files.length > 0) {
                        for (var i = 0; i < files.length; i++) {
                            //组装数据
                            var formData = new FormData();
                            formData.append('file', files[i]);
                            formData.append('menuId', menuId);
                            formData.append('indexName', indexName);
                            console.log(files[i]);

                            //提交表单
                            $.ajax({
                                url: 'file/fileTempUpload',
                                processData: false, //因为data值是FormData对象，不需要对数据做处理。
                                contentType: false,
                                cache: false,
                                type: 'POST',
                                data: formData,
                                success: function (result) {
                                    //刷新列表
                                    $('#mygrid').datagrid('reload');
                                    //后台解析文件
                                    file2Html(result.data);
                                }
                            });
                        }
                    }

                }
            });

            //关闭窗口
            files_form_close();
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
            alert(node == null);
            if (node == null) {
                node = {id: 'root'}
            }
            $('#folder_dialog_form').form('clear');
            $('#folder_dialog_form').form('load', {
                // _parentId: node.id,
                pid: node.id,
                userName: node2.text

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
            if (('000000000000000000') === (node._parentId)) {
                message_Show('当前节点禁止编辑, 请重新选择');
                return;
            }

            $('#folder_dialog_form').form('clear');
            $('#folder_dialog_form').form('load', {
                id: node.id,
                _parentId: node._parentId,
                pid:node._parentId,
                text: node.text,
                url: node.url,
                status: node.status,
                state: node.state,
                userName: node2.text
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
            if (('000000000000000000') === (node._parentId)) {
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
         * 提交目录表单
         */
        var menu_submit_flag = true;//用来防止多次点击发送请求

        function folder_dialog_ok() {
            if (menu_submit_flag) {
                menu_submit_flag = false;
                $("#folder_dialog_form").form("submit", {
                    url: "userInfo/submit",
                    onSubmit: function () {
                        return $(this).form("validate");
                    },
                    success: function (result) {
                        alert(result);
                        // console.log(result);
                        // var data = JSON.parse(result);
                        // alert(data.message);
                        // message_Show(data.message);
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
        var file_upload_flag = true;//用来防止多次点击发送请求的标记
        function file_dialog_ok() {
            if (file_upload_flag) {
                file_upload_flag = false;

                var str = JSON.stringify($('#file_dialog_upload').serializeJSON());
                console.log(str);
                $.ajax({
                    url: 'file/fileForm',
                    type: 'POST',
                    dataType: 'JSON',
                    // contentType: 'application/json',
                    data: {json: str},
                    success: function (result) {
                        console.log(result);
                        message_Show(result.message);
                        //关闭窗口, 刷新列表
                        file_dialog_close();
                        // $('#' + treeId).tree('reload');
                        //调用文件解析接口, 后台自动解析
                        if (result.success == false) {
                            return;
                        }
                        fileSpread(result.data);
                        file_upload_flag = true;
                    }
                });
            }
        }

        function file2Html(fileInfo) {
            $.ajax({
                url: 'fileTemp/file2Html',
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                data: JSON.stringify(fileInfo),
                success: function (result) {
                    //刷新列表
                    $('#mygrid').datagrid('reload');
                    //成功后右下角窗口提醒
                    message_Show(result.message);
                    //修改控件src
                    if (result.data == null) {
                        return;
                    }
                    console.log('离散完成' + result.data);
                },
                error: function () {
                    alert('文件离散失败, 该文件可能是只读文件, 不可执行其他操作')
                }
            })
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
                success: function (result) {
                    //成功后右下角窗口提醒
                    message_Show(result.message)
                },
                error: function () {
                    alert('文件离散失败, 该文件可能是只读文件, 不可执行其他操作')
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
                url: 'json/user.json',
                method: 'get',
                onClick: function (node) {
                    // alert(node.text)

                    // //将索引名称显示在顶部
                    // document.getElementById("indexName").innerHTML = "";
                    // $('#indexName').append('<span>' + node.text + '</span>')

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
                    }
                }
            });
        }

        function deleteFile() {
            var node = $('#mygrid').datagrid('getSelected');
            if (node == null) {
                message_Show('请先选择一行数据', '提示消息');
            } else {
                $.messager.confirm("确认", "确认要删除吗？", function (yes) {
                    if (yes) {
                        var id = node.id;
                        $.ajax({
                            url: 'fileTemp/deleteFile?id=' + id,
                            dataType: 'json',
                            type: 'POST',
                            success: function (data) {
                                message_Show(data.message);
                                $('#mygrid').datagrid('reload');
                            }
                        });
                    }
                });
            }
        };


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

        function checkFile(menuId, status) {
            //获取menuId
            var node = $('#' + treeId).tree('getSelected');
            menuId = node.id;
            //点击列出未被审核的文件列表
            /**
             * 文档列表
             */
            $('#mygrid').datagrid({
                url: "file/fileListByStatus?menuId=" + menuId + "&status=" + status, // 文档表
                type: "GET",
                dataType: 'json',
                contentType: "application/json",


                columns: [[
                    {field: 'fileName', title: '名称', width: 200, align: 'left'},

                    {field: 'fileNameSuffix', title: '类型', width: 100, align: 'center'},
                    {
                        field: 'creationTime', title: '创建时间', width: 180, align: 'center',
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
                    {
                        field: 'status', title: '状态', width: 130, align: 'center',
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
                    },

                    {
                        field: 'fileSize', title: '文件大小', width: 150, align: 'center',
                        //文件大小格式化
                        formatter: function (value) {
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
                    },
                    {
                        field: 'operate', title: '操作', align: 'left', width: $(this).width() * 0.1,
                        formatter: function (value, row, index) {
                            var str = '<a href="javaScript:void(0)" onclick="file_show(\'' + row.fileId + '\')" name="opera" class="easyui-linkbutton" title="属性查看"></a>';
                            return str;
                        }
                    },
                ]],

                rownumbers: true,
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                // striped: true,
                loading: true,
                fit: false,//自适应高度
                emptyMsg: "没有获取到数据",
                loadMsg: "正在努力加载数据,表格渲染中...",
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
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
                onLoadError: function () {
                    clearDataGrid();
                }
            });

        }

        function checkFile_submit() {
            //获取menuId
            var node = $('#' + treeId).tree('getSelected');
            var menuId = node.id;
            //点击列出未被审核的文件列表
            /**
             * 文档列表
             */
            $('#mygrid').datagrid({
                url: "file/fileListByStatusSubmit?menuId=" + menuId, // 文档表
                type: "GET",
                dataType: 'json',
                contentType: "application/json",

                columns: [[
                    {field: 'fileName', title: '名称', width: 200, align: 'left'},

                    {field: 'fileNameSuffix', title: '类型', width: 100, align: 'center'},
                    {
                        field: 'creationTime', title: '创建时间', width: 180, align: 'center',
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
                    {
                        field: 'status', title: '状态', width: 130, align: 'center',
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
                    },

                    {
                        field: 'fileSize', title: '文件大小', width: 150, align: 'center',
                        //文件大小格式化
                        formatter: function (value) {
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
                    },
                    {
                        field: 'operate', title: '操作', align: 'left', width: $(this).width() * 0.1,
                        formatter: function (value, row, index) {
                            var str = '<a href="javaScript:void(0)" onclick="file_show(\'' + row.fileId + '\')" name="opera" class="easyui-linkbutton" title="属性查看"></a>';
                            return str;
                        }
                    },
                ]],
                rownumbers: true,
                singleSelect: true,
                collapsible: true,
                nowrap: true,
                // striped: true,
                loading: true,
                fit: false,//自适应高度
                emptyMsg: "没有获取到数据",
                loadMsg: "正在努力加载数据,表格渲染中...",
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
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
                onLoadError: function () {
                    clearDataGrid();
                }
            });

        }
    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="easyui-layout" style="width: 250px; height: 100%;">
        <div data-options="region:'north'" style="height: 50%;">
            <%--<div class="layout-title-div">--%>
                <%--资源目录--%>
                <%--<img src="images/px-icon/hide-left-black.png" onclick="layoutHide('permissionSet_layout','west')"--%>
                     <%--class="layout-title-img">--%>
            <%--</div>--%>
            <div style="margin:5px 0;border-bottom:1px ">
                <div id="toolbar">
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
             onclick="$('#mygrid').datagrid('reload');" title="刷新">
        <img src="images/px-icon/newFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="upload_dialog_open()" title="文档添加">
        <img src="images/px-icon/deleteFolder.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="deleteFile()" title="文档删除">
        <img src="images/px-icon/up.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="checkFile_submit()" title="待提交">
        <img src="images/px-icon/ziyuanshouquan.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="checkFile('',2)" title="待审核">

        <%--&lt;%&ndash; 搜索框 &ndash;%&gt;--%>
        <%--<a id="btnSearch" href="javascript:void(0)" class="easyui-linkbutton"--%>
        <%--style="float: right;margin-top: 8px;margin-right: 20px;width:80px" onclick="searchFile()">查询文档</a>--%>
        <%--<input id="search" class="div-toolbar-span" style="float: right;margin-top: 8px;width:200px;height:25px"/>--%>

    </div>
    <table id="mygrid" style="height: 400px;">

        <%--<div style="margin:20px 0;">--%>
            <%--<a href="javascript:void(0)" class="easyui-linkbutton" onclick="start()">Start</a>--%>
        <%--</div>--%>
        <%--<div id="p" class="easyui-progressbar" style="width:100%"></div>--%>
        <%--<script>--%>
            <%--function start() {--%>
                <%--var value = $('#p').progressbar('getValue');--%>
                <%--if (value < 100) {--%>
                    <%--value += Math.floor(Math.random() * 10);--%>
                    <%--$('#p').progressbar('setValue', value);--%>
                    <%--setTimeout(arguments.callee, 200);--%>
                <%--}--%>
            <%--};--%>
        <%--</script>--%>
    </table>


</div>
<%-- 弹出对话框 --%>
<%--目录表单--%>
<div id="folder_dialog" class="easyui-dialog" style="width: 500px;"
     data-options="closed:true, modal:true,border:'thin', buttons:'#folder_dialog_button'">
    <form id="folder_dialog_form" method="post" novalidate>
        <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;">
            <input name="_parentId" type="hidden">
            <input name="id" type="hidden">
            <input name="pid" type="hidden">
            <input name="userName" type="hidden">
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
<div id="files" class="easyui-dialog" style="width:600px"
     data-options="closed:true, modal:true, title:'批量添加', buttons:'#files_form_btns'">
    <form id="file_dialog_upload" method="post" novalidate style="width:550px;margin:0 auto;padding:20px 0 0 0"
          enctype="multipart/form-data">
        <input id="files_Batch" name="file" style="display: none" type="file" multiple="multiple"
               onchange="fileChange()">
        <table cellspacing="5">
            <tr>
                <td valign="top" style="padding-left: 12px">
                    文件名:
                </td>
                <td>
                    <div id="files_Text"
                         style="width: 350px;height: 150px;border:1px solid #DADADA; overflow-y: auto"></div>
                </td>
                <td>
                    <input type="button" value="选择文件" style="width: 71px;height: 150px;border: 0px;outline:none;"
                           onclick="selectFiles()"/>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-left: 12px">
                    文件数量:
                </td>
                <td>
                    <span id="fileNumber"></span>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-left: 12px">
                    文件大小:
                </td>
                <td>
                    <span id="fileAllSize"></span>
                </td>
            </tr>
        </table>
        <div id="progress_bottom1" class="progress-bottom" style="display: none;padding-top: 14px;">
            <div style="width:100%;position:absolute;top: 95px;display: none">
                <san id="progress_span1" style="font-size: 22px;">1%</san>
            </div>
            <div id="progress_span_ok12" style="width: 100%;position:absolute;top: 121px;display:block">
                <span id="progress_span_text112" style="font-size: 16px;font-weight: 800;color:#122b39"></span>
            </div>
        </div>

    </form>

    <div id="files_form_btns" style="text-align: center; margin-right:10px; margin-bottom: 5px;">
        <a href="javascript:files_form_save()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">添加</a>
        <a href="javascript:files_form_close()" class="easyui-linkbutton" iconCls="icon-cancel"
           style="width:90px">取消</a>
    </div>
</div>
<%--扩展属性--%>
<div id="files_attributes_dialog" class="easyui-dialog" style="width: 600px;" data-options="closed:true">

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
        <%--<input placeholder="添点什么">--%>
    </form>
</div>


</body>
</html>
