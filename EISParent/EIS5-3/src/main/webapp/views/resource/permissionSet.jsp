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
    <title>权限设置</title>
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

        var datagrid_field = [];

        $(function(){
            setDatagridField(datagridId1,datagrid_field);
            // setTreeValue(treeId, treeJson);
            $('#'+datagridId1).datagrid({
                url:'catalogUserLink/list',
                toolbar:'#permissionSet_dg_toolbar',
                columns:[[
                    {field:'cd',checkbox:true},
                    {field:'userName',title:'用户名',width:100},
                    {field:'rw',title:'权限',formatter:powerSet,width:100}
                ]],
                onLoadSuccess:function(data){
                    $.parser.parse('#'+datagridId1);
                }
            });

            $('#'+treeId).tree({
                url: 'catalog/listTree',
                onClick: function (node) {
                    $("#"+datagridId1).datagrid('load', {
                        catalogNO:node.id
                    });
                },
                checkbox: false,
                multiple: false
            });
        });


        /**
         *  设置权限
         * @param value
         * @param row
         * @param index
         */
        function powerSet(value,row,index){
            var tNO = row.tNO;
            var read = "";
            if(value == "R"){
                read = '<option value="R" selected="true" >只读</option>'
                    +'<option value="RW">读写</option>'
            }else if(value == "RW"){
                read = '<option value="R">只读</option>'
                    +'<option value="RW" selected="true">读写</option>'
            }else{
                read = '<option value="R">只读</option>'
                    +'<option value="RW">读写</option>'
                    +'<option value="P" selected="true">标志位</option>';
            }

            var result='<select  id="c_'+tNO+'" class="easyui-combobox" onchange="powerSet_save('+index+')" style="width:150px;border: 1px solid #cdcdcd;padding: 2px 0;">'
                + read
                +'</select>';

            return result;
        }

        /**
         * 权限修改保存
         * @param index
         */
        function powerSet_save(index){
            var rows = $('#'+datagridId1).datagrid('getRows');
            var row = rows[index];

            if(row != null){
                var node = $('#'+treeId).tree('getSelected');
                var attr = node.attributes;
                if(attr == null){
                    $.messager.alert("系统提示","异常，请重新刷新界面");
                    return;
                }

                var rw = $('#c_'+row.tNO).val();
                var userTNO = row.userId;
                console.log(attr);
                $.ajax({
                    url:'catalogUserLink/update',
                    dataType:'JSON',
                    type:'POST',
                    data:{
                        catalogNO:row.catalogNO,
                        svnURL:attr[0].svnURL,
                        permissions:rw,
                        userTNO:userTNO
                    },
                    success:function(data){
                        if(data.code == messagerCode.success ){
                           message_Show('修改成功');
                        }else{

                            message_Alert("修改失败");
                        }

                    },
                    error:function(data){
                    }
                })

            }


        }


        /**
     * 设置权限
     */
        //打开
        function userPowerSet_dialog_open(){
            var node = $('#'+treeId).tree('getSelected');
            if(node == null){
                $.messager.alert('系统提示','请选择目录');
                return;
            }
            if(node.id == "0"){
                //说明用户选择了版本仓库
                $.messager.alert('系统提示','此节点禁止设置用户权限');
                return;
            }
            var messagerFlag = true;
            //未选择
            $.ajax({
                url:'catalogUserLink/notExistList?t='+new Date().getTime(),
                dataType:'JSON',
                type:'GET',
                data:{
                    catalogNO:node.id
                },
                success:function(data){
                    var oldSelect = document.getElementById('oldSelect');
                    oldSelect.innerHTML ="";
                    if(data.rows.length > 0){
                        var datas = data.rows;
                        for(var i=0;i<datas.length;i++){
                            selectAdd(oldSelect, datas[i].userName, datas[i].userId);
                        }
                    }
                },
                error:function(){
                }
            });

            //已选择
            $.ajax({
                url:'catalogUserLink/existList?t='+new Date().getTime(),
                dataType:'JSON',
                type:'GET',
                data:{
                    catalogNO:node.id
                },
                success:function(data){
                    var newSelect = document.getElementById('newSelect');
                    newSelect.innerHTML ="";
                    if(data.rows.length > 0){
                        var datas = data.rows;
                        for(var i=0;i<datas.length;i++){
                            if(datas[i] != null) {
                                selectAdd(newSelect, datas[i].userName, datas[i].userId);
                            }
                        }
                    }
                },
                error:function(){
                    serverError();
                }
            });

            $('#userPowerSet_dialog').dialog('open');
        }

        //保存
        function userPowerSet_dialog_ok(){
            var select = document.getElementById('newSelect');
            var option = select.options;
            var result = [];
            for(var i=0;i<option.length;i++){
                result.push(option[i].value);
            }

            var node = $('#'+treeId).tree('getSelected');
            var attr = node.attributes;
            if(attr == null){
                $.messager.alert("系统提示","异常，请重新刷新界面");
                return;
            }
            $.ajax({
                url:'catalogUserLink/saves',
                dataType:'JSON',
                type:'POST',
                data:{
                    catalogNO:node.id,
                    svnURL:attr[0].svnURL,
                    users:JSON.stringify(result)
                },
                success:function(data){
                    var code = data.code;
                    if(code == messagerCode.success){
                        $('#'+datagridId1).datagrid('reload');
                        message_Show('保存成功');
                    }else{
                        $.messager.alert('系统提示','保存失败');
                    }
                    userPowerSet_dialog_close();
                },
                error:function(data){
                }
            })

        }

        //取消
        function userPowerSet_dialog_close(){
            $('#userPowerSet_dialog').dialog('close');
        }

    /**
     * 删除权限
     */
        function deletePower(){
            var node = $('#'+treeId).tree('getSelected');
            if(node == null){
                $.messager.alert('系统提示','请选择目录');
                return;
            }
            var rows = $('#'+datagridId1).datagrid('getSelections');
            if(rows == null || rows.length == 0){
                $.messager.alert('系统提示','请选择需要删除的数据');
                return;
            }
            var userTNOs = [];
            for(var i = 0;i<rows.length;i++){
                userTNOs.push(rows[i].userId);
            }

            $.ajax({
                url:'catalogUserLink/delete',
                dataType:'JSON',
                type:'POST',
                data:{
                    catalogNO:node.id,
                    userTNO:JSON.stringify(userTNOs)
                },
                success:function(data){
                    data = returnMessager(data);
                    if(data == null){
                        return;
                    }
                    var code = data.code;
                    if(code == messagerCode.success){
                        $('#'+datagridId1).datagrid('reload');
                        message_Show("删除成功");
                    }else{
                        $.messager.alert('系统提示','删除失败');
                    }
                },
                error:function(data){
                    serverError();
                }
            })
        }


    </script>
</head>
<body id="permissionSet_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div class="layout-title-div">
        资源目录
        <img src="images/px-icon/hide-left-black.png" onclick="layoutHide('permissionSet_layout','west')" class="layout-title-img">
    </div>

    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#'+treeId).tree('reload')" title="刷新">
        </div>
    </div>
    <jsp:include page="/px-tool/px-tree.jsp">
        <jsp:param value="<%=treeId%>" name="div-id"/>
    </jsp:include>

</div>

<div data-options="region:'center'">
<%--    <div style="width: 100%;background: #f4f4f4">--%>
<%--        <span style="line-height: 41px;margin-left: 9px;">用户权限</span>--%>
<%--    </div>--%>
    <div id="permissionSet_dg_toolbar">
        <div class="datagrid-title-div"><span>用户权限</span></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first" onclick="$('#'+datagridId1).datagrid('reload');"  title="刷新">
        <img src="images/px-icon/saveUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="userPowerSet_dialog_open()"  title="添加用户权限">
        <img src="images/px-icon/deleteUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="deletePower()"  title="删除用户权限">
    </div>
    <jsp:include page="/px-tool/px-datagrid.jsp">
        <jsp:param value="<%=datagridId1%>" name="div-id"/>
    </jsp:include>

    <%--新增权限--%>
    <div id="userPowerSet_dialog" class="easyui-dialog modal" buttons="#userPowerSet_dialog_button" modal="true" closed="true" title="目录权限设置" data-options="resizable:true,maximizable:false" >
        <div style="margin:30px 60px">
            <table>
                <tr>
                    <td>
                        <div style="text-align: center">
                            <span>未选择</span>
                        </div>
                        <select id="oldSelect" class="select" multiple='multiple' style="width: 150px;height: 250px">
                        </select>
                    </td>
                    <td>
                        <div style="width:auto;height: 50px;margin: 0 20px">
                            <button style="background: #F7F7F7;padding: 3px;border: 1px solid #e6e6e6;border-radius: 2px" onclick="leftButton()"><img style="width: 21px" src="images/px-icon/youjiantou.png"></button>
                        </div>
                        <div style="width:auto;height: 50px;margin: 20px 20px">
                            <button style="background: #F7F7F7;padding: 3px;border: 1px solid #e6e6e6;border-radius: 2px" onclick="rightButton()"><img style="width: 21px" src="images/px-icon/zuojiantou.png"></button>
                        </div>
                    </td>
                    <td>
                        <div style="text-align: center">
                            <span>已选择</span>
                        </div>
                        <select id="newSelect" class="select" multiple='multiple' style="width: 150px;height: 250px">

                        </select>
                    </td>
                </tr>
            </table>
        </div>

        <div id="userPowerSet_dialog_button-buttons" class="pxzn-dialog-buttons">
            <input type="button" onclick="userPowerSet_dialog_ok()" value="保存" class="pxzn-button">
            <input type="button" onclick="userPowerSet_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>

</div>
</body>
</html>
