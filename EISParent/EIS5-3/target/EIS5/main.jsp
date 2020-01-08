<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-10
  Time: 22:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.pdm.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>

    <style type="text/css">
        p{
            margin: 0px;
        }
        ul{

            padding-left: 0px;
            list-style-type:none;
            font-size: 14px;
            color: #98C3E7;
        }
        ul li{
            float: left;
            margin-left: 20px;

        }
        .homeright li,a{
            font-size:14px;
        }
        .acolor{
            color: #fff;
        }

        a{
            cursor:pointer;
        }
        li a{
            text-decoration: none;
            font-size: 14px;
            color: #98C3E7;
        }
        li a:hover{
            text-decoration: none;
            color:#fff;
            cursor: pointer;
        }

        .tabs{
            margin-left: 225px;
            color: #fff;
        }
        .tabs ul li a{
            color: #fff;
        }
        .tabs-inner{
            background: transparent;
            padding: 0px ;
            border: 0px;
        }


        /* easyui -liang */

        .panel-body{
            border:0px;
        }

        /*input 默认字体颜色*/
        input::-webkit-input-placeholder{

            color:#fff;
        }


        .main-top{
            width: 537px;

            background: #2A2E34;
            position: absolute;
            z-index: 99999999999999999999999999999999999;
            top: 1px;
            margin-left: -407px;
        }

        .main-top ul{
            margin:0px;
            margin-bottom: 6px;
        }
        .main-top ul li{
            line-height: 33px;
        }

        /**
         * 导航栏
         */

        /* 图标，正常背景状态 */
        .navigation_i{
            padding: 0px 8px;
            /*background: #027CDA;*/
            /*border-right: 1px solid #0071C1;*/
            float: right;
            margin-top: 15px;
            line-height: 30px;
        }

        /* 图标，鼠标移动上去状态 */
        .navigation_i_color{

            /*background: #2A2E34;*/
            /*border-right: 1px solid #2A2E34;*/

        }

    </style>

    <script type="text/javascript">
        //管理员级别
        var adminTitle =[{id:"1",name:"文档资源管理员",url:"resourceCenterAdmin",event:"skipPage(this)",order:1}
                        ,{id:"2",name:"文档资源普通用户",url:"resourceCenterUser",event:"skipPage(this)",order:2}
                        ,{id:"3",name:"账户中心",url:"accountCenter",event:"skipPage(this)",order:3}
                        ,{id:"4",name:"搜索",url:"search",event:"skipPage(this)",order:4}
                        ,{id:"5",name:"知识中心",url:"knowledgeCenter",event:"skipPage(this)",order:5}
                    ];
        // var adminTitle =[{id:"1",name:"文档资源中心管理员",url:"views/centerPage.jsp?type=s",event:"skipPage(this)",order:1}
        //     ,{id:"2",name:"文档资源中心普通用户",url:"views/centerPage.jsp?type=1",event:"skipPage(this)",order:2}
        //     ,{id:"3",name:"账户中心",url:"views/centerPage.jsp?type=a",event:"skipPage(this)",order:3}
        // ];
        $(function(){
            directoryBar(adminTitle);

            // document.getElementById("iframe_home").contentWindow.setWestTitle("你好");
            // $('').iframe[0].setWestTitle("你好");
        });




        /**
         * 设置密码
         */
        //打开
        function openPass(){
            $('#dialog_pass').dialog('open').dialog('center').dialog('setTitle','设置密码');
        }
        //保存
        function dialog_pass_ok(){
            $('#dialog_pass_form').form('submit', {
                url:"",
                onSubmit: function(){
                    var isValid = $(this).form('validate');
                    if (!isValid){
                        $.messager.alert('系统提示','验证不通过');
                    }
                    return isValid;
                },
                success: function(data){
                    $.messager.alert("系统提示",data.result);
                }
            });


        }
        //取消
        function dialog_pass_close(){
            $('#dialog_pass_form').form('clear');
            $('#dialog_pass').dialog('close');
        }

        //跳转页面
        function skipPage(data){
         var ref = data.getAttribute("ref");
            var title = '';
            var status = '';
           if("resourceCenterAdmin" === ref){
               //文档资源中心管理员
               title = '文档资源中心';
               status = 's';
           }else if("resourceCenterUser" === ref){
               //文档资源中心用户
               title = '文档资源中心';
               status = '1';
           }else if("accountCenter" === ref){
               //资源账户中心
               status = '2';
               title = '资源账户中心';
           }else if("search" === ref){
               //搜索
               status = '3';
               title = '搜索';
           }else if("knowledgeCenter" === ref){
               //搜索
               status = '4';
               title = '知识中心';
           }

            $("#iframe_home")[0].contentWindow.setWestTitle(title);
            $("#iframe_home")[0].contentWindow.setWestContent(status);
            $("#iframe_home")[0].contentWindow.layoutWestExpand();

            var skip_ul = null;
            // $('#iframe_home').attr('src',data.href);

            var ulli = data.parentNode.parentNode.childNodes;
            if(data.parentNode.parentNode.id === "hometop"){
                //点击的是第一列
                skip_ul = document.getElementById("hometop1");
            }else{
                //点击的是第二列
                skip_ul = document.getElementById("hometop");
            };

            for(var i = 0;i<ulli.length;i++){
                if(ulli[i].hasChildNodes()){

                    if(ulli[i].childNodes[0].id === data.id){

                        $('#'+data.id).attr('class','acolor');
                    }else{
                        $('#'+ulli[i].childNodes[0].id).attr('class','');
                    }
                }
            }
            if(skip_ul != null){
                skip_ul = skip_ul.childNodes;
                for(var i = 0;i<skip_ul.length;i++){
                    if(skip_ul[i].hasChildNodes()){
                        $('#'+skip_ul[i].childNodes[0].id).attr('class','');
                    }
                }
            }

        }

        //注销登录
        function logout() {
            $.messager.confirm('系统提示', '您确定要退出本次登录吗?', function(r) {
                if (r) {
                    window.location.href = "/pdm1/login.html";
                }
            });
        }

        /**
         * 导航栏多级菜单
         */
        var titi = 0;
        //鼠标移上
        function navigationMoveUp(){

            document.getElementById("mainPanle_icon").className="navigation_i_color navigation_i";
            document.getElementById("div_hometop1").style.display="block";

        }
        //鼠标移下
        function navigationRemove(){
            if(titi == 1){
                return;
            }
            document.getElementById("div_hometop1").style.display="none";
            document.getElementById("mainPanle_icon").className="navigation_i";
        }

        function zxczx(){
            titi = 1;
        }



        /**
         * 加载全局导航条
         *
         *传入的数据源
         *	[{"id":"1","name":"首页","url":"mainPortal.html","event":"skipPage(this)","order":1}
         *	,{"id":"7","name":"配置中心","url":"view/basicInformation.html","event":"skipPage(this)","order":7}
         *	,{"id":"3","name":"人力中心","url":"view/manpowerCenter.html","event":"skipPage(this)","order":3}
         *	,{"id":"10","name":"项目中心","url":"view/task.html","event":"skipPage(this)","order":10}]
         *拼装好的数据格式
         *	<ul id="hometop" style="float: left;">
         *		<li><a id="a" class="acolor" href="mainPortal.html"  onclick="skipPage(this); return false" >首页</a></li>
         *		<li><a id="hfd" href="view/systemManagement.html"  onclick="skipPage(this); return false" >账户中心</a></li>
         *		<li><a id="hrss" href="view/manpowerCenter.html"  onclick="skipPage(this); return false" >人力中心</a></li>
         *		<li><a id="s"  href="view/resourceCentre.html"  onclick="skipPage(this); return false" >知识库</a></li>
         *		<li><a id="hr"  href="view/productModelCenter.html"  onclick="skipPage(this); return false" >产品/模型中心</a></li>
         *	</ul>
         */
        function directoryBar(data){

            if(data.length != 0){
                var arrays = [];
                //获取排序将序号存入数组
                for(var i = 0;i<data.length;i++){
                    arrays[i] = data[i].order;
                }

                //排序得出全局导航条的先后显示顺序
                for(var j = 0;j < arrays.length ;j++){
                    for(var k = 0;k < arrays.length-1-j;k++){
                        if(arrays[k] > arrays[k+1]){
                            var h = arrays[k];
                            arrays[k] = arrays[k+1];
                            arrays[k+1] = h;
                        }
                    }
                }


                //第一列数据
                var titleUl_1 = "";

                //第二列数据
                var titleUl_2 = '<ul id="hometop1" style="float: left;">';

                /**
                 * 按照指定顺序输出导航条布局
                 * {id: "1", name: "首页", url: "mainPortal.html", event: "skipPage(this)", order: 1}
                 */
                for(var f = 0;f<arrays.length;f++){
                    for(var g = 0;g<data.length;g++){
                        if(arrays[f] === data[g].order){
                            if(f < 5){
                                //第一列
                                if(f < 1){
                                    //第一次打印数据增加默认颜色
                                    titleUl_1 += '<li><a id="'+data[g].id+'" class="acolor" ref="'+data[g].url+'"  onclick="'+data[g].event+'; return false" >'+data[g].name+'</a></li>';
                                }else{
                                    titleUl_1 += '<li><a id="'+data[g].id+'" ref="'+data[g].url+'"  onclick="'+data[g].event+'; return false" >'+data[g].name+'</a></li>';
                                }

                            }else{
                                //第二列
                                titleUl_2 += '<li><a id="'+data[g].id+'" href="'+data[g].url+"?userName="+getUrlParameter().userName+"&type="+getUrlParameter().type+'"  onclick="'+data[g].event+'; return false" >'+data[g].name+'</a></li>';
                            }
                        }
                    }
                }
                titleUl_2 += '</ul>'

                document.getElementById('hometop').innerHTML=titleUl_1;
                if(arrays.length > 5){
                    document.getElementById('div_hometop1').innerHTML=titleUl_2;
                }

            }

        }

    </script>
</head>
<body style="margin: 0px;min-width: 1024px; overflow-x:auto "  class="easyui-layout" >

<div  data-options="region:'north'" style="height: 50px;background: linear-gradient(#0167cb,#014488);"  >
    <div style="width: 226px;height: 50px;float: left;" onmouseenter="navigationRemove()">
        <ul>
            <li style="margin-left: 10px;"><img src="images/px-icon/logo.png" width="80px;"></li>
            <li style="margin-left: 5px"><div style="height: 18px;border-left: 1px solid #fff;color: #fff;margin-left: 5px;"/></li>
            <li style="margin-left: 5px;color: #fff;font-size: 18px"><span style="position: absolute;top: 10px;">信息化系统</span></li>
        </ul>
    </div>
    <div id="mainPanle_1" style="width: 537px;height: 50px;float: left;"  >
        <ul id="hometop" style="float: left;">
<%--            <li><a id="a" class="acolor" href="views/resource/user.jsp"  onclick="skipPage(this); return false" >普通用户资源中心</a></li>--%>
<%--            <li><a id="hfd" href="views/resource/admin.jsp"  onclick="skipPage(this); return false" >管理员资源中心</a></li>--%>
            <!--  <li><a id="hrss" href="view/manpowerCenter.html"  onclick="skipPage(this); return false" >人力中心</a></li>
              <li><a id="s"  href="view/resourceCentre.html"  onclick="skipPage(this); return false" >知识库</a></li>
              <li><a id="hr"  href="view/productModelCenter.html"  onclick="skipPage(this); return false" >产品/模型中心</a></li>-->

        </ul>
        <div id="mainPanle_icon" class="navigation_i">
            <img src="images/px-icon/menu.png" style="width:19px" onmouseenter="navigationMoveUp()">
<%--            <i class="iconfont icon-caidan" style="color: #fff;" onmouseenter="navigationMoveUp()"  ></i>--%>
        </div>

    </div>


    <!--<div  style="float: left;margin-top: 8px;">
        <table cellspacing="0">
            <tr>

                <td style="padding: 0px;"><input type="text"  style="color: #fff;outline:none;border: 0px;background:#027CDA;height: 30px;width: 200px;padding: 0px;padding-left: 10px;"  placeholder="请输入关键词搜索"/></td>
                <td style="padding: 0px 8px;background: #0782E4;"><i class="iconfont icon-sousuo" style="color: #fff;"></i></td>
            </tr>
        </table>

    </div>-->

    <ul class="homeright" style="float: right">

        <li class="acolor" ><i class="iconfont icon-yonghuming"></i></li>
        <li id="loginUserName" class="acolor" style="margin-left: 10px;">欢迎 系统管理员</li>
        <li style="margin-left:10px;"><div style="border-left: 1px solid #fff;height: 18px;"></div></li>
        <li style="margin-left: 10px"><a onclick="openPass()">修改密码</a></li>
        <li style="margin-right: 10px;"><a onclick="logout()">安全退出</a></li>


    </ul>

</div>

<div id="mainPanle_2" data-options="region:'center'">
    <div id="div_hometop1" class="main-top main-table" style="display: none;margin-left: 226px;width: 536px;height: 100px;border: 1px solid #D7D7D7;border-top:0;background: #fff " >
        <ul id="hometop1" style="float: left;">
            <li><a id="hrs" href="view/systemConfiguration.html"  onclick="skipPage(this); return false" >日志中心</a></li>
            <li><a id="b" href="view/basicInformation.html"  onclick="skipPage(this); return false" >配置中心</a></li>
            <li><a id="hrg" href="view/flowManagemet.html"  onclick="skipPage(this); return false" >流程信息管理</a></li>
            <li><a id="hrsd" href="view/task.html	"  onclick="skipPage(this); return false" >个人任务中心</a></li>
            <li><a id="hrssd" href="view/task.html	"  onclick="skipPage(this); return false" >项目中心</a></li>
        </ul>
    </div>
    <iframe id="iframe_home" src='views/centerPage.jsp' onmouseenter="navigationRemove()"  width=100%  height=100% scrolling="no" frameborder="0"></iframe>
<%--    <script>--%>
<%--        $(function(){--%>
<%--            $.ajax({--%>
<%--                url:'views/centerPage1.html',--%>
<%--                dataType:'html',--%>
<%--                type:'GET',--%>
<%--                success:function(data){--%>
<%--                    console.log("nihao ");--%>
<%--                    $('#centerPage_div').html(data);--%>
<%--                    // setOneNavigationBar(userAdminTitle);--%>

<%--                }--%>

<%--            })--%>
<%--        })--%>
<%--    </script>--%>
<%--    <div id="centerPage_div" class="easyui-layout" style="width: 100%;height: 100%;background: #cdcdcd">--%>
<%--&lt;%&ndash;        <jsp:include page="views/centerPage.html"/>&ndash;%&gt;--%>
<%--    </div>--%>
</div>

<!--修改密码窗口-->
<div id="dialog_pass" class="easyui-dialog model" title="修改密码" data-options="collapsible:false,minimizable:false,closed:true,maximizable:false,modal:true,buttons:'#dialog_pass_buttons'">
    <form id="dialog_pass_form" method="post" novalidate >
        <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 30px;" >
            <input id="pass_tNO" name="tNO" type="hidden">
            <tr>
                <td><span class="pxzn-span-three">新密码</span></td>
                <td>
                    <input id="pass_one" type="password" class="easyui-textbox pxzn-dialog-text" >
                </td>
            </tr>
            <tr>
                <td><span class="pxzn-span-four">确认密码</span></td>
                <td>
                    <input id="pass_two" name="userPassword" type="password" class="easyui-textbox pxzn-dialog-text">
                </td>
            </tr>

        </table>
    </form>

    <div id="dialog_pass_buttons" class="pxzn-dialog-buttons">
        <input type="button" onclick="dialog_pass_ok()" value="确认" class="pxzn-button">
        <input type="button" onclick="dialog_pass_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
    </div>




</div>
</div>

</body>
</html>

