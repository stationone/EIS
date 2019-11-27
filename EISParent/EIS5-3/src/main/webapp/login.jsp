<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-07-01
  Time: 11:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录界面</title>


    <link rel="stylesheet" type="text/css" href="css/easyui.css">
    <script type="text/javascript" src="js/jquery.min.js" ></script>
    <script type="text/javascript" src="js/jquery.easyui.min.1.5.2.js" ></script>
    <style>
        body{
            font-family: 微软雅黑;
        }
        p{
            margin: 0px;
            padding: 0px
        }
        i{
            line-height: 40px;
            color: #fff;

        }
        /*.userName{
            width: 330px;
            height: 38px;
            border: 1px solid #cbcccc ;
            background: #cbcccc;
            margin-top: 35px;
            text-align: center;
        }
        .userName input{
            width: 272px;
            height: 36px;
            border: 0px;
            float: right;
            padding-left: 10px;
            outline:none;
        }*/

        .input_button{
            background: #3AAFF5;
            width: 100px;
            height: 40px;
            margin-top: 30px;
            font-size: 14px;
            color: #fff;
            border:0px;
            padding:0px;
        }


        /*登录操作框*/
        ul{
            list-style-type: none;
            margin: 0px;
            padding: 0px;
        }

        .login-ul li{
            background: #CBCCCC;
        }
        .login-ul li i{
            line-height: 38px;
            margin: 0px 20px;
            position:absolute;
            color: #fff;
        }
        .login-ul li input{
            border: 1px solid #CBCCCC;
            outline: none;
            padding: 10px;
            width: 270px;
            line-height: 0px;
            margin-left: 55px;
        }
    </style>
    <script>
        /**
         *
         */
        var pageContext = $("#pageContext").val();

        /*
         *查询组装全局导航栏
         * 亮
         */
        function LoadPageNavigation(){

            var lis = "<li><a id='home' class='acolor'  href='mainPortal.jsp'  onclick='skipPage(this); return false'>首页</a></li>";

            //<li><a id="href_2"  href="view/searchManage.html"  onclick="skipPage(this); return false" >检索管理</a></li>
            $.ajax({
                type: "post",
                async: false,
                url: pageContext + "/modules/queryByCond.do",
                dataType: "json",
                success: function (data) {
                    $.each(data.modules,function(i,item){
                        lis +="<li><a id='"+item.moduleNO+"' href='"+item.moduleURL+"?id="+item.moduleNO+"' onclick='skipPage(this); return false' >"+item.moduleName+"</a></li>"
                    });
                }
            });
            $('#hometop').empty();
            $('#hometop').append(lis);

        }

        //打开窗口
        function openPwd() {
            $('#w').window({
                title: '修改密码',
                width: 400,
                modal: true,
                shadow: true,
                closed: true,
                height: 300,
                resizable:false
            });
            $('#w').window('open').window('center');
        }
        //关闭窗口
        function closePwd() {
            $('#w').window('close');
        }
        //修改密码
        function serverLogin() {
            var $newpass = $('#txtNewPass');
            var $rePass = $('#txtRePass');

            if ($newpass.val() == '') {
                msgShow('系统提示', '请输入密码！', 'warning');
                return false;
            }
            if ($rePass.val() == '') {
                msgShow('系统提示', '请再一次输入密码！', 'warning');
                return false;
            }
            if ($newpass.val() != $rePass.val()) {
                msgShow('系统提示', '两次密码不一致！请重新输入', 'warning');
                return false;
            }
            var url = pageContext + "/users/modifyPassword.do";
            $.post(url, {"userPassword": $newpass.val()}, function(result) {
                    if (result.success) {
                        //msgShow('系统提示', '恭喜，密码修改成功！<br/>您的新密码为：' + msg, 'info');
                        $.messager.alert("系统提示", "密码修改成功，下一次登录生效！", "info");
                        //closePwd();
                    } else {
                        $.messager.alert("系统提示", "密码修改失败!", "info");
                    }
                    $newpass.val('');
                    $rePass.val('');
                    closePwd();
                },
                "json"
            );
        }
        //注销登录
        function logout() {
            $.messager.confirm('系统提示', '您确定要退出本次登录吗?', function(r) {
                if (r) {
                    window.location.href = pageContext + "/users/logout.do";
                }
            });
        }
    </script>
</head>
<body style="background: url('images/login/banner.jpg') no-repeat fixed center; background-size: cover;margin: 0px;">
<div style="width: 100%; height: 60px; background:transparent;border-bottom: 1px solid #5e626c">
    <img src="images/login/logo.png" style="margin:10px 0px 0px 20px">

</div>

<div style="width: 384px;height: 310px;background: #fff;margin-left: 60% ;margin-top: 10%;padding-top: 28px;">
    <div style="position: absolute;margin-top: -100px;color: #fff">
        <p style="font-size: 25px">信息化系统</p>
        <p style="font-size: 12px;">Informatization System</p>
    </div>

    <form id="loginForm" method="post" name="loginForm" action="user/login.do" >
        <div style="background:transparent;width: auto;height: auto;margin: 0px 26px;">
            <p style="color: #333">用户登录</p>

            <div id="msg" style="color:red ;margin-top:5px;position: absolute;font-size:14px;"></div>

            <div style="width: 326px;margin-top: 40px;">
                <ul class="login-ul">
                    <li>
                        <i class="iconfont icon-gangweiguanli"></i>
                        <input id="userId" type="text" name="userId" placeholder="请输入用户名登录" />
                    </li>
                    <li style="margin-top: 20px;">
                        <i class="iconfont icon-shezhimima"></i>
                        <input id="userPassword" name="userPassword" type="password" placeholder="请输入登录密码"/
                    </li>
                </ul>
            </div>


            <input type="checkbox"  id="isRemember" checked="checked"  value="yes" style="width: 14px;height: 14px;margin: 0px;margin-top: 20px;font-size: 12px;" data-bind="checked:form.remember"/>
            <span style="font-size: 12px;position: relative;top: -3.5px;margin-left: 8px;"> 记住密码</span>




        </div>
        <input class="input_button" style="margin-left:47px" type="button" id="log" value="确定" onclick="logClick()"/>
        <input class="input_button" style="margin-left:90px" type="button" id="ret" value="取消" data-bind="click:resetClick" />
    </form>
</div>



<script type="text/javascript">
    $(function() {
        $("#userId").focus();
    });

    $(document).keyup(function(event){
        if(event.keyCode ==13){
            logClick();
        }
    });

    function logClick(){

        /**
         * 系统管理员 admin
         * xxx模块管理员
         * 一般员工 asd
         */
        var data = [{"userId":"admin","userPass":"admin","userName":"系统管理员","identify":"s"}
            ,{"userId":"module","userPass":"module","userName":"xxx模块管理员","identify":"m"}
            ,{"userId":"asd","userPass":"asd","userName":"一般员工","identify":"1"}
        ];

        var userId = document.getElementById("userId");
        var userPass = document.getElementById("userPassword");

        if(userId.value == "" ){
            document.getElementById("msg").innerHTML="用户名禁止为空";
            return;
        }else if(userPass.value == ""){
            document.getElementById("msg").innerHTML="密码禁止为空";
            return;
        }

        for(var i = 0;i<data.length;i++){
            if(userId.value == data[i].userId){
                if(userPass.value == data[i].userPass){
                    window.location.href="home.html?userName="+data[i].userName+"&type="+data[i].identify;
                    return;
                }else{
                    document.getElementById("msg").innerHTML="密码错误";
                    return;
                }
            }
        }
        document.getElementById("msg").innerHTML="用户名称错误";

    }
</script>
</body>
</html>
