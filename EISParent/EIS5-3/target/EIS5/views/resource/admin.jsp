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
    String datagridId1 = "px_2";
    String datagridId2 = "download_datagrid";
    String toolbar = "toolbar";

%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>管理员界面</title>
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
                url:'resource/list',
            });


            $('#'+treeId).tree({
                url: 'catalog/listTree',
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
                        var power = attr[0].rw;
                        if (power != null) {
                            if(!typeFlag) {
                                typeFlag = true;
                                return node.text + '<span style="color:#4ecc44;margin-left: 20px;">' + power + '</span><img src="images/px-icon/loading.gif" style="width: 14px;margin-left:10px;position: relative;top: 2px;">';
                            }
                            // <img src="images/px-icon/loading.gif" style="width: 14px;margin-left:10px;position: relative;top: 2px;">
                            return node.text + '<span style="color:#4ecc44;margin-left: 20px;">' + power + '</span>';
                        }


                    }
                    typeFlag = true;

                    return node.text;
                },
                onExpand:function(node){
                    console.log(node);
                }
            });
        });
    /**
     * 新建版本库
     */
        //打开
        function repository_dialog_open() {

            $('#repository_form').form('clear');
            $('#repository_dialog').dialog('open').dialog('center').dialog('setTitle', '新建版本库');
        }

        //保存
        function repository_dialog_ok() {

            $("#repository_form").form("submit", {
                url: "catalog/create",
                onSubmit: function () {
                    return $(this).form("validate");
                },
                success: function (result) {
                    if(result == null || result == ""){
                        //系统异常
                        return;
                    }
                    result = eval('(' + result + ')');
                    if(result == null){
                        return;
                    }

                    var code = result.code;
                    if (code == messagerCode.success) {
                        var node = $('#'+treeId).tree('find', 0);//默认给版本仓库节点下增加版本库
                        $('#'+treeId).tree('append', {
                            parent: node.target,
                            data: [{
                                id: result.catalogNO,
                                text: $('#repository_Name').textbox('getValue'),
                                attributes: [{
                                    rw: "RW"
                                }]
                            }]
                        });
                        repository_dialog_close();
                        $.messager.show({
                            title: '系统提示', msg: '保存成功!',
                            timeout: 3000, showType: 'slide'
                        });


                    } else if (code == '2004') {
                        $.messager.alert('系统提示', '名称重复');
                        $('#c_catalogName').textbox().next('span').find('input').focus();
                        $('#saveFolder-button').linkbutton('enable');
                    } else if (code == "2003") {
                        $.messager.alert('系统提示', '名称禁止为空');
                    }
                    else {
                        $.messager.alert('系统提示', '新建失败');
                    }
                }
            });
        }

        //取消
        function repository_dialog_close() {
            $('#repository_dialog').dialog('close');
        }

        /**
         * 获取版本库
         * 删除用
         */
        function getParents(node) {
            var rootNode = $('#'+treeId).tree('getParent', node.target);
            if (rootNode == null || rootNode.id == "0") {
                return node;
            }
            return getParents(rootNode);
        }

    /**
     * 删除文件夹
     */
        function deleteFolder() {
            var node = $('#'+treeId).tree('getSelected');

            if (node) {
                var repository = getParents(node);
                if (repository.id == "0") {
                    message_Show('当前节点禁止删除');
                    return;
                }
                if(node.state == "closed"){
                    //有子节点
                    treeMsg = "当前目录下存在子目录，是否确认删除？";
                }else{
                    treeMsg = "确定删除该文件夹？";
                }
                $.messager.confirm('确认', treeMsg, function (r) {
                    if (r) {
                        $.post("catalog/delete", {
                            catalogNO: node.id,
                            repositoryName: repository.text
                        }, function (result) {
                            if (result.code == messagerCode.success) {
                                $("#"+treeId).tree('remove', node.target);
                                // if (rows.length > 0) {
                                //     $('#filelist').datagrid('reload');
                                // }
                                $.messager.show({
                                    title: '系统提示',
                                    msg: '数据已成功删除！',
                                    timeout: 3000,
                                    showType: 'slide'
                                });
                            } else {
                                $.messager.alert("系统提示", "数据删除失败！");
                            }
                        }, 'json').error(function(){
                        });
                    }
                });

            } else {
                $.messager.alert('系统提示', '请选择需要删除的信息');
            }
        }

    /**
     * 删除文件
     */
        function newDeleteFile() {
            //目录权限的判断
            var selectedRows = $("#"+datagridId1).datagrid('getSelections');
            if (selectedRows.length === 0) {
                message_Show("请选择需要删除的数据");
                return;
            }

            $.messager.confirm('系统提示', '请确认是否执行删除操作？', function (r) {
                if (r) {
                    var deleteList = [];
                    for (var i = 0; i < selectedRows.length; i++) {
                        var res = {};
                        res.tNO = selectedRows[i].tNO;
                        res.svnURL = selectedRows[i].svnURL;
                        deleteList.push(res);
                    }
                    if (deleteList.length > 1) {
                        message_Show("开始删除","",1000);
                    }
                    $.post("resource/delete.do", {
                            resList: JSON.stringify(deleteList)
                        },
                        function (result) {
                            if (result.code == "1000") {
                                $("#"+datagridId1).datagrid("reload");
                                $.messager.show({
                                    title: '系统提示',
                                    msg: '数据已成功删除！',
                                    timeout: 3000,
                                    showType: 'slide'
                                });
                            } else {
                                $.messager.alert("系统提示", "数据删除失败！");
                            }
                        }, "json").error(function(){
                    });
                }
            });


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




    </script>

    <style>



    </style>

</head>
<body id="resource_Layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        资源目录
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('resource_Layout','west')" class="layout-title-img">
    </div>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#'+treeId).tree('reload')" title="刷新">
            <img src="images/px-icon/newFolder.png" style="padding: 0px 10px;" class="easyui-tooltip div-toolbar-img-next"
                 onclick="repository_dialog_open()" title="新建版本库">
            <img src="images/px-icon/deleteFolder.png" style="padding: 0px 10px;" class="easyui-tooltip div-toolbar-img-next"
                 onclick="deleteFolder()" title="删除目录">
        </div>
    </div>
    <jsp:include page="/px-tool/px-tree.jsp">
        <jsp:param value="<%=treeId%>" name="div-id"/>
    </jsp:include>

    <!-- 新建版本库 -->
    <div id="repository_dialog" class="easyui-dialog" data-options="closed:true,modal:true,buttons:'#repository_dialog-buttons'">
        <form id="repository_form" method="post" novalidate>
            <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                <input id="department_TNO" name="tNO" type="hidden">
                <input name="pDepartmentTNO" type="hidden">
                <tr>
                    <td><span class="pxzn-span-three">名称</span></td>
                    <td>
                        <input id="repository_Name" name="catalogName" class="easyui-textbox pxzn-dialog-text"
                               data-options="required:true,validType:['space','fileOrCata','length[1,20]']">
                    </td>
                </tr>
            </table>
        </form>


    </div>

    <div id="repository_dialog-buttons" class="pxzn-dialog-buttons">
        <input type="button" onclick="repository_dialog_ok()" value="保存" class="pxzn-button">
        <input type="button" onclick="repository_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
    </div>
</div>

<div data-options="region:'center'">
    <div id="toolbar">
        <div class="datagrid-title-div"><span>资源列表</span></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#'+datagridId1).datagrid('reload')" title="刷新">
        <img src="images/px-icon/shanchu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="newDeleteFile()" title="删除">
        <img src="images/px-icon/daochu.png" class="easyui-tooltip div-toolbar-img-next"
             onclick="openDownloadList()" title="下载">
    </div>
    <jsp:include page="/px-tool/px-datagrid.jsp">
        <jsp:param value="<%=datagridId1%>" name="div-id"/>
        <jsp:param value="<%=toolbar%>" name="datagrid-toolbar"/>
    </jsp:include>

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

</div>
</body>
</html>