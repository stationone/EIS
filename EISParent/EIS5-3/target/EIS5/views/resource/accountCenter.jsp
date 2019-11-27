<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-25
  Time: 9:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    String treeId = "treeId";
    String datagridId1 = "px_2";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>账户设置</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>
    <script>
        var treeId = "<%=treeId%>";
        var datagridId1 = '<%=datagridId1%>';
        var fields3 = [  {id:"userId",name:"登录名"}
            ,{id:"userName",name:"用户名"}
            ,{id:"companyName",name:"公司名称"}
            ,{id:"userType",name:"用户类型"}
            ,{id:"status",name:"状态"}
            ,{id:"description",name:"描述"}
        ];

        $(function(){
            setDatagridField(datagridId1, fields3);

            $('#'+treeId).tree({
                url: 'department/listTree',
                onClick: function (node) {
                    if(node.id == '2001'){
                        $('#'+datagridId1).datagrid('load',{});
                    }else{
                        $('#'+datagridId1).datagrid('load',{
                            companyName:node.text
                        });
                    }
                },
                checkbox: false,
                multiple: false,
                onExpand:function(node){
                    console.log(node);
                }
            });
        });

/**
 * 目录操作
 */

        //新建打开
        function newFolder(){

            var node = $('#'+treeId).tree('getSelected');
            if(node != null){
                if(node.id == '2001'){
                    message_Show('此节点禁止新建操作');
                    return;
                }
                $('#department_from').form('reset');
                $('#department_from').form('load',{
                    pDepartmentTNO:node.id
                });
                $('#department_dialog').dialog('open').dialog('setTitle','新建文件夹');
                return;
            }
            message_Show('请选择父节点');
        }

        //编辑打开
        function editFolder(){
            var node = $('#'+treeId).tree('getSelected');
            if(node != null){
                if(node.id == '2001' || node.id == '2002' || node.id == '2003'){
                    message_Show('禁止编辑');
                    return;
                }
                $('#department_from').form('reset');
                $('#department_from').form('load',{
                    tNO:node.id,
                    departmentName:node.text
                });
                $('#department_dialog').dialog('open').dialog('setTitle','编辑文件夹');
                return;
            }
            message_Show('请选择需要编辑的文件夹');
        }

        //保存
        function department_dialog_ok(){
            var url = "save";
            var tNO = $('#department_TNO').val();
            if(tNO !== ''){
                url = "update"
            };

            $('#department_from').form('submit',{
                url:'department/'+url,
                success:function(data){

                    result = JSON.parse(data);
                    if(result.code === messagerCode.success){
                        if(tNO !== ''){
                            //编辑
                            var node = $('#'+treeId).tree('getSelected');
                            $('#'+treeId).tree('update', {
                                target: node.target,
                                text: $('#department_Name').val()
                            });
                            message_Show('更新成功');
                        }else{
                            //新增
                            var node = $('#'+treeId).tree('getSelected');
                            $('#'+treeId).tree('append',{
                                parent:node.target,
                                data:[{
                                    id:result.tNO,
                                    text:$('#department_Name').val()
                                }]
                            });
                            message_Show('新建成功');
                        }

                        department_dialog_close();
                    }else if(result.code == '2003'){
                        $.messager.alert("系统提示","名称不可为空");
                    }else{
                        $.messager.alert("系统提示","新建失败");
                    }
                }
            })

        }

        //关闭
        function department_dialog_close(){
            $('#department_from').form('reset');
            $('#department_dialog').dialog('close');
        }

        /**
         * 删除目录
         */
        function deleteFolder(){
            var node = $('#'+treeId).tree('getSelected');
            if(node != null){
                if(node.id == '2001' || node.id == '2002' || node.id == '2003'){
                    message_Show('禁止删除');
                    return;
                }
                $.messager.confirm('系统提示', '请确认删除目录', function(r){
                    if (r){
                        //获取父级的编号
                        var nodeps = $('#'+treeId).tree('getParent',node.target);
                        $.ajax({
                            url:'department/delete?time='+new Date().getTime(),
                            type:'GET',
                            dataType:'JSON',
                            data:{
                                tNO:node.id,
                                pDepartmentTNO:nodeps.id
                            },
                            success:function(data){
                                var code = data.code;
                                if(code == messagerCode.success){
                                    message_Show("删除成功");
                                    $('#'+treeId).tree('remove',node.target);
                                }else{
                                    $.messager.alert("系统提示","删除失败")
                                }
                            }
                        })
                    }
                });
                return;
            }
            message_Show("请选择需要删除的数据");
        }



    </script>
</head>
<body id="accountCenter_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        组织机构
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('accountCenter_layout','west')" class="layout-title-img">
    </div>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#'+treeId).tree('reload')" title="刷新">
            <img src="images/px-icon/newFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
                 onclick="newFolder()" title="添加">
            <img src="images/px-icon/editFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
                 onclick="editFolder()" title="编辑">
            <img src="images/px-icon/deleteFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
                 onclick="deleteFolder()" title="删除">
        </div>
    </div>
    <jsp:include page="/px-tool/px-tree.jsp">
        <jsp:param value="<%=treeId%>" name="div-id"/>
    </jsp:include>
</div>
<div data-options="region:'center'">
    <div id="permissionSet_dg_toolbar">
        <div class="datagrid-title-div"><span>用户列表</span></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first" onclick="$('#'+datagridId1).datagrid('reload');"  title="刷新">
        <img src="images/px-icon/saveUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="createUserOpen()"  title="新建用户">
        <img src="images/px-icon/editUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="editUserOpen()"  title="编辑用户">
        <img src="images/px-icon/deleteUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="deleteUser()"  title="删除用户">
    </div>
    <jsp:include page="/px-tool/px-datagrid.jsp">
        <jsp:param value="<%=datagridId1%>" name="div-id"/>
        <jsp:param name="datagrid-toolbar" value="permissionSet_dg_toolbar"/>
    </jsp:include>

<%--    <jsp:include page="/px-tool/px-dialog-form.jsp"/>--%>
    <script>
        $(function(){
            $('#'+datagridId1).datagrid({
                url:'users/list',
                border:false
            })
        });

    /**
     * 创建用户
     */
        //打开
        function createUserOpen(){
            user_dialog_form_reset();
            $('#user_dialog_form').form('load',{
                userPassword:'111111'
            });
            $('#user_dialog').dialog('open').dialog('setTitle',"新建");
        }
        //编辑
        function editUserOpen(){
            user_dialog_form_reset();
            var rows = $('#'+datagridId1).datagrid('getSelections');
            if(rows.length !== 1){
                message_Show('请选择<span style="color:red">一条</span>需要编辑的用户数据');
                return;
            }
            if(rows[0].status === "1"){
                $('#create_status').attr('checked',true);
            }else{
                $('#create_status').attr('checked',false);
            }

            $('#create_userPassword').passwordbox('readonly', true)
            $('#create_userId').textbox('readonly',true);
            $('#user_dialog_form').form('load',rows[0]);
            $('#user_dialog').dialog('open').dialog('setTitle',"编辑");


        }
        //保存
        function  user_dialog_ok(){
            $('#user_dialog_form').form('submit',{
                url:'users/save',
                onSubmit:function(){
                    var status = $('#create_status').prop("checked");
                    if(status){
                        $('#create_status1').val("1");
                    }else{
                        $('#create_status1').val("0");
                    }
                   return $(this).form('validate');
                    // return false;
                },
                success:function(data){
                    var data = eval('(' + data + ')');
                    var tNO = $('#create_tNO').val();
                    if(data.code === messagerCode.success){
                        user_dialog_close();
                        if(tNO === ''){
                            message_Show('创建成功');
                        }else{
                            message_Show('更新成功');
                        }
                        $('#'+datagridId1).datagrid('reload');
                    }else if (data.code === messagerCode.nameRepetition) {
                        message_Show('登录名称重复');
                    }else{
                        if(tNO === '') {
                            $.messager.alert('创建失败');
                        }else{
                            $.messager.alert('更新失败');
                        }

                    }
                }
            });
        }
        //关闭
        function  user_dialog_close(){
            $('#user_dialog').dialog('close');
        }
        //表单重置
        function user_dialog_form_reset(){
            $('#create_userPassword').passwordbox('readonly', false);
            $('#create_userId').textbox('readonly', false);
            $('#user_dialog_form').form('reset');
        }

        //删除
        function deleteUser(){
            var rows = $('#'+datagridId1).datagrid('getSelections');
            if(rows.length === 0){
                message_Show('请选择需要删除的用户');
                return;
            }
            var json = [];

            for(var i = 0;i< rows.length;i++){
                json.push(rows[i].tNO);
            }

            $.ajax({
                url:'users/delete',
                type:'POST',
                dataType:'JSON',
                data:{
                    tNO:JSON.stringify(json)
                },
                success:function(data){
                    if(data.code === messagerCode.success){
                        message_Show('删除成功');
                        $('#'+datagridId1).datagrid('reload');
                    }else{
                        $.messager.alert('系统提示','删除失败');

                    }
                }
            })

        }

    </script>

    <div id="user_dialog" class="easyui-dialog" data-options="border:'thin',modal:true,closed:true,buttons:'#user_dialog_buttons'" style="min-width:600px ;">

        <form id="user_dialog_form" method="post"  novalidate >

            <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                <input id="create_tNO" name="tNO"  type="hidden">
                <tr>
                    <td><span class="pxzn-span-three">登录名</span></td>
                    <td>
                        <input id="create_userId" name="userId" class="easyui-textbox pxzn-dialog-text" data-options="validType:['account','length[1,10]']" required="true">
                    </td>
                    <td><span class="pxzn-span-three pxzn-text-margin-left">用户名</span></td>
                    <td>
                        <input name="userName" class="easyui-textbox pxzn-dialog-text" data-options="validType:['general','length[1,20]']" required="true" >
                    </td>
                </tr>

                <tr>
                    <td><span class="pxzn-span-four">公司名称</span></td>
                    <td>
                        <input name="companyName" class="easyui-textbox pxzn-dialog-text"  data-options="validType:['space','companyName','length[0,30]']" title="如外部人员请输入公司名称，本公司无需输入">
                    </td>
                    <td><span class="pxzn-text-margin-left pxzn-span-four">登录密码</span></td>
                    <td>
                        <input id="create_userPassword" name="userPassword" class="easyui-passwordbox pxzn-dialog-text"  >
                    </td>
                </tr>

                <tr>

                    <td><span class=" pxzn-span-four">用户类型</span></td>
                    <td colspan="3">
                        <select name="userType"  class="easyui-combobox pxzn-dialog-select" data-options="editable:false,panelHeight:'auto'">
                            <option value="1">正式</option>
                            <option value="0">临时</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="pxzn-span-three">有效性</span>
                    </td>
                    <td colspan="3">
                        <input type="hidden" id="create_status1" value="1" name="status">
                        <input type="checkbox" id="create_status" value="1" style="margin-left:-2px;" checked/>有效
                        <a style="color:#30b5ff;margin-left:10px"> 注：用户无效（禁用该用户）后，该用户将不能登录</a>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <span class="pxzn-span-two">说</span>明
                    </td>
                    <td colspan="3">
                        <input name="description" class="easyui-textbox" data-options="multiline:true,validType:['space','length[0,450]']" style="width:518px;height:100px">
                    </td>
                </tr>

            </table>
        </form>

        <div id="user_dialog_buttons" class="pxzn-dialog-buttons">
            <input type="button" onclick="user_dialog_ok()" value="保存" class="pxzn-button">
            <input type="button" onclick="user_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>

    <%--部门--%>
    <div id="department_dialog" class="easyui-dialog" style="" data-options="border:'thin',closed:true, modal:true,buttons:'#department_dialog_button'">
        <form id="department_from" method="post">
            <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                <input id="department_TNO" name="tNO" type="hidden">
                <input name="pDepartmentTNO" type="hidden">
                <tr>
                    <td><span class="pxzn-span-three">名称</span></td>
                    <td>
                        <input id="department_Name" name="departmentName" class="easyui-textbox pxzn-dialog-text" data-options="validType:['fileOrCata','length[1,20]']" >
                    </td>
                </tr>
            </table>
        </form>
        <div id="department_dialog_button" class="pxzn-dialog-buttons">
            <input type="button" onclick="department_dialog_ok()" value="保存" class="pxzn-button">
            <input type="button" onclick="department_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>

</div>

</body>
</html>
