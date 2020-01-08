<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-17
  Time: 16:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String datagridId1 = "px_2";
%>

<html>
<head>
    <base href="<%=basePath%>">
    <title>资源账户</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/pxzn.util.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/easyui-language/easyui-lang-zh_CN.js"></script>
    <script>
        var datagridId1 = "<%=datagridId1%>";
        $(function(){
            setDatagridField(datagridId1,datagridList);
            $('#'+datagridId1).datagrid({
                url:'resourceCatalogUser/list',
                toolbar:'#resourceAcc_dg_toolbar'
            });
        });

        var datagridList = [  {id:"tNO",name:"编号"}
                            ,{id:"userName",name:"用户名称"}
                            ,{id:"userTNO",name:"用户流水号"}
                        ];

    /**
     * 资源账户
     */
        //新增打开
        function resourceAcc_dialog_open(){
            var messagerFlag = true;
            $.ajax({
                url:'resourceCatalogUser/notExistList?t='+new Date().getTime(),
                dataType:'JSON',
                type:'GET',
                success:function(data){
                    var oldSelect = document.getElementById('oldSelect');
                    oldSelect.innerHTML ="";
                    if(data.result.length > 0){
                        var datas = data.result;
                        for(var i=0;i<datas.length;i++){
                            selectAdd(oldSelect, datas[i].userName, datas[i].userTNO);
                        }
                    }
                },
                error:function(){

                }
            })

            $.ajax({
                url:'resourceCatalogUser/existList?t='+new Date().getTime(),
                dataType:'JSON',
                type:'GET',
                success:function(data){
                    var newSelect = document.getElementById('newSelect');
                    newSelect.innerHTML ="";
                    if(data.result.length > 0){
                        var datas = data.result;
                        for(var i=0;i<datas.length;i++){
                            selectAdd(newSelect, datas[i].userName, datas[i].userTNO);
                        }
                    }
                },
                error:function(){
                }
            })
            $('#resourceAcc_dialog').dialog('open');
        }

        //保存
        function resourceAcc_dialog_ok(){
            var select = document.getElementById('newSelect');
            var option = select.options;
            var result = [];
            for(var i=0;i<option.length;i++){
                result.push(option[i].value);
            }
            $.ajax({
                url:'resourceCatalogUser/save',
                dataType:'JSON',
                type:'POST',
                data:{
                    resUserList:JSON.stringify(result)
                },
                success:function(data){
                    var status = data.status;
                    if(status == messagerCode.success){
                        resourceAcc_dialog_close();
                        $('#'+datagridId1).datagrid('reload');
                        message_Show('保存成功');
                    }else{
                        $.messager.alert('系统提示',"保存失败");
                    }
                },
                error:function(){

                }
            })

        }

        //取消
        function resourceAcc_dialog_close(){
            $('#resourceAcc_dialog').dialog('close');
        }
    </script>

</head>
<body class="easyui-layout">
<div data-options="region:'center'">

    <div id="resourceAcc_dg_toolbar">
        <div class="datagrid-title-div"><span>资源列表</span></div>
        <img src="images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first" onclick="$('#'+datagridId1).datagrid('reload');"  title="刷新">
        <img src="images/px-icon/shezhi.png" class="easyui-tooltip div-toolbar-img-next" onclick="resourceAcc_dialog_open()"  title="账户设置">
    </div>
    <jsp:include page="/px-tool/px-datagrid.jsp">
        <jsp:param value="<%=datagridId1%>" name="div-id"/>
    </jsp:include>

    <%--新增--%>
    <div id="resourceAcc_dialog" class="easyui-dialog modal" data-options="modal:true,buttons:'#resourceAcc_dialog_button',closed:'true',title:'资源账户设置',resizable:true,maximizable:false" >
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
        <div id="resourceAcc_dialog_button" class="pxzn-dialog-buttons">
            <input type="button" onclick="resourceAcc_dialog_ok()" value="保存" class="pxzn-button">
            <input type="button" onclick="resourceAcc_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>

</div>
</body>
</html>
