<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-07-01
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>目录</title>
    <link rel="stylesheet" type="text/css" href="../../css/easyui.css">
    <link rel="stylesheet" type="text/css" href="../../css/px-style.css">
    <script src="../../js/jquery.min.js"></script>
    <script src="../../js/jquery.easyui.min.1.5.2.js"></script>
    <script src="../../js/px-tool/px-util.js"></script>
    <script src="../../js/pxzn.easyui.util.js"></script>
    <script>
        /**
         * 创建作业
         */
        //打开
        function createJobOpen(){
            $('#job_dialog_form').form('clear');
            $('#job_dialog').dialog('open').dialog('setTitle','创建作业');
        }
        //保存
        function job_dialog_ok(){
            message_Show("开始发布作业")
            job_dialog_close();
        }
        //取消
        function job_dialog_close(){
            $('#job_dialog_form').form('clear');
            $('#job_dialog').dialog('close');
        }
        //编辑作业
        function editJobOpen(){

            $('#job_dialog_form').form('load');
            $('#job_dialog').dialog('open').dialog('setTitle','编辑作业');
        }

    </script>
</head>
<body id="jobManagement_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
    <div id="mojao" class="layout-title-div">
        专业
        <img src="../../images/px-icon/hide-left-black.png" onclick="layoutHide('jobManagement_layout','west')" class="layout-title-img">
    </div>
    <div style="margin:5px 0;border-bottom:1px ">
        <div id="toolbar1">
            <img src="../../images/px-icon/shuaxin.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-first"
                 onclick="$('#'+treeId).tree('reload')" title="刷新">
            <img src="../../images/px-icon/newFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
                 onclick="newFolder()" title="添加">
            <img src="../../images/px-icon/editFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
                 onclick="editFolder()" title="编辑">
            <img src="../../images/px-icon/deleteFolder.png" style="padding:0 10px" class="easyui-tooltip div-toolbar-img-next"
                 onclick="deleteFolder()" title="删除">
        </div>
    </div>
    <ul id="tt" class="easyui-tree">
        <li>
            <span>学院分类</span>
            <ul>
                <li>
                    <span>飞行学院</span>
                    <ul>
                        <li><span>无人驾驶航空器系统工程</span></li>
                        <li><span>飞行技术</span></li>
                    </ul>
                </li>
                <li>
                    <span>电子信息工程学院</span>
                    <ul>
                        <li><span>电子信息工程</span></li>
                        <li><span>通信工程</span></li>
                        <li><span>电子科学与技术</span></li>
                        <li><span>集成电路设计与集成系统</span></li>
                        <li><span>光电信息科学与工程</span></li>
                        <li><span>电磁场与无线技术</span></li>
                        <li><span>交通运输</span></li>
                    </ul>
                </li>
                <li>
                    <span>微电子学院</span>
                    <ul>
                        <li><span>微电子科学与工程</span></li>
                    </ul>
                </li>
                <li>
                    <span>计算机学院</span>
                    <ul>
                        <li><span>计算机科学与技术</span></li>
                        <li><span>人工智能</span></li>
                    </ul>
                </li>
            </ul>
        </li>
    </ul>

</div>
<div data-options="region:'center'">
    <div id="permissionSet_dg_toolbar">
        <div class="datagrid-title-div"><span>作业列表</span></div>
        <img src="../../images/px-icon/shuaxin.png" class="easyui-tooltip div-toolbar-img-first" onclick=""  title="刷新">
        <img src="../../images/px-icon/saveUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="createJobOpen()"  title="创建作业">
        <img src="../../images/px-icon/editUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="editJobOpen()"  title="编辑作业">
        <img src="../../images/px-icon/deleteUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="deleteUser()"  title="删除作业">
        <img src="../../images/px-icon/deleteUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="deleteUser()"  title="上传作业">
        <img src="../../images/px-icon/deleteUser.png" class="easyui-tooltip div-toolbar-img-next" onclick="deleteUser()"  title="评分">
    </div>
    <table class="easyui-datagrid" data-options="fitColumns:true,pagination:true,fit:true,toolbar:'#permissionSet_dg_toolbar'">
        <thead>
            <tr>
                <th data-options="field:'status',width:20">编号</th>
                <th data-options="field:'name',width:50">作业名称</th>
                <th data-options="field:'inputUser',width:50">发布人</th>
                <th data-options="field:'inputDate',width:50">发布时间</th>
                <th data-options="field:'endDate',width:50">截止时间</th>
                <th data-options="field:'shouldSubmitNumber',width:50">应提交人数</th>
                <th data-options="field:'alreadySubmitNumber',width:50">已提交人数</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>001</td><td>作业一</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>10</td>
            </tr>
            <tr>
                <td>002</td><td>作业二</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>2</td>
            </tr>
            <tr>
                <td>003</td><td>作业三</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>5</td>
            </tr>
            <tr>
                <td>004</td><td>作业四</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>7</td>
            </tr>
            <tr>
                <td>005</td><td>作业五</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>50</td>
            </tr>
            <tr>
                <td>006</td><td>作业六</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>12</td>
            </tr>
            <tr>
                <td>007</td><td>作业七</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>9</td>
            </tr>
            <tr>
                <td>008</td><td>作业八</td><td>张老师</td><td>2019/5/5</td><td>2019/8/9 23:59:59</td><td>50</td><td>10</td>
            </tr>

        </tbody>
    </table>
</div>

<%--创建作业--%>
    <div id="job_dialog" class="easyui-dialog" data-options="border:'thin',modal:true,closed:false,buttons:'#job_dialog_buttons'">

        <form id="job_dialog_form" method="post"  novalidate >

            <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                <input id="create_tNO" name="tNO"  type="hidden">
                <tr>
                    <td><span class="pxzn-span-four">作业名称</span></td>
                    <td>
                        <input id="create_userId" name="userId" class="easyui-textbox pxzn-dialog-text" data-options="validType:['account','length[1,10]']" required="true">
                    </td>
                </tr>
                <tr>
                    <td><span class=" pxzn-span-four">作业类型</span></td>
                    <td>
                        <select name="userType"  class="easyui-combobox pxzn-dialog-select" data-options="editable:false,panelHeight:'auto'">
                            <option value="1">需要上传</option>
                            <option value="0">只读作业</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><span class="pxzn-span-four">提交次数</span></td>
                    <td>
                        <input id="submitNumber" name="userId" class="easyui-textbox pxzn-dialog-text" data-options="validType:['account','length[1,10]']" required="true">
                    </td>
                </tr>
                <tr>
                    <td><span class=" pxzn-span-four">提交人数</span></td>
                    <td>
                        <input id="submit" name="userId" class="easyui-textbox pxzn-dialog-text" data-options="validType:['account','length[1,10]']" required="true">
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <span class="pxzn-span-two">说</span>明
                    </td>
                    <td>
                        <input name="description" class="easyui-textbox pxzn-dialog-text" data-options="multiline:true,validType:['space','length[0,450]']" style="height:100px">
                    </td>
                </tr>

            </table>
        </form>

        <div id="user_dialog_buttons" class="pxzn-dialog-buttons">
            <input type="button" onclick="job_dialog_ok()" value="保存" class="pxzn-button">
            <input type="button" onclick="job_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
        </div>
    </div>


</body>
</html>
