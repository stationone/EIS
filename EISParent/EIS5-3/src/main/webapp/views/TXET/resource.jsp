<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE HTML>
<html>
<head>
    </title>
    <base href="<%=basePath%>">
    <link rel="stylesheet" type="text/css" href="css/common/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/common/icon.css">
    <link rel="stylesheet" type="text/css" href="css/common/demo.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <link rel="stylesheet" type="text/css" href="css/upload/upload.css">

    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.easyui.min.1.5.2.js"></script>
    <script type="text/javascript" src="js/locale/easyui-lang-zh_CN.js "></script>
    <script type="text/javascript" src="js/dynamicOperation.js"></script>
    <script type="text/javascript" src="js/pxzn.util.js"></script>
    <style type="text/css">
        .progress-centre {
            position: absolute;
            background: rgba(76, 76, 76, 0.8);
            top: -1px;
            bottom: 0px;
            width: 100%;
        }

        .progress-bottom {
            position: absolute;
            background: rgb(228, 228, 228); /*不支持rgba的浏览器*/
            background: rgba(228, 228, 228, .5); /*支持rgba的浏览器*/
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#7f000000, endColorstr=#7f000000); /*IE8支持*/
            top: 27px;
            bottom: 0px;
            width: 100.5%;
            text-align: center;
            left: -2px;
            padding-top: 45px;
            z-index: 10;
        }

        /** 左侧目录右键菜单，鼠标移上 */
        .cataView_color:hover {
            background: #E0ECFF;
            cursor: pointer;
        }
    </style>
</head>
<body class="easyui-layout">
<div data-options="region:'west',split:false,border:false,title:'资源目录'" style="width:200px;">
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="../../../../../eis-business/business-knowledgeCenter/src/main/resources/META-INF/resources/images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#resTree').tree('reload')" title="刷新">
        </div>
    </div>
    <ul id="resTree" class="easyui-tree" style="height:auto;width: 100%"></ul>
</div>

<!-- 文件夹 -->
<div id="dlg" class="easyui-dialog" style="width:400px" data-options="closed:true, modal:true, buttons:'#dlg-buttons'">
    <form id="dlg_form" method="post" novalidate style="margin:0;padding:20px 50px">
        <div style="margin-bottom:5px">
            <input id="localStorageCatalogNO" type="hidden">
            <input id="c_catalogNO" name="catalogNO" type="hidden">
            <input id="" name="userRepository" type="hidden">
            <input id="c_repository" name="repositoryName" type="hidden">
            <input id="c_parentNO" name="parentNO" type="hidden">
            <input id="c_catalogPath" name="catalogPath" type="hidden">
            <input id="c_catalogName" name="catalogName" class="easyui-textbox" required="true"
                   data-options="validType:['space','keyword','fileOrCata','length[1,200]']" label="文件夹名称" style="width:100%">
        </div>
    </form>
</div>
<div id="dlg-buttons" style="text-align: center;">
    <a href="javascript:saveFolder()" id="saveFolder-button" class="easyui-linkbutton" iconCls="icon-ok"
       style="width:90px">保存</a>
    <a href="javascript:closeFolderDlg()" class="easyui-linkbutton" iconCls="icon-cancel" style="width:90px">取消</a>
</div>


<!-- 新建版本库 -->
<div id="repository_dialog" class="easyui-dialog" style="width:400px" closed="true" modal="true"
     buttons="#repository_dialog-buttons">
    <form id="repository_form" method="post" novalidate style="margin:0;padding:20px 50px">
        <div style="margin-bottom:5px">
            <input name="parentNO" type="hidden">
            <input id="repository_Name" name="catalogName" class="easyui-textbox" required="true"
                   data-options="validType:['space','fileOrCata','length[1,20]']" label="文件夹名称" style="width:100%">
        </div>
    </form>
</div>
<div id="repository_dialog-buttons" style="text-align: center;">
    <a href="javascript:repository_dialog_ok()" class="easyui-linkbutton" iconCls="icon-ok" style="width:90px">保存</a>
    <a href="javascript:repository_dialog_close()" class="easyui-linkbutton" iconCls="icon-cancel"
       style="width:90px">取消</a>
</div>

<div data-options="region:'center',border:false">
    <div id="toolbar">
        <div style="margin-bottom: 5px;padding-top: 10px;">
            &nbsp;&nbsp;资源编号：<input id="s_resId" name="s_resId" class="easyui-textbox" style="width:130px"
                                    onkeydown="if(event.keyCode==13) searchRes(1)">
            &nbsp;&nbsp;资源名称：<input id="s_resName" name="s_resName" class="easyui-textbox" style="width:130px"
                                    onkeydown="if(event.keyCode==13) searchRes(1)">
            &nbsp;&nbsp;资源类型：
            <select id="s_resType" name="s_resType" class="easyui-combobox"
                    data-options="editable:false, valueField:'id', textField:'text', panelHeight:'auto'"
                    style="width:150px;" onkeydown="if(event.keyCode==13) searchRes(1)">
            </select>
            &nbsp;&nbsp; 上传者：<input id="s_inputUser" name="s_inputUser" class="easyui-textbox" style="width:130px"
                                    onkeydown="if(event.keyCode==13) searchRes(1)">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px" onclick="searchRes(1)">查询</a>
        </div>
        <img src="../../../../../eis-business/business-knowledgeCenter/src/main/resources/META-INF/resources/images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first"
             onclick="$('#filelist').datagrid('reload');" title="刷新">
    </div>
    <!--资源列表显示-->
    <table id="filelist" title="资源列表" class="easyui-datagrid" style="width:100%;height:auto;"
           data-options="fit:true, toolbar:'#toolbar', pagination:true, rownumbers:true, fitColumns:true, singleSelect:false">
    </table>
</div>
<!--添加文件页面-->
<div id="file" class="easyui-dialog" style="width:450px;max-height: 500px"
     data-options="closed:true, modal:true, buttons:'#dlg-file'">
    <form id="filefm1" method="post" style="margin:0;padding:20px 30px" enctype="multipart/form-data">
        <%--<input class="easyui-textbox" data-options="validType:['account','length[1,10]']">--%>
    </form>
    <div id="dlg-file" style="text-align: center;">
        <a href="javascript:saveFile()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">保存</a>
        <a href="javascript:closeFileDlg()" class="easyui-linkbutton" iconCls="icon-cancel" style="width:90px">取消</a>
    </div>
</div>

<!-- 下载列表 -->
<div id="downloadList" class="easyui-dialog" data-options="modal:true, closed:true, buttons:'#download-btns'"
     style="width:700px;height:350px;">
    <table id="histList" title="" class="easyui-datagrid" style="width:auto;height:auto"
           data-options="pagination:true, fit:true, rownumbers:true, fitColumns:true, singleSelect:true">
    </table>
</div>
<div id="downloadDlg" class="easyui-dialog" style="width:400px"
     data-options="modal:true,closed:true,buttons:'#download-btns'">
    <form id="downloadForm" method="post" novalidate style="margin:0;padding:20px 50px">
        <div style="margin-bottom:10px;font-size:14px;"></div>
        <div style="margin-bottom:5px;">
            <span id="text"></span>
            <input id="d_svnURL" name="svnURL" type="hidden">
            <input id="d_svnVersion" name="svnVersion" type="hidden">
        </div>
    </form>
    <div id="download-btns" style="text-align: center; margin-right:10px; margin-bottom: 5px;">
        <a href="javascript:downloadFiles()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">下载</a>
        <a href="javascript:closeDownloadDlg()" class="easyui-linkbutton" iconCls="icon-cancel"
           style="width:90px">取消</a>
    </div>


</div>

<div id="preview"></div>

<div id="cataView" class="easyui-menu" style="width:120px; display:none;">

</div>


<%--批量上传--%>
<div id="files" class="easyui-dialog" style="width:600px"
     data-options="closed:true, modal:true, title:'批量上传', buttons:'#files_form_btns'">
    <form id="files_form" method="post" novalidate style="width:550px;margin:0 auto;padding:20px 0 0 0"
          enctype="multipart/form-data">
        <input id="files_id" name="resId" type="hidden">
        <input id="files_catalogNO" name="catalogNO" type="hidden">
        <input id="files_catalogPath" name="catalogPath" type="hidden">
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
        <a href="javascript:files_form_save()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">上传</a>
        <a href="javascript:files_form_close()" class="easyui-linkbutton" iconCls="icon-cancel"
           style="width:90px">取消</a>
    </div>
</div>
<%--扩展属性--%>
<div id="files_attributes_dialog" class="easyui-dialog" style="width: 600px;" data-options="closed:true">

</div>

<%--检出版本库--%>
<div id="checkOutRepository" class="easyui-dialog" style="width:500px" closed="true" modal="true" title="检出"
     buttons="#checkOutRepository_button">
    <form id="checkOutRepository_form" method="post" novalidate style="margin:0;padding:20px 0 10px 0"
          enctype="multipart/form-data">

        <div style="width: 460px;margin: 0 auto">
            <input id="checkOutCatalogNO" name="catalogNO" type="hidden">
            <table style="width: 100%" cellpadding="5">
                <tr>
                    <td>
                        <span style="width: 100px">检出目录名称:</span>
                    </td>
                    <td>
                        <input id="userRepositoryName" name="userRepositoryName" class="easyui-textbox"
                               data-options="readonly:true" style="width: 350px;">
                    </td>
                </tr>
                <tr>
                    <td>
                        <span style="width: 100px">检出目录路径:</span>
                    </td>
                    <td>
                        <input id="catalogSvnURL" name="catalogSvnURL" class="easyui-textbox"
                               data-options="readonly:true" style="width: 350px;">
                    </td>
                </tr>
                <tr>
                    <td>
                        <span style="width: 100px;margin-left: 23px">版本库:</span>
                    </td>
                    <td>
                        <input id="svnRepositoryNO" class="easyui-combobox" style="width: 340px;"
                               data-options="panelHeight:100">
                    </td>
                </tr>
            </table>
        </div>

        <div style="margin: 0 auto;margin-top: 20px; width: 400px;">
            <span>版本库列表</span>
            <table id="checkOutRepository_treegrid" class="easyui-treegrid" style="width:400px;height:200px;"
                   data-options="idField:'id',treeField:'name',fitColumns:true">
            </table>
        </div>
    </form>
    <div id="checkOutRepository_button" style="text-align: center; margin-right:10px; margin-bottom: 5px;">
        <a href="javascript:checkOutRepository_ok()" class="easyui-linkbutton c6" style="width:70px">确定</a>
        <a href="javascript:checkOutRepository_close()" class="easyui-linkbutton c6"
           style="margin-left: 50px;width:70px">取消</a>
    </div>
</div>


<script type="text/javascript">

    //树目录文本，true 拼接目录, false 需拼接进行中状态
    var typeFlag = true;

    function fatherText() {
        var data = {};
        var jsonArray = [];
        var jsonObject = {};
        jsonObject.field = 'UserId';
        jsonObject.title = '登录名';
        jsonObject.width = 100;
        jsonArray.push(jsonObject);
        data.url = "users/list.do";
        data.title = jsonArray;

        var childWindow = $("#textIframe")[0].contentWindow; //表示获取了嵌入在iframe中的子页面的window对象。  []将JQuery对象转成DOM对象，用DOM对象的contentWindow获取子页面window对象。
        childWindow.setDatagrid(data);
        parent.topFather();
    }

    $(function () {

        //获取标题
        getTabFieldInfo();
        $('#resTree').tree({
            url: 'resCatalogTree/newGetTree.do',
            onClick: function (node) {
                var attr = node.attributes;
                if (attr != null) {
                    var status = attr[0].status;
                    if (status != null) {
                        return;
                    }
                }
                $("#localStorageCatalogNO").val(node.id);
                $("#filelist").datagrid('load', {
                    "resId": $("#s_resId").textbox("getValue"),
                    "resName": $("#s_resName").textbox("getValue"),
                    "resType": $("#s_resType").combobox('getValue'),
                    "inputUser": $("#s_inputUser").textbox("getValue"),
                    "catalogNO": node.id
                });
                eastyuiOverTimeOrError($("#filelist"), 'datagrid');

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
                                return node.text + '<span style="color:#4ecc44;margin-left: 20px;">' + power + '</span><img src="../../../../../eis-business/business-knowledgeCenter/src/main/resources/META-INF/resources/images/px-icon/loading.gif" style="width: 14px;margin-left:10px;position: relative;top: 2px;">';
                            }
                            // <img src="images/px-icon/loading.gif" style="width: 14px;margin-left:10px;position: relative;top: 2px;">
                            return node.text + '<span style="color:#4ecc44;margin-left: 20px;">' + power + '</span>';
                        }


                    }
                typeFlag = true;

                return node.text;
            },
            onBeforeExpand: function (node) {

            },
            onExpand:function(node){

                var userId =  '${currentUser.userId}';
                if(userId == 'admin'){
                    return;
                }
                if (node == null) {
                    return;
                }

                var parent = $('#resTree').tree("getParent", node.target);
                if (parent != null) {
                    //说明不是根节点，不需要更新
                    return;
                }

                updateNode(node, 'true');
            }
        });

        eastyuiOverTimeOrError($('#resTree') ,'tree');

        $('#filelist').datagrid('options').url = "res/list.do";

        //文件格式条件
        $.ajax({
            type: 'GET',
            url: 'res/queryResType.do?t=' + new Date().getTime(),
            dataType: 'JSON',
            success: function (data) {

                data = returnMessager(data);
                if(data == null){
                    return;
                }

                var dataList = [];
                dataList.push({"id": "", "text": "请选择...", "selected": true});
                var datas = data.res;
                if (datas != null) {
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i] != null) {
                            dataList.push({"id": datas[i].resType, "text": datas[i].resType});
                        }
                    }
                }

                $("#s_resType").combobox("loadData", dataList);
                $("#s_preResType").combobox("loadData", dataList);

            },
            error:function(){
                serverError();
            }

        });


    });




    var checkedItems = [];

    function findCheckedItem(ID) {
        for (var i = 0; i < checkedItems.length; i++) {
            if (checkedItems[i] == ID)
                return i;
        }
        return -1;
    }




    function closeFileDlg() {
        $('#file').dialog('close');
        $("#filefm1").form("clear");
    }

    /**
     * 删除文件
     */
    function newDeleteFile() {
        //目录权限的判断
        var node = $('#resTree').tree('getSelected');
        if (node) {
            if (node.attributes[0].rw.toUpperCase() != "rw".toUpperCase()) {
                $.messager.alert("系统提示", "没有操作权限!");
                return;
            }
        }
        var selectedRows = $("#filelist").datagrid('getSelections');
        if (selectedRows.length == 0) {
            $.messager.alert("系统提示", "请选择要删除的数据！");
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
                    $.messager.show({
                        title: '系统提示',
                        msg: '开始删除',
                        timeout: 1000,
                        showType: 'slide'
                    });
                }

                $.post("res/newDelete.do", {
                        resList: JSON.stringify(deleteList)
                    },
                    function (result) {
                        result = returnMessager(result);
                        if(result == null){
                            return;
                        }
                        if (result.status == "1000") {
                            $("#filelist").datagrid("reload");
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
                    serverError();
                });


            }
        });


    }

    //条件查询
    function searchRes(temp) {
        if (temp == 1) {
            var node = $('#resTree').tree('getSelected');
            if (node) {
                $("#filelist").datagrid('load', {
                    "resId": $("#s_resId").textbox("getValue"),
                    "resName": $("#s_resName").textbox("getValue"),
                    "resType": $("#s_resType").combobox('getValue'),
                    "inputUser": $("#s_inputUser").textbox("getValue"),
                    "catalogNO": node.id
                });
            } else {
                $("#filelist").datagrid('load', {
                    "resId": $("#s_resId").textbox("getValue"),
                    "resName": $("#s_resName").textbox("getValue"),
                    "resType": $("#s_resType").combobox('getValue'),
                    "inputUser": $("#s_inputUser").textbox("getValue")
                });
            }
        } else if (temp == 2) {
            $("#preResList").datagrid('load', {
                "resId": $("#s_preResId").textbox("getValue"),
                "resName": $("#s_preResName").textbox("getValue"),
                "resType": $("#s_preResType").combobox('getValue'),
                "inputUser": $("#s_preInputUser").textbox("getValue"),
                "exceptId": $("#resId").textbox('getValue')
            });
        }
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

    //打开文件下载列表
    function openDownloadList() {
        //目录权限的判断
        var node = $('#resTree').tree('getSelected');
        if (node) {
            if (node.attributes[0].rw.toUpperCase() == "p".toUpperCase()) {
                $.messager.alert("系统提示", "没有操作权限!");
                return;
            }
        }
        var selectedRows = $("#filelist").datagrid("getSelections");
        if (selectedRows.length == 0) {
            $.messager.alert("系统提示", "请选择需要下载的数据！");
            return;
        }
        if (selectedRows.length > 1) {
            $.messager.alert("系统提示", "请选择一条需要下载的数据！");
            return;
        }
        var row = selectedRows[0];
        $('#downloadForm').form('clear');
        $('#downloadList').dialog('open').dialog('center').dialog('setTitle', '下载资源');



        $('#histList').datagrid({
            url: 'res/listVersion.do',
            queryParams: {
                tNO: row.tNO,
                svnURL: row.svnURL
            },
            columns: [[
                {field: 'histAction', title: '操作', width: 20}
                , {field: 'userId', title: '作者', width: 50}
                , {field: 'histResName', title: '文件名称', width: 60}
                , {field: 'histVersion', title: '版本号', width: 20}
                , {field: 'histTime', title: '操作时间', width: 50, formatter: formatDate}
                , {field: 'download', title: '操作', width: 50, formatter: formatAction}
            ]]
        });

        eastyuiOverTimeOrError($('#histList'), 'datagrid');

    }

    function closeDownloadDlg(){
        $('#downloadDlg').dialog('close');
    }

    function openDownloadDlg() {
        var selectedRows = $("#histList").datagrid("getSelections");
        if (selectedRows.length == 0) {
            $.messager.alert("系统提示", "请选择需要下载的文件！");
            return;
        }
        var row = selectedRows[0];
        $('#downloadDlg').dialog('open').dialog('center').dialog('setTitle', '下载资源');
        $("#text").text("确认继续下载资源【" + row.histResName + "】？");
        $('#downloadForm').form('load', {
            svnURL: row.histResURL,
            svnVersion: row.histVersion
        });

    }

    function downloadFiles() {
        $("#downloadForm").form("submit", {
            url: "res/download.do",
            onSubmit: function () {
                $.messager.alert('系统提示', '开始下载');
                return $(this).form("validate");
            },
            success: function (data) {
                if(data == ""){
                    serverError();
                    return;
                }
                data = eval('(' + data + ')');
                data = returnMessager(data);
                if(data == null){
                    return;
                }
            }
        });

        $("#downloadDlg").dialog("close");
    }


    /**
     * 检出版本库
     */
    var checkOutFlag = true;
    function checkOutRepository_open() {
        if(!checkOutFlag){
            $.messager.alert('系统提示','正在检出中，请稍后!');
            return;
        }

        $('#checkOutRepository_form').form('clear');
        $('#svnRepositoryNO').combobox({
            url: 'resCatalog/queryRepository',
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
                $('#checkOutRepository_treegrid').treegrid("load", {
                    catalogNO: row.catalogNO,
                    parentNO: "0"
                });
                var svnRepositoryName = $('#svnRepositoryNO').combobox('getText');
                $('#localrepositoryName').textbox('setValue', svnRepositoryName);
            }
        });


        $('#checkOutRepository_treegrid').treegrid({
            url: 'resCatalogTree/queryCatalogTree.do',
            idField: 'catalogNO',
            treeField: 'catalogName',
            columns: [[
                {field: 'catalogName', title: '名称', width: 50,},
                {field: 'power', title: '权限', width: 50,},
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
        eastyuiOverTimeOrError($('#checkOutRepository_treegrid'), 'datagrid');

        $('#checkOutRepository').dialog('open');
    }

    //保存
    function checkOutRepository_ok() {

        $('#checkOutRepository_form').form('submit', {
            url: 'resCatalog/checkOutSvn',
            onSubmit: function () {
                var catalogNO = $('#checkOutCatalogNO').val();
                if (catalogNO == "") {
                    $.messager.alert('系统提示', '请选择需要检出的目录');
                    return false;
                }
                $.messager.show({
                    title: '系统提示',
                    msg: '开始检出，检出时间根据文件的数量和大小而定，请耐心等待',
                    timeout: 3000,
                    showType: 'slide'
                });
                checkOutFlag = false;
                setCheckoutRunIcon();
                checkOutRepository_close();
                return true;
            },
            success: function (data) {
                checkOutFlag = true;
                setCheckoutIcon();
                if(data == ""){
                    serverError();
                   return;
                }
                data = JSON.parse(data);
                data = returnMessager(data);
                if(data == null){
                    return;
                }

                $(".messager-body").window('close');
                if (data.status == messagerCode.success) {

                    $.messager.alert('系统提示', '检出成功');
                    $('#resTree').tree('reload');
                } else if (data.status == '2004') {
                    $.messager.alert('系统提示', '检出名称重复');
                } else {
                    $.messager.alert('系统提示', '检出失败');
                }
            }
        }, 'json');


    }

    /**
     * 设置检出图标
     */
    function setCheckoutIcon(){
        setIcon('toolbar1', 'images/px-icon/checkout_run.gif', 'images/px-icon/checkout.png');
    }

    /**
     * 设置检出中图标
     */
    function setCheckoutRunIcon(){
        setIcon('toolbar1', 'images/px-icon/checkout.png', 'images/px-icon/checkout_run.gif');

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
                if(src == oldIconSrc){
                    childrens[i].setAttribute("src",newIconSrc);
                    return;
                }
            }
        }
    }


    //取消
    function checkOutRepository_close() {

        $('#checkOutRepository').dialog('close');
    }

    //删除个人版本库
    function deleteUserRepository() {
        var node = $('#resTree').tree('getSelected');
        if (node == null) {
            $.messager, alert("请选择一条需要删除的根节点");
            return;
        }
        var attr = node.attributes;
        if (attr == null) {
            $.messager.alert("系统提示", "请刷新页面再次尝试");
            return;
        }
        var tNO = attr[0].tNO;
        if (tNO == null) {
            $.messager.alert("系统提示", "当前节点禁止删除，请选择顶级节点");
            return;
        }
        $.messager.confirm('系统提示', '请确认是否删除 ' + node.text + ' ?', function (r) {
            if (r) {
                $.ajax({
                    type: 'GET',
                    url: 'resCatalog/newDeleteUserRepository',
                    dataType: 'JSON',
                    data: {tNO: tNO},
                    success: function (data) {
                        data = returnMessager(data);
                        if(data == null){
                            return;
                        }
                        var status = data.status;
                        if (status == "1000") {
                            $('#resTree').tree('remove', node.target);
                            $('#filelist').datagrid('load');
                            $.messager.alert('系统提示', '删除成功');
                        } else if (status == '2003') {
                            $.messager.alert('系统提示', '参数不合法');
                        } else if (status == '2005') {
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
     * 新建版本库
     */
    //打开
    function repository_dialog_open() {

        $('#repository_form').form('clear');
        $('#repository_form').form('load', {
            parentNO: 0
        })
        $('#repository_dialog').dialog('open').dialog('center').dialog('setTitle', '新建版本库');
    }

    //保存
    function repository_dialog_ok() {

        $("#repository_form").form("submit", {
            url: "resCatalog/repositorySave.do",
            onSubmit: function () {
                return $(this).form("validate");
            },
            success: function (result) {
                if(result == ""){
                    //系统异常
                    serverError();
                    return;
                }
                result = eval('(' + result + ')');
                result = returnMessager(result);
                if(result == null){
                    return;
                }

                var status = result.status;
                if (status == messagerCode.success) {
                    var node = $('#resTree').tree('find', 0);//默认给版本仓库节点下增加版本库
                    $('#resTree').tree('append', {
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


                } else if (status == '2004') {
                    $.messager.alert('系统提示', '名称重复');
                    $('#c_catalogName').textbox().next('span').find('input').focus();
                    $('#saveFolder-button').linkbutton('enable');
                } else if (status == "2003") {
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

    //新建目录文件夹
    function newFolder() {
        $('#saveFolder-button').linkbutton('enable');
        var node = $('#resTree').tree('getSelected');
        if (node == null) {
            $.messager.alert("系统提示", "请选择父级目录！");
            return;
        }
        var attr = node.attributes;
        if (attr == null) {
            $.messager.alert("系统提示", "没有操作权限!");
            return;
        } else if (attr[0].rw.toUpperCase() != "rw".toUpperCase()) {
            $.messager.alert("系统提示", "没有操作权限!");
            return;
        }
        var repositoryName = attr[0].svnURL;
        var reNa = repositoryName.split("/");
        $('#dlg_form').form('clear');
        $('#dlg_form').form('load', {
            parentNO: node.id,
            repositoryName: reNa[0],
            userRepository: getParent(node).text,
            catalogPath: attr[0].catalogPath
        })
        $('#dlg').dialog('open').dialog('center').dialog('setTitle', '新建文件夹');
    };

    /**
     * 获取树结构
     * 根节点id
     */
    function getParent(node) {
        console.log(node);
        var rootNode = $('#'+treeId).tree('getParent', node.target);
        if (rootNode == null) {
            return node;
        }
        return getParent(rootNode);
    }

    /**
     * 获取版本库
     * 删除用
     */
    function getParents(node) {
        var rootNode = $('#resTree').tree('getParent', node.target);
        if (rootNode == null || rootNode.id == "0") {
            return node;
        }
        return getParents(rootNode);
    }

    //编辑文件夹
    function editFolder() {
        $('#saveFolder-button').linkbutton('enable');
        var node = $('#resTree').tree('getSelected');
        if (node != null) {
            if (node.attributes[0].rw.toUpperCase() != "rw".toUpperCase()) {
                $.messager.alert("系统提示", "没有操作权限!");
                return;
            }
            $('#dlg').dialog('open').dialog('center').dialog('setTitle', '编辑文件夹');
            $('#dlg_form').form('load', node);
            $("#c_catalogNO").val(node.id);
            $("#c_catalogName").textbox('setValue', node.text);
        } else {
            $.messager.alert('警告', '请选择需要编辑的信息！');
        }
        ;
    };

    //保存
    function saveFolder() {
        $("#dlg_form").form("submit", {
            url: "resCatalog/newSave.do",
            onSubmit: function () {
                if ($(this).form("validate")) {
                    $('#saveFolder-button').linkbutton('disable');
                }
                return $(this).form("validate");
            },
            success: function (result) {
                if(result == ""){
                    serverError();
                    return;
                }
                result = eval('(' + result + ')');
                result = returnMessager(result);
                if(result == null){
                    return;
                }
                var status = result.status;
                if (status == messagerCode.success) {
                    var node = $('#resTree').tree('getSelected');
                    var c_catalogName = $('#c_catalogName').textbox('getValue');
                    var c_catalogPath = $('#c_catalogPath').val();
                    if (c_catalogPath != "") {
                        c_catalogPath = c_catalogPath + "/";
                    }
                    $('#resTree').tree('append', {
                        parent: node.target,
                        data: [{
                            id: result.catalogNO,
                            text: c_catalogName,
                            attributes: [{
                                rw: 'RW',
                                catalogPath: c_catalogPath + c_catalogName,
                                svnURL: $('#c_repository').val()+'/'+c_catalogPath + c_catalogName
                            }]
                        }]
                    })
                    $.messager.show({
                        title: '系统提示', msg: '新建成功!',
                        timeout: 3000, showType: 'slide'
                    });
                    closeFolderDlg();

                } else if (status == '2004') {
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

    //关闭创建文件夹窗体
    function closeFolderDlg() {
        $("#dlg").dialog("close");
    }

    //删除文件夹
    function deleteFolder() {
        var node = $('#resTree').tree('getSelected');

        if (node) {
            if (node.attributes[0].rw.toUpperCase() != "rw".toUpperCase()) {
                $.messager.alert("系统提示", "没有操作权限!");
                return;
            }
            var repository = getParents(node);
            if (repository.id == "0") {
                $.messager.alert("系统提示", "禁止删除");
                return;
            }
            var rows = $('#filelist').datagrid('getRows');

            //当前目录下是否存在子目录
            var childrenNodes = $('#resTree').tree('getChildren', node.target);
            var treeMsg = "";
            if (childrenNodes != "") {
                treeMsg = "当前目录下存在子目录，确认删除吗？";
            } else {
                treeMsg = "确定删除该文件夹？";
            }
            $.messager.confirm('确认', treeMsg, function (r) {
                if (r) {
                    $.post("resCatalog/newDelete.do", {
                        catalogNO: node.id,
                        repositoryName: repository.text
                    }, function (result) {
                        result = returnMessager(result);
                        if(result == null){
                            return;
                        }
                        if (result.status) {
                            $("#resTree").tree('remove', node.target);
                            if (rows.length > 0) {
                                $('#filelist').datagrid('reload');
                            }
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
                        serverError();
                    });
                }
            });

        } else {
            $.messager.alert('系统提示', '请选择需要删除的信息');
        }
    }

    //扩展属性
    var tabFieldInfosList = [];

    //编辑资源
    function editFile() {
        $('#progress_span_text1').text("");
        //目录权限的判断
        var node = $('#resTree').tree('getSelected');
        if (node) {
            if (node.attributes[0].rw.toUpperCase() != "rw".toUpperCase()) {
                $.messager.alert("系统提示", "没有操作权限!");
                return;
            }
        }

        var selectedRows = $("#filelist").datagrid("getSelections");
        if (selectedRows.length == 0) {
            $.messager.alert("系统提示", "请选择需要编辑的数据！");
            return;
        }
        if (selectedRows.length > 1) {
            $.messager.alert("系统提示", "请选择一条需要编辑的数据！");
            return;
        }
        var row = selectedRows[0];

        $('#filefm1').empty();

        $.ajax({
            type: 'post',
            url: 'tabFieldInfo/queryAll.do',
            async:false,
            dataType: 'json',
            data: {tabCode: "PDM_RES"},
            success: function (data) {
               var result = returnMessager(data);
                if (result == null) {
                    return;
                }
                tabFieldInfosList = result.result;
                var divHtml = '<table style="width: 100%;" cellpadding="8">';
                divHtml += '<input id="form_extend" name="extend" type="hidden" >';

                for (var i = 0; i < tabFieldInfosList.length; i++) {
                    var item = tabFieldInfosList[i];
                    //允许编辑
                    if (item == null) {
                        continue;
                    }
                    if (item.editable == "1") {
                        //是否可见
                        if (item.visible != "1") {
                            //不可见
                            divHtml += '<tr style="display: none;">';
                        } else {
                            //可见
                            divHtml += '<tr>';
                        }
                        var value = row[item.fieldCode];
                        if (value == null || value == "") {
                            value = item.defaultVal;
                        }

                        if (item.fieldType == "varchar") {
                                if(item.fieldCode == "remark"){
                                    divHtml += '<td>';
                                    divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '">' + item.fieldName + '</span></div>';
                                    divHtml += '</td>';
                                    divHtml += '<td><div>';                                                                                       // validType:['account':'length[1,10]'] item.fieldLen
                                    if(item.isNull == "1"){
                                        divHtml += '<input id="' + item.fieldCode + '" name="'+item.fieldCode+'" class="easyui-textbox" data-options="validType:[\'keyword\',\'space\',\'length[0,' + item.fieldLen + ']\']" value="' + value + '" style="width: 200px">';
                                    }else{
                                        divHtml += '<input id="' + item.fieldCode + '" name="'+item.fieldCode+'" class="easyui-textbox" data-options="validType:[\'keyword\',\'space\',\'length[0,' + item.fieldLen + ']\']" required="true" value="' + value + '" style="width: 200px">';
                                    }

                                    divHtml += '</div></td></tr>';
                                }else{
                                    divHtml += '<td>';
                                    divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '">' + item.fieldName + '</span></div>';
                                    divHtml += '</td>';
                                    divHtml += '<td><div>';                                                                                       // validType:['account':'length[1,10]'] item.fieldLen
                                    if(item.isNull == "1"){
                                        divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-textbox" data-options="validType:[\'keyword\',\'space\',\'length[0,' + item.fieldLen + ']\']" value="' + value + '" style="width: 200px">';
                                    }else{
                                        divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-textbox" data-options="validType:[\'keyword\',\'space\',\'length[0,' + item.fieldLen + ']\']" required="true" value="' + value + '" style="width: 200px">';
                                    }

                                    divHtml += '</div></td></tr>';
                                }


                            //日期
                        } else if (item.fieldType == "datetime") {
                                //是否可见
                                divHtml += '<td>';
                                divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '">' + item.fieldName + '</span></div>';
                                divHtml += '</td>';
                                divHtml += '<td><div>';                                                                                       // validType:['account':'length[1,10]'] item.fieldLen
                                if(item.isNull == "1"){
                                    divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-datetimebox" data-options="editable:false" value="' + value + '" style="width: 200px">';
                                }else{
                                    divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-datetimebox" data-options="editable:false" required="true" value="' + value + '" style="width: 200px">';
                                }

                                divHtml += '</div></td></tr>';
                        }else if(item.fieldType == "int"){
                            divHtml += '<td>';
                            divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '">' + item.fieldName + '</span></div>';
                            divHtml += '</td>';
                            divHtml += '<td><div>';                                                                                       // validType:['account':'length[1,10]'] item.fieldLen
                            if(item.isNull == "1"){
                                divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-numberbox" data-options="" value="' + value + '" style="width: 200px">';
                            }else{
                                divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-numberbox" data-options="" required="true" value="' + value + '" style="width: 200px">';
                            }

                            divHtml += '</div></td></tr>';
                        }
                        //不可编辑
                    } else if (item.editable == "0") {
                        var name = "";
                        var fieldCode = item.fieldCode;
                        if(fieldCode == "tNO"){
                            name = fieldCode;
                        }

                        //是否可见
                        if (item.visible != "1") {
                            //不可见
                            divHtml += '<tr style="display: none;">';
                        } else {
                            //可见
                            divHtml += '<tr>';
                        }
                        var value = row[item.fieldCode];
                        if (value == null || value == "") {
                            value = item.defaultVal;
                        }

                        if (item.fieldType == "varchar") {
                            //是否可见
                            divHtml += '<td>';
                            divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '">' + item.fieldName + '</span></div>';
                            divHtml += '</td>';
                            divHtml += '<td><div>';                                                                                       // validType:['account':'length[1,10]'] item.fieldLen
                            divHtml += '<input id="filefm_' + item.fieldCode + '" name="'+ name +'" class="easyui-textbox" data-options="readonly:true,validType:[\'keyword\',\'space\',\'length[0,' + item.fieldLen + ']\']" value="' + value + '" style="width: 200px">';
                            divHtml += '</div></td></tr>';

                            //日期
                        } else if (item.fieldType == "datetime") {
                            //是否可见
                            divHtml += '<td>';
                            divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '">' + item.fieldName + '</span></div>';
                            divHtml += '</td>';
                            divHtml += '<td><div>';                                                                                       // validType:['account':'length[1,10]'] item.fieldLen
                            divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-datetimebox" data-options="readonly:true,editable:false" value="' + value + '" style="width: 200px">';
                            divHtml += '</div></td></tr>';
                        }else if(item.fieldType == "int"){
                            divHtml += '<td>';
                            divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '">' + item.fieldName + '</span></div>';
                            divHtml += '</td>';
                            divHtml += '<td><div>';                                                                                       // validType:['account':'length[1,10]'] item.fieldLen
                            divHtml += '<input id="filefm_' + item.fieldCode + '" class="easyui-numberbox" data-options="readonly:true" value="' + value + '" style="width: 200px">';

                            divHtml += '</div></td></tr>';
                        }

                        // divHtml += '<tr style="display:none">';
                        // divHtml += '<td>';
                        // divHtml += '<div style="width: 90px;height:16px;overflow: hidden"><span class="easyui-tooltip" title="' + item.fieldName + '" style="">' + item.fieldName + '</span></div>';
                        // divHtml += '</td>';
                        // divHtml += '<td><div>';
                        // if(item.fieldCode == 'tNO'){
                        //     divHtml += '<input id="filefm_' + item.fieldCode + '" name="' + item.fieldCode + '" type="text" style="width: 200px">';
                        // }else{
                        //     divHtml += '<input id="filefm_' + item.fieldCode + '" type="text" style="width: 200px">';
                        // }
                        //
                        // divHtml += '</div></td></tr>';

                    }
                }
                    divHtml += '</table>';
                    $("#filefm1").append(divHtml);
                    //form进行渲染
                    $.parser.parse('#filefm1');

                $('#file').dialog('open').dialog('center').dialog('setTitle', '编辑资源');
                $('#filefm1').form('load', row);


            },
            error:function(){
                serverError();
            }
        });

    }

    //保存资源
    function saveFile() {
        if (!$('#filefm').form("validate")) {
            return;
        };

        var row = $('#filelist').datagrid('getSelected');
        if (row != null) {
            $('#filefm_tNO').val(row.tNO);
        }

        var extendJson = {};
        for (var i = 0; i < tabFieldInfosList.length; i++) {
            var tabFieldInfo = tabFieldInfosList[i];
            extendJson[tabFieldInfo.fieldCode] = $('#filefm_' + tabFieldInfo.fieldCode).val();

        }
        $('#form_extend').val(JSON.stringify(extendJson));


        $('#filefm1').form('submit',{
            url:'res/save.do',
            success:function(result){

                if(result == ""){
                    serverError();
                    return;
                }
                result = JSON.parse(result);
                result = returnMessager(result);
                if(result == null){
                    return;
                }
                if (result.status == messagerCode.success) {
                    $("#filelist").datagrid("reload");
                    closeFileDlg();
                    $.messager.show({
                        title: '系统提示',
                        msg: '更新成功!',
                        timeout: 3000,
                        showType: 'slide'
                    });

                } else {
                    $.messager.alert("系统提示", "更新失败!");
                }
            }
        })
    }


    /**
     * 批量提交文件操作
     */
    //批量上传打开
    function files_open() {
       if(!parent.fileUploadFlag){
           //文件未上传完成，禁止上传
           $.messager.alert("系统提示", "文件未上传完成，请等待上传成功后再次上传！");
           return;
       }
        fileArray = [];
        $('#files_form').form('clear');
        $('#files_Text').empty();
        $('#fileAllSize').text("");
        $('#fileNumber').text("");
        var node = $('#resTree').tree('getSelected');
        if (node == null) {
            $.messager.alert("系统提示", "请选择对应的目录！");
            return;
        } else if (node.attributes[0].rw.toUpperCase() != "rw".toUpperCase()) {
            $.messager.alert("系统提示", "没有操作权限!");
            return;
        }

        $.ajax({
            type: 'post',
            url: 'res/queryMaxId.do',
            dataType: 'json',
            success: function (data) {
                data = returnMessager(data);
                if(data == null){
                    return;
                }

                $('#files_id').val(data.returnId);
                $("#files_catalogNO").val(node.id);
                $("#files_catalogPath").val(node.attributes[0].catalogPath);
            },
            error:function(){
                serverError();
            }
        });

        //添加更新版本库操作
        if (node){
            updateNode(node, 'false');
        }
        $('#files').dialog('open');
    }

    /**
     * 更新节点
     * depth 递归更新 true, 直接更新false;
     */
    var updateNodeNumber = 0;
    //递归更新的节点
    var updateNodeAll = [];
    function updateNode(node, depth){

        typeFlag = false;
        updateNodeNumber++;
        var attr = node.attributes;

        if(depth == 'true'){
            //递归更新
            if(updateNodeAll.length > 0){
                for (var i = 0; i < updateNodeAll.length; i++) {
                    var id = updateNodeAll[i];
                    if (node.id == id) {
                        return;
                    }
                }
            }
            updateNodeAll.push(node.id);
        }else{
            //普通更新
            var parentNode = getParent(node);
            if(updateNodeAll.length > 0){
                for (var i = 0; i < updateNodeAll.length; i++) {
                    var id = updateNodeAll[i];
                    if (parentNode.id == id) {
                        return;
                    }
                }
            }
        }

        $('#'+treeId).tree('update', {
            target: node.target,
            text: node.text
        });


        //第一次更新
        $.messager.show({
            title: '系统提示',
            msg: '开始更新，更新时间根据文件的数量和大小而定，请耐心等待',
            timeout: 3000,
            showType: 'slide'
        });

        var parentNode = getParent(node);

        $.ajax({
            url: 'resCatalogTree/updateTree.do?t=' + new Date().getTime(),
            type: 'POST',
            dataType: 'JSON',
            data: {
                userRepositoryName: parentNode.text,
                svnURL: attr[0].svnURL,
                depth:depth
            },
            success: function (data) {
                data = returnMessager(data);
                if(data == null){
                    return;
                }
                try{
                    $(".messager-body").window('close');
                }catch(e) {

                }

                var datas = data.status;
                if (datas == '1000') {
                        $.messager.show({
                            title: '系统提示',
                            msg: '更新完成，可进行上传操作!',
                            timeout: 3000,
                            showType: 'slide'
                        });
                } else {
                    $.messager.show({
                        title: '系统提示',
                        msg: '更新失败',
                        timeout: 3000,
                        showType: 'slide'
                    });
                }

                if(depth == 'true') {
                    if (updateNodeAll.length > 0) {
                        for (var i = 0; i < updateNodeAll.length; i++) {
                            var id = updateNodeAll[i];
                            if (node.id == id) {
                                updateNodeAll.splice(i,1);
                                break;
                            }
                        }
                    }
                }
                try {
                    $('#resTree').tree('update', {
                        target: node.target,
                        text: node.text
                    });
                }catch (e){

                }

            },
            error:function(){
                serverError();
            }
        })
    }

    /**
     * 设置text
     * node
     * type (true：直接显示 ,false：需要显示状态)
     */
    function setText(node, type){
        if(type){

        }
        var attr = node.attributes;
        if (attr != null) {
            var status = attr[0].status;
            if (status != null) {
                return node.text + '<span style="color:red">(节点不存在,请删除)</span>';
            }
            var power = attr[0].rw;
            if (power != null) {
                // <img src="images/px-icon/loading.gif" style="width: 14px;margin-left:10px;position: relative;top: 2px;">
                return node.text + '<span style="color:#4ecc44;margin-left: 20px;">' + power + '</span>';
            }
        }
    }


    //清空数据
    function clearform() {
        $('#time').progressbar('setValue', 0);
        $('#fileNumber').text("");
        $('#fileAllSize').text("");
        $('#files_Text').empty();
        fileArray = [];
        fileLists = [];
        fileAllSize = 0;

    }

    //选择文件
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
                $('#files_Text').append('<div id="' + fileRelevance.id + '" class="default" style="margin-top:5px;margin-left:8px;margin-right: 8px;" title="' + fileArray[i].name + '" class="easyui-tooltip" ><div style="float: left; width:279px;height:20px;font-size:14px;overflow:hidden;padding:3px 0;">' + fileArray[i].name + '</div><img style="width:20px;float:right" class="pointer" onmouseenter="pitchOn(this)" onmouseleave="uncheck(this)" onclick="removeDiv(\'' + fileRelevance.id + '\')" src="../../../../../eis-business/business-knowledgeCenter/src/main/resources/META-INF/resources/images/px-icon/delete.png"></div>');
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

    /**
     * 批量上传
     * 一条数据一条数据上传
     */
    function files_form_save() {
        var files = fileArray;
        if (files != null && files.length > 0) {
            //判断文件是否更新完毕



            parent.openTransmitList();
            $.messager.confirm('系统提示', "请确认是否开始上传", function (r) {
                if (r) {
                    parent.clearDataAll();
                    parent.allUploadNumber = files.length;
                    parent.uploadNumber = 0;
                    parent.fileAllSize = fileAllSize;
                    parent.setUploadAllProgressLengrh();
                    parent.setUploadAllMessage("上传中");
                    parent.setFileAllSize();
                    parent.startTime();

                    var node = $('#resTree').tree('getSelected');
                    var patentNode = getParent(node);
                    var catalogNO = $('#files_catalogNO').val();
                    var catalogPath = $('#files_catalogPath').val();
                    $.messager.show({
                        title: '系统提示',
                        msg: '开始上传文件',
                        timeout: 1000,
                        showType: 'slide'
                    });

                    files_form_close();
                    parent.fileUploadFlag = false;
                    for (var i = 0; i < files.length; i++) {
                        //提交操作
                        parent.uploadFile(files[i], node, patentNode, catalogNO, catalogPath);
                    }

                    parent.setAllUpload();

                }
            })

        } else {
            $.messager.alert("系统提示", "请选择至少一条需要上传的数据");
        }

    }

    function files_form_close() {
        $('#files_form').form('clear');
        $('#files_Text').empty();
        $('#files').dialog('close');
    }

    /**
     * 获取表头
     */
    function getTabFieldInfo(){
        $.ajax({
            type:'post',
            url:'tabFieldInfo/queryAll.do',
            async:true,
            dataType:'json',
            data: {tabCode: "PDM_RES"},
            success:function(data){
                var result = returnMessager(data);
                if(result == null){
                    return;
                }
                var array = [];
                array.push({field:'cb', title:'', checkbox:'true', align:'center'});
                var resultList = result.result;
                if(resultList == null || resultList.length == 0){
                    return;
                }

                for(var i = 0;i<resultList.length;i++){
                    var item = resultList[i];
                    if(item.visible == '1'){
                        //可见
                        var fileld = {};
                        fileld.field = item.fieldCode;
                        fileld.title = item.fieldName;
                        fileld.width = '140px';
                        fileld.align = 'center';
                        array.push(fileld);
                    }
                }
                $('#filelist').datagrid({
                    columns: [array]
                });

            },
            error:function(){
                serverError();
            }
        });
    }




</script>
<script type="text/javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/upload/upload.js"></script>
<script type="text/javascript" src="js/validate.js"></script>
</body>
</html>
