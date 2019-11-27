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
    <title>用户界面</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>
    <script>
        var treeId = "<%=treeId%>";
        var datagridId1 = "<%=datagridId1%>";
        var datagridId2 = "<%=datagridId2%>";

        $(function(){
            setDatagridField(datagridId1,fields1);
            $('#'+datagridId1).datagrid({
                url:'userResource/list',

            });
            // setTreeValue(treeId, treeJson);
            $('#'+treeId).tree({
                url: 'catalogUser/listTree',
                onClick: function (node) {
                    $("#"+datagridId1).datagrid('load', {
                        "catalogNO": node.id
                    });
                    // var attr = node.attributes;
                    // if (attr != null) {
                    //     var status = attr[0].status;
                    //     if (status != null) {
                    //         return;
                    //     }
                    // }
                    // $("#localStorageCatalogNO").val(node.id);
                    // $("#filelist").datagrid('load', {
                    //     "resId": $("#s_resId").textbox("getValue"),
                    //     "resName": $("#s_resName").textbox("getValue"),
                    //     "resType": $("#s_resType").combobox('getValue'),
                    //     "inputUser": $("#s_inputUser").textbox("getValue"),
                    //     "catalogNO": node.id
                    // });
                    // eastyuiOverTimeOrError($("#filelist"), 'datagrid');

                },
                checkbox: false,
                multiple: false,
                formatter: function (node) {
                    //需要拼接状态
                    var attr = node.attributes;
                    if (attr != null) {
                        var status = attr[0].status;
                        if (status != null) {
                            return node.text + '<span style="color:red">(节点不存在,请删除)</span>';
                        }
                        var power = attr[0].RW;
                        if (power != null) {
                            // if(!typeFlag) {
                            //     typeFlag = true;
                            //     return node.text + '<span style="color:#4ecc44;margin-left: 20px;">' + power + '</span><img src="images/px-icon/loading.gif" style="width: 14px;margin-left:10px;position: relative;top: 2px;">';
                            // }
                            // <img src="images/px-icon/loading.gif" style="width: 14px;margin-left:10px;position: relative;top: 2px;">
                            return node.text + '<span style="color:#4ecc44;margin-left: 20px;">' + power + '</span>';
                        }


                    }
                    typeFlag = true;

                    return node.text;
                }
            });

        });

    /**
     * 新建目录
     */
        //打开
        function newFolder_open(){
            $('#saveFolder-button').linkbutton('enable');
            var node = $('#'+treeId).tree('getSelected');
            if (node == null) {
                message_Show('请选择父级目录');
                return;
            }
            var attr = node.attributes;
            if (attr == null) {
                message_Show('没有操作权限');
                return;
            } else if (attr[0].RW.toUpperCase() != "RW") {
                message_Show('没有操作权限');
                return;
            }
            var repositoryName = attr[0].svnURL;
            var reNa = repositoryName.split("/");
            $('#floder_dlalog_form').form('clear');
            $('#floder_dlalog_form').form('load', {
                parentNO: node.id,
                repositoryName: reNa[0],
                userRepository: getParent(node).text,
                catalogPath: attr[0].catalogPath
            })
            $('#floder_dlalog').dialog('open').dialog('center').dialog('setTitle', '新建文件夹');
        }

        /**
         * 获取树结构
         * 根节点id
         */
        function getParent(node) {
            var rootNode = $('#'+treeId).tree('getParent', node.target);
            if (rootNode == null) {
                return node;
            }
            return getParent(rootNode);
        }

        //保存
        function floder_dlalog_ok(){

            $("#floder_dlalog_form").form("submit", {
                url: "catalogUser/create",
                onSubmit: function () {
                    if ($(this).form("validate")) {
                        $('#saveFolder-button').linkbutton('disable');
                    }
                    return $(this).form("validate");
                },
                success: function (result) {
                    result = eval('(' + result + ')');
                    var code = result.code;
                    if (code == messagerCode.success) {
                        var node = $('#'+treeId).tree('getSelected');
                        var c_catalogName = $('#c_catalogName').textbox('getValue');
                        var c_catalogPath = $('#c_catalogPath').val();
                        if (c_catalogPath != "") {
                            c_catalogPath = c_catalogPath + "/";
                        }
                        $('#'+treeId).tree('append', {
                            parent: node.target,
                            data: [{
                                id: result.catalogNO,
                                text: c_catalogName,
                                attributes: [{
                                    RW: 'RW',
                                    catalogPath: c_catalogPath + c_catalogName,
                                    svnURL: $('#c_repository').val()+'/'+c_catalogPath + c_catalogName
                                }]
                            }]
                        })
                        message_Show('新建成功');
                        floder_dlalog_close();

                    } else if (code == messagerCode.nameRepetition) {
                        $.messager.alert('系统提示', '名称重复');
                        $('#c_catalogName').textbox().next('span').find('input').focus();
                        $('#saveFolder-button').linkbutton('enable');
                    } else {
                        $.messager.alert('系统提示', '新建失败');
                    }
                },
                error: function () {
                    $.messager.alert("系统提示", "异常，请重新的登录后尝试!");
                }
            });
        }

        //取消
        function floder_dlalog_close(){
            $('#floder_dlalog').dialog('close');
        }

    /**
     * 检出工作副本
     */
        //打开
        var checkOutFlag = true;
        function checkOutRepository_open() {
            if(!checkOutFlag){
                $.messager.alert('系统提示','正在检出中，请稍后!');
                return;
            }

            $('#checkOutRepository_form').form('clear');
            $('#svnRepositoryNO').combobox({
                url: 'userResourceCatalog/queryRepository',
                valueField: 'catalogNO',
                textField: 'catalogName',
                editable: false,
                onChange: function (newValue, oldValue) {
                    var rows = $('#svnRepositoryNO').combobox('getData');
                    if (rows == null) {
                        return;
                    }
                    var row = {};
                    for (var i = 0; i < rows.length; i++) {
                        if (newValue == rows[i].catalogNO) {
                            row = rows[i];
                            break;
                        }
                    }
                    console.log(newValue);

                    $('#checkOutRepository_treegrid').treegrid("load", {
                        catalogNO: row.catalogNO,
                        parentNO: "0"
                    });
                    var svnRepositoryName = $('#svnRepositoryNO').combobox('getText');
                    $('#localrepositoryName').textbox('setValue', svnRepositoryName);
                }
            });


            $('#checkOutRepository_treegrid').treegrid({
                url: 'catalogUser/listCatalogTree.do',
                idField: 'catalogNO',
                treeField: 'catalogName',
                columns: [[
                    {field: 'catalogName', title: '名称', width: 50,align:'center'},
                    {field: 'power', title: '权限', width: 50,align:'center'},
                    {field: 'svnURL', title: 'svnURL', width: 50, align: 'center'}
                ]],
                onClickRow: function (row) {
                    if (row.power == "P") {
                        $.messager.alert('系统提示', '您对当前节点的权限为<span style="color:red">P</span>,故无读、写权限，请选择其权限为<span style="color:red">R</span>或<span style="color:red">RW</span>的子节点');
                        return;
                    }
                    $('#catalogSvnURL').textbox('setValue', row.svnURL);
                    $('#userRepositoryName').textbox('setValue', row.catalogName);
                    $('#checkOutCatalogNO').val(row.catalogNO);
                }
            });
            // eastyuiOverTimeOrError($('#checkOutRepository_treegrid'), 'datagrid');

            $('#checkOutRepository').dialog('open');
        }

        //保存
        function checkOutRepository_ok(){
            $('#checkOutRepository_form').form('submit', {
                url: 'catalogUser/checkoutWorkCopy',
                onSubmit: function () {
                    var catalogNO = $('#checkOutCatalogNO').val();
                    if (catalogNO == "") {
                        $.messager.alert('系统提示', '请选择需要检出的目录');
                        return false;
                    }
                   message_Show('开始检出，检出时间根据文件的数量和大小而定，请耐心等待');

                    checkOutFlag = false;
                    setCheckoutRunIcon();
                    checkOutRepository_close();
                    return true;
                },
                success: function (data) {
                    checkOutFlag = true;
                    setCheckoutIcon();
                    data = JSON.parse(data);
                    if(data == null){
                        return;
                    }
                    // $(".messager-body").window('close');
                    if (data.code === messagerCode.success) {
                        $.messager.alert('系统提示', '检出成功');
                        $('#'+treeId).tree('reload');
                    } else if (data.code === messagerCode.nameRepetition) {
                        $.messager.alert('系统提示', '检出名称重复');
                    } else {
                        $.messager.alert('系统提示', '检出失败');
                    }
                }
            }, 'json');

        }

        //关闭
        function checkOutRepository_close(){
            $('#checkOutRepository').dialog('close');
        }

        /**
         * 设置检出中图标
         */
        function setCheckoutRunIcon(){
            setIcon('toolbar1', 'images/px-icon/checkout.png', 'images/px-icon/checkout_run.gif');

        }

        /**
         * 设置检出图标
         */
        function setCheckoutIcon(){
            setIcon('toolbar1', 'images/px-icon/checkout_run.gif', 'images/px-icon/checkout.png');
        }

        /**
         * 设置图标
         */
        function setIcon(id, oldIconSrc, newIconSrc){
            var toolbrl = document.getElementById(id);
            if(toolbrl != null){
                var childrens = toolbrl.children;
                for(var i = 0;i<childrens.length;i++){
                    var src = childrens[i].getAttribute("src");
                    if(src === oldIconSrc){
                        childrens[i].setAttribute("src",newIconSrc);
                        return;
                    }
                }
            }
        }


    /**
     * 删除个人版本库
     */
        function deleteUserRepository() {
            var node = $('#'+treeId).tree('getSelected');
            if (node == null) {
                message_Show('请选择需要删除的根节点');
                return;
            }
            var attr = node.attributes;
            if (attr == null) {
                $.messager.alert("系统提示", "请刷新页面再次尝试");
                return;
            }
            var tNO = attr[0].tNO;
            if (tNO == null) {
                message_Show('当前节点禁止删除，请选择顶级节点');
                return;
            }
            $.messager.confirm('系统提示', '请确认是否删除 <span style="color: red">' + node.text + '</span> ?', function (r) {
                if (r) {
                    $.ajax({
                        type: 'GET',
                        url: 'catalogUser/deleteCheckoutWorkCopy',
                        dataType: 'JSON',
                        data: {tNO: tNO},
                        success: function (data) {
                            var code = data.code;
                            if (code === "1000") {
                                $('#'+treeId).tree('remove', node.target);
                                $('#'+datagridId1).datagrid('load');
                               message_Show("删除成功")
                            } else if (code === '2003') {
                                $.messager.alert('系统提示', '参数不合法');
                            } else if (code === '2005') {
                                //数据不存在
                                $.messager.alert('系统提示', '删除数据不存在，请刷新后尝试');
                            } else {
                                $.messager.alert('系统提示', '删除失败');
                            }
                        },
                        error:function(){
                            serverError();
                        }
                    })
                }
            });
        }

    /**
     * 编辑资源
     */
        //打开
        function editFile(){
            $('#editFile_dialog').dialog('open').dialog('setTitle','编辑资源');
        }

        //保存
        function editFile_dialog_ok(){
            editFile_dialog_close();
        }

        //关闭
        function editFile_dialog_close(){
            $('#editFile_dialog').dialog('close');
        }

        /**
         * 下载资源
         */
        function openDownloadList() {
            var selectedRows = $("#"+datagridId1).datagrid("getSelections");

            if (selectedRows.length === 0 || selectedRows.length > 1) {
                $.messager.alert("系统提示", "请选择一条需要下载的数据！");
                return;
            }
            var row = selectedRows[0];
            $('#downloadForm').form('clear');
            $('#downloadList').dialog('open').dialog('center').dialog('setTitle', '下载资源');

            $('#'+datagridId2).datagrid({
                url:'resource/listHistory',
                queryParams: {
                    svnURL: row.svnURL
                },
                columns: [[
                    {field: 'histAction', title: '操作', width: 20}
                    , {field: 'userId', title: '作者', width: 50}
                    , {field: 'histResName', title: '文件名称', width: 60}
                    , {field: 'histVersion', title: '版本号', width: 20}
                    , {field: 'histTime', title: '操作时间', width: 50,formatter: formatDate}
                    , {field: 'download', title: '操作', width: 50, formatter: formatAction,align:'center'}
                ]]
            });
        }

        function formatAction(value, row, index) {
            return '<a href="javascript:openDownloadDlg()" title="下载资源">[下载]</a>';
        }

        function formatDate(value, row, index) {
            if (value) {
                var date = new Date(value.time);
                var y = date.getFullYear();
                var m = date.getMonth() + 1;
                m = m < 10 ? '0' + m : m;
                var d = date.getDate();
                d = d < 10 ? ("0" + d) : d;
                var h = date.getHours(); //小时
                h = h < 10 ? ("0" + h) : h;
                var min = date.getMinutes(); //分
                min = min < 10 ? ("0" + min) : min;
                var s = date.getSeconds(); //秒
                s = s < 10 ? ("0" + s) : s;
                var str = y + "-" + m + "-" + d + " " + h + ":" + min + ":" + s;
                //alert(str);
                return str;
            } else {
                return "";
            }
        }

        function openDownloadDlg(){
            var selectedRows = $("#"+datagridId2).datagrid("getSelections");
            if (selectedRows.length == 0) {
                message_Show('请选择需要下载的文件!');
                return;
            }
            var row = selectedRows[0];
            $('#downloadForm').form('load', {
                svnVersion:row.histVersion,
                svnURL:row.histResURL
            });
            $.messager.confirm('系统提示', '确认继续下载资源【' + row.histResName + '】', function(r){
                if (r){
                    $("#downloadForm").form("submit", {
                        url: "resource/download.do",
                        onSubmit: function () {
                            message_Show('开始下载');
                        },
                        success: function (data) {
                            // if(data == ""){
                            //     serverError();
                            //     return;
                            // }
                            // data = eval('(' + data + ')');
                            // data = returnMessager(data);
                            // if(data == null){
                            //     return;
                            // }
                        }
                    });
                }
            });
        }


        /**
         * 批量提交文件操作
         */
        //批量上传打开
        function files_open() {
            var node = $('#'+treeId).tree('getSelected');
            if (node == null) {
                $.messager.alert("系统提示", "请选择对应的目录！");
                return;
            } else if (node.attributes[0].RW.toUpperCase() != "rw".toUpperCase()) {
                $.messager.alert("系统提示", "没有操作权限!");
                return;
            }

            // if(!parent.fileUploadFlag){
            //     //文件未上传完成，禁止上传
            //     $.messager.alert("系统提示", "文件未上传完成，请等待上传成功后再次上传！");
            //     return;
            // }
            // fileArray = [];
            // $('#files_form').form('clear');
            // $('#files_Text').empty();
            // $('#fileAllSize').text("");
            // $('#fileNumber').text("");
            // var node = $('#resTree').tree('getSelected');
            // if (node == null) {
            //     $.messager.alert("系统提示", "请选择对应的目录！");
            //     return;
            // } else if (node.attributes[0].rw.toUpperCase() != "rw".toUpperCase()) {
            //     $.messager.alert("系统提示", "没有操作权限!");
            //     return;
            // }
            //
            // $.ajax({
            //     type: 'post',
            //     url: 'res/queryMaxId.do',
            //     dataType: 'json',
            //     success: function (data) {
            //         data = returnMessager(data);
            //         if(data == null){
            //             return;
            //         }
            //
            //         $('#files_id').val(data.returnId);
            //         $("#files_catalogNO").val(node.id);
            //         $("#files_catalogPath").val(node.attributes[0].catalogPath);
            //     },
            //     error:function(){
            //         serverError();
            //     }
            // });
            //
            // //添加更新版本库操作
            // if (node){
            //     updateNode(node, 'false');
            // }
            $('#upload_dialog').dialog('open');
        }

        //确定
        function upload_dialog_ok(){
            var files = fileArray;
            if (files != null && files.length > 0) {
                $.messager.confirm('系统提示', "请确认是否开始上传", function (r) {
                    if (r) {
                        // upload_dialoglog_open();
                        var node = $('#'+treeId).tree('getSelected');
                        var catalogPath = node.attributes[0].catalogPath;
                        if(catalogPath == null){
                            catalogPath = "";
                        }

                        parent.uploadClear();
                        parent.allFileUploadTotal = files.length;
                        for (var i = 0; i < files.length; i++) {
                            parent.uploadFile(files[i], node, getParent(node), node.id, catalogPath);
                        }
                    }
                })
                upload_dialog_close();
            } else {
                $.messager.alert("系统提示", "请选择至少一条需要上传的数据");
            }

        }

        //取消
        function upload_dialog_close(){
            $('#upload_dialog').dialog('close');
        }

        //上传进度打开
        // function upload_dialoglog_open(){
        //     $('#upload_dialoglog').dialog('open').dialog('setTitle',"上传进度");
        // }


        //文件上传状态提示 true可上传，false不能上传
        var fileUploadFlag = true;








    </script>
</head>
<body id="resource_admin_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        资源目录
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('resource_admin_layout','west')" class="layout-title-img">
    </div>
    <%--操作栏--%>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#'+treeId).tree('reload');" title="刷新">
            <img src="images/px-icon/newFolder.png" style="padding: 0px 10px;" class="easyui-tooltip div-toolbar-img-next"
                 onclick="newFolder_open()" title="新建目录">
            <img src="images/px-icon/checkout.png" style="padding: 0px 10px;" class="easyui-tooltip div-toolbar-img-next"
                 onclick="checkOutRepository_open()" title="检出工作副本">
            <img src="images/px-icon/shanchu.png" style="padding: 0px 10px;" class="easyui-tooltip div-toolbar-img-next"
                 onclick="deleteUserRepository()" title="删除个人工作副本">
        </div>
    </div>

    <%--树目录--%>
    <jsp:include page="/px-tool/px-tree.jsp">
        <jsp:param value="<%=treeId%>" name="div-id"/>
    </jsp:include>

    <%--新建目录--%>
    <div id="floder_dlalog" class="easyui-dialog" data-options="closed:true, modal:true,border:'thin', buttons:'#floder_dlalog_button'">
        <form id="floder_dlalog_form" method="post" novalidate>
            <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                <input  name="catalogNO" type="hidden">
                <input name="userRepository" type="hidden">
                <input name="parentNO" type="hidden">
                <input id="c_repository" name="repositoryName" type="hidden">
                <input id="c_catalogPath" name="catalogPath" type="hidden">
                <tr>
                    <td><span class="pxzn-span-two">名称</span></td>
                    <td>
                        <input id="c_catalogName" name="catalogName" class="easyui-textbox pxzn-dialog-text"
                               data-options="required:true,validType:['space','keyword','fileOrCata','length[1,200]']">
                    </td>
                </tr>
            </table>
        </form>
        <div id="floder_dlalog_button" class="pxzn-dialog-buttons">
            <input type="button" onclick="floder_dlalog_ok()" value="保存" class="pxzn-button">
            <input type="button" onclick="floder_dlalog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>

    <%--检出工作副本--%>
    <div id="checkOutRepository" class="easyui-dialog"  data-options="closed:true,modal:true,border:'thin',title:'检出',buttons:'#checkOutRepository_button'">
            <form id="checkOutRepository_form" method="post" novalidate enctype="multipart/form-data">
                <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                    <input id="checkOutCatalogNO" name="catalogNO" type="hidden">
                    <tr>
                        <td><span class="pxzn-span-four">检出目录名称</span></td>
                        <td>
                            <input id="userRepositoryName" name="userRepositoryName" class="easyui-textbox"
                                   data-options="readonly:true" style="width: 350px;">
                        </td>
                    </tr>
                    <tr>
                        <td><span class="pxzn-span-four">检出目录路径</span></td>
                        <td>
                            <input id="catalogSvnURL" name="catalogSvnURL" class="easyui-textbox"
                                   data-options="readonly:true" style="width: 350px;">
                        </td>
                    </tr>
                    <tr>
                        <td><span class="pxzn-span-three">版本库</span></td>
                        <td>
                            <input id="svnRepositoryNO" class="easyui-combobox" style="width: 350px;"
                                   data-options="panelHeight:100">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <span style="font-size: 12px">版本库列表</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div style="border: 1px solid #cdcdcd">
                                <table id="checkOutRepository_treegrid" class="easyui-treegrid" style="width:100%;height:200px"
                                       data-options="idField:'id',treeField:'name',fitColumns:true">
                                </table>
                            </div>

                        </td>
                    </tr>
                </table>
            </form>
        <div id="checkOutRepository_button" class="pxzn-dialog-buttons">
            <input type="button" onclick="checkOutRepository_ok()" value="确定" class="pxzn-button">
            <input type="button" onclick="checkOutRepository_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>
</div>
<div data-options="region:'center'">
    <div id="toolbar">
        <div class="datagrid-title-div"><span>资源列表</span></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#'+datagridId1).datagrid('reload')" title="刷新">
        <img src="images/px-icon/bianji.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="editFile()" title="编辑">
        <img src="images/px-icon/daochu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="openDownloadList()" title="下载">
        <img src="images/px-icon/batchUpload.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="files_open()" title="批量上传">
    </div>
    <jsp:include page="/px-tool/px-datagrid.jsp">
        <jsp:param value="<%=datagridId1%>" name="div-id"/>
        <jsp:param value="<%=toolbar%>" name="datagrid-toolbar"/>
    </jsp:include>

    <%--编辑资源--%>
    <div id="editFile_dialog" class="easyui-dialog" style="width:450px;max-height: 500px"
         data-options="closed:true, modal:true, buttons:'#editFile_dialog_button'">
        <form id="editFile_dialog_form" method="post" style="margin:0;padding:20px 30px" enctype="multipart/form-data">
        </form>
        <div id="editFile_dialog_button" style="text-align: center;">
            <a href="javascript:editFile_dialog_ok()" class="easyui-linkbutton" style="width:90px">保存</a>
            <a href="javascript:editFile_dialog_close()" class="easyui-linkbutton" style="width:90px">取消</a>
        </div>
    </div>

    <%--下载资源--%>
    <div id="downloadList" class="easyui-dialog" data-options="modal:true, closed:true, buttons:'#download-btns'"
         style="width:700px;height:350px;">
        <jsp:include page="/px-tool/px-datagrid.jsp">
            <jsp:param value="<%=datagridId2%>" name="div-id"/>
        </jsp:include>
    </div>

    <%--form表单，下载文件用--%>
    <div class ="easyui-dialog" data-options="modal:true, closed:true">
        <form id="downloadForm" method="post" novalidate>
            <input name="svnURL" type="hidden">
            <input name="svnVersion" type="hidden">
        </form>
    </div>

    <%--批量上传--%>
    <div id="upload_dialog" class="easyui-dialog" style="width:600px" data-options="closed:true, modal:true,border:'thin', title:'批量上传', buttons:'#upload_dialog_button'">
        <form id="files_form" method="post" novalidate style="width:550px;margin:0 auto;padding:20px 0 0 0"
              enctype="multipart/form-data">
            <jsp:include page="/px-tool/px-upload.jsp"/>
        </form>
        <div id="upload_dialog_button" class="pxzn-dialog-buttons">
            <input type="button" onclick="upload_dialog_ok()" value="上传" class="pxzn-button">
            <input type="button" onclick="upload_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>

    <%--上传进度--%>
    <div id="upload_dialoglog" class="easyui-dialog" data-options="collapsible:true,maximizable:true,shadow:true,border:'thin',modal:true,closed:true,resizable:true" style="width:800px;height: 500px">
        <div>
            <jsp:include page="/px-tool/px-uploadProgress.jsp"/>
        </div>

    </div>


</div>
</div>

</body>
</html>
