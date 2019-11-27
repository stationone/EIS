<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-25
  Time: 16:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String dialog_id = request.getParameter("id");
    String width = request.getParameter("width");
    String height = request.getParameter("height");

    System.out.println("dialog_id:"+dialog_id);
    //设置默认值
    if(dialog_id == null){
        dialog_id = "";
    }
    if(width == null){
        width = "600px";
    }
    if(height == null){
        height = "400px";
    }
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>对话框</title>
    <link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <style>

    </style>
    <script>
        var dialogData = {
            columnNumber:2,
            center:[
                {id:'userNO',name:'userNO',type:'hidden',label:'流水号',attribute:{},easyuiAttribute:""}
               ,{id:'userIdSaveAndUpdate',name:'userId',type:'textbox',label:'登录名',attribute:{},easyuiAttribute:"validType:['general','length[1,20]'],required:true"}
               ,{id:'userNameSaveAndUpdate',name:'userName',type:'textbox',label:'用户名',attribute:{},easyuiAttribute:"validType:['account','length[1,10]'],required:true"}
               ,{id:'empNO',name:'empNO',type:'searchbox',label:'员工编号',attribute:{},easyuiAttribute:"editable:false,prompt:'请选择',searcher:empsDialog_open"}
            ]
        };


        function setDialog_form(dialog_Id, data){
            if(data != null){
                //内容
                var center = data.center;
                //列数
                var columnNumber = data.columnNumber;
                var htmlCenter = "";
                for(var i = 0;i<center.length;i++){
                    htmlCenter+="<tr>";

                }
            }
        }
    </script>

</head>
<body>
    <div id="<%=dialog_id%>" class="easyui-dialog" data-options="border:'thin',modal:true,closed:false,inline:false" style="min-width:<%=width%> ; height: <%=height%>">

        <form id="dialog_create_form" method="post"  novalidate >

            <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                <input id="userNO" name="userNO"  type="hidden" label="流水号" >
                <tr>
                    <td><span class="pxzn-span-three">登录名</span></td>
                    <td>
                        <input id="userIdSaveAndUpdate" name="userId" class="easyui-textbox pxzn-dialog-text" data-options="validType:['account','length[1,10]']" required="true">
                    </td>
                    <td><span class="pxzn-span-three pxzn-text-margin-left">用户名</span></td>
                    <td>
                        <input id="userNameSaveAndUpdate" name="userName" class="easyui-textbox pxzn-dialog-text" data-options="validType:['general','length[1,20]']" required="true" >
                    </td>
                </tr>

                <tr>
                    <td><span class="pxzn-span-four">员工编号</span></td>
                    <td>
                        <input id="empNO" name="empNO" class="easyui-searchbox pxzn-dialog-text"  data-options="editable:false,prompt:'请选择'">
                    </td>
                    <td><span class="pxzn-text-margin-left pxzn-span-four">登录密码</span></td>
                    <td>
                        <input id="UserPassword" name="userPassword" class="easyui-textbox pxzn-dialog-text" readonly="readonly"   >
                    </td>
                </tr>

                <tr>
                    <td><span class="pxzn-span-two">部</span>门</td>
                    <td>
                        <input id="Departname" name="DepartName" class="easyui-textbox pxzn-dialog-text" readonly="readonly"  >
                    </td>
                    <td><span class="pxzn-text-margin-left pxzn-span-four">角色选择</span></td>
                    <td>
                        <input id="roleName" name="roleName" class="easyui-searchbox pxzn-dialog-text" data-options="prompt:'请选择'">
                    </td>
                </tr>

                <tr>
                    <td><span class="pxzn-span-four">公司名称</span></td>
                    <td>
                        <input id="companyName" name="companyName" class="easyui-textbox pxzn-dialog-text"  data-options="validType:['space','companyName','length[0,30]']" title="如外部人员请输入公司名称，本公司无需输入">
                    </td>
                    <td><span class="pxzn-text-margin-left pxzn-span-four">用户类型</span></td>
                    <td>
                        <select  id= "dialog_userType" name="userType"  class="easyui-combobox pxzn-dialog-select" data-options="editable:false,panelHeight:'auto'">
                            <option value="">请选择</option>
                            <option value="0">临时</option>
                            <option value="1">正式</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="pxzn-span-three">有效性</span>
                    </td>
                    <td colspan="3">
                        <input type="hidden" id="create_status1" value="1" name="status">
                        <input type="checkbox" id="create_status" name="status" value="1" style="margin-left:-2px;" checked/>有效
                        <a style="color:#30b5ff;margin-left:10px"> 注：用户无效（禁用该用户）后，该用户将不能登录</a>
                    </td>

                    <script>
                        $(function(){
                            $('#create_status').click(function(){
                                console.log(this.checked);
                                if(this.checked){
                                    //选中
                                    $('#create_status1').val(1);
                                }else{
                                    $('#create_status1').val(0);
                                }
                            })
                        })
                    </script>
                </tr>
                <tr>
                    <td valign="top">
                        <span class="pxzn-span-two">说</span>明
                    </td>
                    <td colspan="3">
                        <input id="description" name="description"  multiline="true" class="easyui-textbox" data-options="multiline:true,validType:['space','length[0,450]']" style="width:518px;height:100px">
                    </td>
                </tr>

            </table>


        </form>
    </div>
</body>
</html>
