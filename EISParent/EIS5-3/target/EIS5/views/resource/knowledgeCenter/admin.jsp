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
    <title>搜索界面</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script type="text/javascript" src="ui/jquery.min.js"></script>
    <script type="text/javascript" src="ui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="ui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script type="text/javascript" src = "/js/app.js"></script>
    <%--js/userManage.js--%>

    <script>


        //时间戳转日期格式
        function formatDate(time) {
            var format = 'yyyy-MM-dd HH:mm:ss';
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
<body class="easyui-layout">
<div  class="easyui-panel" title="检索日志" data-options="fit:true">
    <div id="toolbar">
        <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"
           onclick="UserManage.openUserDialog('ADD')">新增
        </a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true"
           onclick="UserManage.openUserDialog('EDIT')">编辑
        </a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true"
           onclick="UserManage.delUser()">删除
        </a>
        <span style="float: right">
            <input id="userNameParam" class="easyui-searchbox" data-options="prompt:'请输入',searcher:UserManage.doSearch" style="width: auto;padding-top: 5px"/>
        </span>
    </div>
    <table id="userTable" class="easyui-datagrid"
           toolbar="#toolbar" pagination="true"  fit="true" striped="true"
           rownumbers="true" fitColumns="true" singleSelect="false" >
        <thead>
        <tr>
            <th field="id" checkbox="true" align="center"></th>
            <th field="userName" width="50">用户姓名</th>
            <th field="userAccount" width="50">用户账号</th>
            <th field="sex" width="50" data-options="formatter:function(data){
                return data==1?'男':'女';
            }">性别</th>
            <th field="mobile" width="50">手机号</th>
            <th field="createTime" data-options="formatter:function(data){
                return formatDate(data);
            }" width="50">创建时间</th>
        </tr>
        </thead>
    </table>

    <div id="userDialog" class="easyui-dialog"  style="width:400px;height:300px;padding:10px"
         data-options="closed:true,iconCls: 'icon-save'">
        <form id="userForm" method="post">
            <div style="display:none">
                <input class="easyui-textbox" name="id" />
            </div>
            <div style="margin-bottom:10px">
                <input class="easyui-textbox" name="userName" style="width:340px"
                       data-options="missingMessage:'请输入',validType:'chinese',labelWidth:100,label:'用户名称:',required:true">
            </div>
            <div style="margin-bottom:10px">
                <input class="easyui-textbox" name="userAccount" style="width:340px"
                       data-options="missingMessage:'请输入',validType:'username',labelWidth:100,label:'用户账号:',required:true">
            </div>
            <div style="margin-bottom:10px">
                <select class="easyui-combobox" name="sex" style="width:340px;"
                        data-options="missingMessage:'请输入',labelWidth:100,label:'性别:',required:true">
                    <option value="1">男</option>
                    <option value="0">女</option>
                </select>
            </div>
            <div style="margin-bottom:10px">
                <input class="easyui-textbox"  name="mobile" style="width:340px;"
                       data-options="missingMessage:'请输入',labelWidth:100,validType:'mobile',label:'手机号:',required:true" >
            </div>
        </form>
        <div style="text-align:center;padding:5px 0">
            <a href="javascript:void(0)" class="easyui-linkbutton"
               onclick="UserManage.submitForm()" style="width:80px">提交
            </a>
            <a href="javascript:void(0)" class="easyui-linkbutton"
               onclick="javascript:$('#userDialog').dialog('close')" style="width:80px">取消
            </a>
        </div>
    </div>
</div>
</body>

</html>
