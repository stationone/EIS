<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-22
  Time: 18:34
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
    <title>用户界面</title>
    <link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
    <link rel="stylesheet" type="text/css" href="css/px-style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery.easyui.min.1.5.2.js"></script>
    <script src="js/px-tool/px-util.js"></script>
    <script src="js/pxzn.pdm.js"></script>
    <script src="js/pxzn.easyui.util.js"></script>

    <style type="text/css">

        .mainlable_img{
            width: 14px;
            position: absolute;
            margin-top: 14px;
        }
        ul {
            margin: 0px ;
            list-style-type: none;
            padding: 0px;
            padding: 0px 0px 0px 5px;
        }
        /* ul li{
            margin-top: 10px;

        } */

        .mainlable_div{
            padding-left:11px;

        }

        .mainlable_div_div2{
            background: #0265ca;
            width: 3px;
            height: 40px;
            float: right;
        }


        .font_margin{
            line-height: 40px;
            margin-left: 24px;
        }
        .catalogue_left ul li div{

            cursor: pointer;

        }

        .catalogue_left ul li div:hover{
            background:#f5f5f5;
            color:#333;
            border-right: 3px solid #0265ca;
        }

        .catalogue_left ul li div:hover img{
            background: url("images/px-icon/resourceMaintain-dark.png")no-repeat;
        }



        .mainlablecolor{
            /* background: #E0ECFF;
            border: 1px dashed #95B8E7; */
            background:#f5f5f5;
            color:#333;
            border-right: 3px solid #0265ca;
        }


        a{
            text-decoration: none;
            color: #dadada;
        }

        #div_menu ul{

            text-align: left;
            margin: 0px;
            padding: 0px;
            border: 1px solid #9F9F9F;
            margin-top: 5px;
            font-size: 12px;
            background: #fff;
            display: none;

        }
        #div_menu ul li{
            padding: 6px 0px 6px 10px;
            margin: 0px;

        }
        #div_menu ul li:hover{
            background: #EBEBED;
            cursor: pointer;

        }
        #div_menu ul li a{
            margin-left: 10px;
        }
        #div_menu ul li i{
            color: #053968;
        }



        /* easyui css */
        .panel-header,
        .panel-body {

            border:0px;/* L */
        }

        .layout-split-west{
            border:0px;
        }

    </style>

    <script>

        //知识中心
        var knowledgeTitle = [{"moduleNO":"14","moduleName":"文档管理","moduleURL":"views/resource/knowledgeCenter.jsp","icon":"resourceMaintain-light.png","event":"","order":3}
            ,{"moduleNO":"15","moduleName":"文档基础属性","moduleURL":"views/resource/admin.jsp","icon":"","event":"","order":1}
            ,{"moduleNO":"16","moduleName":"类型定义","moduleURL":"views/resource/baseField.jsp","icon":"resourceMaintain-light.png","event":"","order":2}

            ,{"moduleNO":"17","moduleName":"全文检索","moduleURL":"views/resource/indexCreate.jsp","icon":"resourceMaintain-light.png","event":"","order":4}
            ,{"moduleNO":"18","moduleName":"我的收藏","moduleURL":"views/resource/documentCreate.jsp","icon":"resourceMaintain-light.png","event":"","order":5}
        ];

        //搜索
        var searchTitle = [{"moduleNO":"13","moduleName":"搜索","moduleURL":"views/resource/search.jsp","icon":"resourceMaintain-light.png","event":"","order":4}
            // ,{"moduleNO":"4","moduleName":"账户设置","moduleURL":"views/resource/admin.jsp","icon":"","event":"","order":6}
            ,{"moduleNO":"12","moduleName":"基础字段库","moduleURL":"views/resource/baseField.jsp","icon":"resourceMaintain-light.png","event":"","order":1}

            ,{"moduleNO":"10","moduleName":"索引库创建","moduleURL":"views/resource/indexCreate.jsp","icon":"resourceMaintain-light.png","event":"","order":2}
            ,{"moduleNO":"11","moduleName":"Document创建","moduleURL":"views/resource/documentCreate.jsp","icon":"resourceMaintain-light.png","event":"","order":3}
        ];

        //管理员级别
        var userAdminTitle = [{"moduleNO":"1","moduleName":"资源维护","moduleURL":"views/resource/admin.jsp","icon":"resourceMaintain-light.png","event":"","order":3}
            ,{"moduleNO":"2","moduleName":"资源账户","moduleURL":"views/resource/resourceAccount.jsp","icon":"resourceMaintain-light.png","event":"","order":1}
            ,{"moduleNO":"3","moduleName":"权限设置","moduleURL":"views/resource/permissionSet.jsp","icon":"resourceMaintain-light.png","event":"","order":2}
            // ,{"moduleNO":"4","moduleName":"账户设置","moduleURL":"views/resource/admin.jsp","icon":"","event":"","order":6}
        ];

        //管理员级别
        var userAdminTitleA = [{"moduleNO":"4","moduleName":"账户管理","moduleURL":"views/resource/accountCenter.jsp","icon":"","event":"","order":3}
            ,{"moduleNO":"6","moduleName":"作业管理","moduleURL":"views/resource/jobManagement.jsp","icon":"","event":"","order":1}
            ,{"moduleNO":"7","moduleName":"飞机总体概念设计","moduleURL":"views/resource/overallConceptualDesign.jsp","icon":"","event":"","order":2}
            // ,{"moduleNO":"4","moduleName":"账户设置","moduleURL":"views/resource/admin.jsp","icon":"","event":"","order":6}
        ];

        //普通用户级别
        var userTitle = [{"moduleNO":"5","moduleName":"资源维护","moduleURL":"views/resource/user.jsp","icon":"","event":"","order":1}
            ,{"moduleNO":"9","moduleName":"传输进度","moduleURL":"views/resource/transferList.jsp","icon":"","event":"","order":2}
            // ,{"moduleNO":"3","moduleName":"模块菜单管理","moduleURL":"systemManagement/moduleManagement.html","icon":"","event":"","order":3}
            // ,{"moduleNO":"4","moduleName":"模块操作管理","moduleURL":"systemManagement/functionManagement.html","icon":"","event":"","order":6}
        ];

        // $(function(){
        //
        //     $('#mainlable').empty();
        //     setOneNavigationBar(userAdminTitle);
        //     //从地址栏获取用户级别
        //     var type = getUrlParameter().type;
        //     // 清空左侧目录
        //
        //     if(type != null){
        //         if(type === "s"){
        //             setOneNavigationBar(userAdminTitle);
        //         }else if(type === "1"){
        //             setOneNavigationBar(userTitle);
        //         }else{
        //             setOneNavigationBar(userAdminTitleA);
        //         }
        //     }else{
        //         setOneNavigationBar(userAdminTitle);
        //     }
        //
        // });

        /**
         * 设置西区内容
         */
        function setWestContent(data){
            if(data === "s"){
                setOneNavigationBar(userAdminTitle);
            }else if(data === "1"){
                setOneNavigationBar(userTitle);
            }else if(data === "2"){
                setOneNavigationBar(userAdminTitleA);
            }else if(data === "3"){
                setOneNavigationBar(searchTitle);
            }else if(data === "4"){
                setOneNavigationBar(knowledgeTitle);
            }
        }


        /**
         * 设置西区标题
         */
        function setWestTitle(newTitle){
            $('#catalogue_left_title').html(newTitle);
        }


        /**
         * 西区展开
         */
        function layoutWestExpand(){
            $('#centerPage').layout('expand', 'west');
        }


    </script>
</head>
<body id="centerPage" class="easyui-layout">
    <div class="catalogue_left" data-options="region:'west',split:true" style="width:160px;background:#2b2e35">
        <div style="color:#fff;;padding-left:10px;line-height:40px;">
            <span id="catalogue_left_title">中心</span>
            <img src="images/px-icon/hide-left-white.png" onclick="layoutHide('centerPage', 'west')" style="width: 12px;float: right;margin-top: 15px;margin-right: 10px;">
        </div>
        <div style="border-bottom:1px solid #565656;width:216px;float:right;"></div>
        <div style="clear: both;"></div>
        <ul id="mainlable" style="padding:0px;">
<%--            <li><a href="" onclick="editIframe(this);return false"><div id="1" onclick="editColor(this)" class="mainlablecolor"><i class="iconfont "></i><span class="font_margin">资源维护</span></div></a></li>--%>
<%--            <li><a href="systemManagement/userManagement.html" onclick="editIframe(this);return false"><div id="1" onclick="editColor(this)" class="mainlableborder"><i class="iconfont "></i><span class="font_margin">资源用户</span></div></a></li>--%>
<%--            <li><a href="systemManagement/userManagement.html" onclick="editIframe(this);return false"><div id="1" onclick="editColor(this)" class="mainlableborder"><i class="iconfont "></i><span class="font_margin">权限配置</span></div></a></li>--%>
<%--            <li><a href="systemManagement/userManagement.html" onclick="editIframe(this);return false"><div id="1" onclick="editColor(this)" class="mainlableborder"><i class="iconfont "></i><span class="font_margin">属性扩展</span></div></a></li>--%>
        </ul>


    </div>


    <div id="iframe_centerPage" data-options="region:'center'" class="layoutoverflow">
        <iframe id="iframe_9" style="display: none" src="views/resource/transferList.jsp" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
    </div>


<script>
    /**
     * 一级导航点击后跳转操作
     * @param {Object} data
     */
    function editIframe(data){
         var childNodes = data.childNodes;
        if(childNodes != null){
        	for(var i = 0;i<childNodes.length;i++){
        		var childNode = childNodes[i];
        		if(childNode.nodeName === "DIV"){
                    var iframec = document.getElementById("iframe_"+childNode.id);
        		    if(iframec == null){
        		        var iframeText =  '<iframe id="iframe_'+childNode.id+'" src="'+data.href+'" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>';
        		       $('#iframe_centerPage').append(iframeText);
                    }
        		    //隐藏其他的界面
                    var centerPages = document.getElementById("iframe_centerPage");
                    var childNodes1 = centerPages.childNodes;
                    if(childNodes1 != null){
                    	for(var j = 0;j<childNodes1.length;j++){
                    		var cn = childNodes1[j];
                    		if(cn.nodeName === "IFRAME"){
                    			if(cn.id != "iframe_"+childNode.id){
                    			    $('#'+cn.id).hide();
                    			}else{
                                    $('#'+cn.id).show();
                                }
                            }
                    	}
                    }

        		}
        	}
        }


    }


/**
 * 上传文件操作
 */

        //上传文件的详细记录
    var allUpload = [];

    //需要上传的文件全部数量
    var allFileUploadTotal = 0;

    //已上传文件的数量
    var fileUpliadTotal = 0;

    //上传前初始化(清空)
    function uploadClear(){
        fileUpliadTotal = 0;
        allFileUploadTotal = 0;
        allUpload = [];
        commitNumber = 0;
        commitFile = [];
    }

    var tranIframe = null;
    function initIframeObject(){
        tranIframe = $("#iframe_9")[0].contentWindow;
    }

    /**
     * 用于保存现在上传的数据有哪些，以及上传的状态
     *
     * id : 上传文件的id号（在浏览器随机生成的编号）
     * name : 这是上传文件的名称，带后缀
     * message : 上传完成后的数据库提示信息
     * code : 1、代表上传完成；2、代表上传失败；3、代表上传成功，正在进行版本控制；4、未上传; 5、代表版本控制结束；
     * size : 这是文件的大小
     *
     * [{"id":"najs","name":"上传文件的名称","message":"上传完成","code":"1","size":"5000"}]
     *
     * 目前存在问题，当用户点击提交文件后，不得刷新浏览器，否则会导致请求丢失，发生异常；
     */
    function uploadFile(files, node, parentNode, catalogNO, catalogPath){
        var attr = node.attributes;
        var reNa = "";
        if(attr != null){
            var repositoryName = attr[0].svnURL;
            reNa = repositoryName.split("/");
            repositoryName = reNa[0];
        }
        var randomIds = randomId("f_");

        var form = new FormData(),
            url = 'userResourceUpload/uploadFile.do',
            file = files;
        form.append('file',file);
        form.append("tNO",randomIds);
        form.append("catalogPath",catalogPath);
        form.append("catalogNO",catalogNO);
        form.append("fileSize",files.size);
        form.append("repositoryName",reNa[0])
        form.append("userRepositoryName",parentNode.text);

        var xhr = new XMLHttpRequest();
        xhr.open("post", url, true);

        var uploadfileJson = {};
        uploadfileJson.id = randomIds;
        uploadfileJson.name = files.name;
        uploadfileJson.code = 4;
        uploadfileJson.message = "开始上传";
        uploadfileJson.size = files.size;

        allUpload.push(uploadfileJson);

        if(tranIframe == null){
            initIframeObject();
        }


        //上传进度事件
        xhr.upload.addEventListener("progress", function(event) {

            if (event.lengthComputable) {
                //上传进度
                var percent = (event.loaded / event.total * 100).toFixed(0);
                //上传速率
                // var noFileAllSize1 = noFileAllSize + (event.total - event.loaded);

                // console.log("总大小:"+event.total+"     未上传大小："+(event.total-event.loaded)+"  本次上传大小："+(noFileAllSize1-noFileAllSize));
                // noFileAllSize = noFileAllSize1;

                //实时刷新进度操作
                var upObject = tranIframe.document.getElementById("pg_"+uploadfileJson.id);
                if(upObject == null){
                    console.log("这是准备在界面显示数据");
                    tranIframe.setUploadProgressPage(allUpload);
                }

                tranIframe.$('#pg_'+uploadfileJson.id).progressbar('setValue', percent);

                //随机数
                if(percent == 100){
                    // console.error("上传完成,后台开始解析");
                    tranIframe.document.getElementById(uploadfileJson.id+'message').innerText="文件已提交至服务器，后台正在解析";
                }else{

                }


            }
        }, false);

        // xhr.upload.addEventListener("loadend",function(event){});

        xhr.onload = function(data) {
            if (xhr.readyState === 4 && xhr.status === 200) {
                fileUpliadTotal++;
                tranIframe.document.getElementById(uploadfileJson.id+'message').innerText="文件成功上传至服务器";
                if(fileUpliadTotal === allFileUploadTotal){
                    message_Show('上传完毕，开始进行版本控制');
                    synchronizationSVN_open();
                }

            }else{
                // if(submitErrorFlag){
                //     return;
                // }
                // uploadNumber++;
                // submitErrorFlag = true;
                // stopTime();
                // serverError();
                // fileUploadFlag = true;
                $.messager.alert('系统提示','上传失败');
            }
        }

        //加载到上传进度条显示框
        //保存到 addUpload json数据中
        //二次上传时，有可能第一次的任务没有完成，所以需要先检查addUpload的数据是否完成

        xhr.send(form);
    }

    /**
     * 提交控制
     * 同步svn
     */
    var synchronizationSVN_flag = true;
    //提交文件集合
    var commitFile = [];
    //版本控制数量
    var commitNumber = 0;
    function synchronizationSVN_open(){
        //测试分拣文件大小
        var size_1 = [];
        var size_2 = [];
        var size_3 = [];
        var size_4 = [];
        var size_5 = [];
        var size_6 = [];
        var size_7 = [];

        for(var h = 0;h<allUpload.length;h++){
            var fileId = allUpload[h].id;
            var fileName = allUpload[h].name;
            var fileSize = parseInt(allUpload[h].size);
            // var map = new Map();
            var map = new Object();
            if(fileSize >= 0 && fileSize <= 102400){
                //0KB - 100KB
                // console.log("文件属于0-100KB："+fileName+"   -"+fileSize);
                // map.set("index",h);
                // map.set("size",fileSize);
                map.index = h;
                map.size = fileSize;
                map.id = fileId;
                size_1.push(map);

            }else if(fileSize > 102400 && fileSize <= 512000){
                //100KB - 500KB
                // console.log("文件属于100-500KB："+fileName+"   -"+fileSize);
                map.index = h;
                map.size = fileSize;
                map.id = fileId;
                size_2.push(map);

            }else if(fileSize > 512000 && fileSize <= 1048576){
                //500KB - 1MB
                // console.log("文件属于500KB - 1MB："+fileName+"   -"+fileSize);
                map.index = h;
                map.size = fileSize;
                map.id = fileId;
                size_3.push(map);

            }else if(fileSize > 1048576 && fileSize <= 3145728){
                //1MB - 3MB
                // console.log("文件属于1MB - 3MB："+fileName+"   -"+fileSize);
                map.index = h;
                map.size = fileSize;
                map.id = fileId;
                size_4.push(map);

            }else if(fileSize > 3145728 && fileSize <= 10485760){
                //3MB - 10MB
                // console.log("文件属于3MB - 10MB："+fileName+"   -"+fileSize);
                map.index = h;
                map.size = fileSize;
                map.id = fileId;
                size_5.push(map);

            }else if(fileSize > 10485760 && fileSize <= 41943040){
                //10MB - 40MB
                // console.log("文件属于10MB - 40MB："+fileName+"   -"+fileSize);
                map.index = h;
                map.size = fileSize;
                map.id = fileId;
                size_6.push(map);

            }else{
                //40MB以上
                // console.log("文件属于40MB以上："+fileName+"      -"+fileSize);
                map.index = h;
                map.size = fileSize;
                map.id = fileId;
                size_7.push(map);

            }
        }
        commitFile = [];
        //0 - 100KB 30个
        if(size_1.length > 0){
            if(size_1.length > 30){
                //文件数量大于30个
                var s1_1 = [];//数组容器
                for(var s1 = 0; s1<size_1.length; s1++){
                    //如果等于30 或 循环长度等于总大小；
                    s1_1.push(size_1[s1]);
                    if(s1_1.length == 30 || s1 == (size_1.length-1)){
                        commitFile.push(s1_1);
                        s1_1=[];
                    }
                }
            }else{
                //文件数量小于30个
                commitFile.push(size_1);
            }

        }

        //100KB -500KB 20个
        if(size_2.length > 0){
            if(size_2.length > 20){
                //文件数量大于20个
                var s2_1 = [];//数组容器
                for(var s2 = 0; s2<size_2.length; s2++){

                    s2_1.push(size_2[s2]);
                    //如果等于20 或 循环长度等于总大小；
                    if(s2_1.length == 20 || s2 == (size_2.length-1)){
                        commitFile.push(s2_1);
                        s2_1=[];
                    }
                }
            }else{
                //文件数量小于20个
                commitFile.push(size_2);
            }
        }

        //500KB - 1MB 10M 20个
        if(size_3.length > 0){
            // console.log(size_3);
            if(size_3.length > 10){
                //文件数量大于10个
                var s3_1 = [];//数组容器
                var s3_2 = 0;//文件大小
                for(var s3 = 0; s3<size_3.length; s3++){

                    // s3_2 += size_3[s3].get('size');
                    s3_2 += size_3[s3].size;
                    //计算文件总大小小于10MB 和 文件总循环长度小于20
                    if(s3_2 < 10485760 && s3_1.length < 20 ){
                        s3_1.push(size_3[s3]);
                        if( s3 == (size_3.length-1)){
                            commitFile.push(s3_1);
                        }
                    }else{
                        //文件数量大于10MB，则将文件数组存入提交数组中，数组容器添加清空后添加本次循环参数
                        commitFile.push(s3_1);
                        s3_1 = [];
                        s3_1.push(size_3[s3]);
                        s3_2 = 0;
                        s3_2 += size_3[s3].size;
                    }
                }
            }else{
                //文件数量小于10个
                commitFile.push(size_3);
            }
        }

        //1MB - 3MB 15MB 15个
        if(size_4.length > 0){

            if(size_4.length > 5){
                //文件数量大于5个
                var s4_1 = [];//数组容器
                var s4_2 = 0;//文件大小
                for(var s4 = 0; s4<size_4.length; s4++){

                    s4_2 += size_4[s4].size;
                    //计算文件总大小小于15MB 和 文件总循环长度小于15
                    if(s4_2 < 15728640 && s4_1.length < 15 ){
                        //继续执行
                        s4_1.push(size_4[s4]);
                        if( s4 == (size_4.length-1)){
                            commitFile.push(s4_1);
                        }
                    }else{
                        //文件数量大于15MB，则将文件数组存入提交数组中，数组容器添加清空后添加本次循环参数
                        commitFile.push(s4_1);
                        s4_1 = [];
                        s4_1.push(size_4[s4]);
                        s4_2 = 0;
                        s4_2+= size_4[s4].size;
                    }
                }
            }else{
                //文件数量小于5个
                commitFile.push(size_4);
            }
        }

        //3MB - 10MB 25MB 10个
        if(size_5.length > 0){
            if(size_5.length > 2){
                //文件数量大于2个
                var s5_1 = [];//数组容器
                var s5_2 = 0;//文件大小
                for(var s5 = 0; s5<size_5.length; s5++){
                    s5_2 += size_5[s5].size;
                    //计算文件总大小小于25MB 或 文件总循环长度等于总长
                    if(s5_2 < 26214400 && s5_1.length < 10 ){
                        //继续执行
                        s5_1.push(size_5[s5]);
                        if( s5 == (size_5.length-1)){
                            commitFile.push(s5_1);
                        }
                    }else{
                        //文件数量大于25MB，则将文件数组存入提交数组中，数组容器添加清空后添加本次循环参数
                        commitFile.push(s5_1);
                        s5_1 = [];
                        s5_1.push(size_5[s5]);
                        s5_2 = 0;
                        s5_2+= size_5[s5].size;
                    }
                }
            }else{
                //文件数量小于2个
                commitFile.push(size_5);
            }
        }

        //10MB - 40MB 40MB 4个
        if(size_6.length > 0){
            if(size_6.length > 1){
                //文件数量大于2个
                var s6_1 = [];//数组容器
                var s6_2 = 0;//文件大小
                for(var s6 = 0; s6<size_6.length; s6++){
                    s6_2 += size_6[s6].size;
                    //计算文件总大小小于40MB 或 文件总循环长度等于总长
                    if(s6_2 < 41943040 && s6_1.length < 4 ){
                        //继续执行
                        s6_1.push(size_6[s6]);
                        if( s6 == (size_6.length-1)){
                            commitFile.push(s6_1);
                        }
                    }else{
                        //文件数量大于40MB，则将文件数组存入提交数组中，数组容器添加清空后添加本次循环参数
                        commitFile.push(s6_1);
                        s6_1 = [];
                        s6_1.push(size_6[s6]);
                        s6_2 = 0;
                        s6_2+= size_6[s6].size;
                    }
                }
            }else{
                //文件数量等于1个
                var s6_3=[];
                s6_3.push(size_6);
                commitFile.push(size_6);
            }
        }

        //40MB 以上 1个
        if(size_7.length > 0){
            for(var s7 = 0;s7<size_7.length;s7++){
                var s7_3=[];
                s7_3.push(size_7[s7]);
                commitFile.push(s7_3);
            }
        }

        if(commitFile.length > 0){
            AllCommitNumber = commitFile.length;
        }
        commitSynchronizationSVN();
    }

    //同步
    function commitSynchronizationSVN(){
        if(commitFile.length > 0){

            var commitFiles = commitFile[commitNumber];
            for (var j = 0; j < commitFiles.length; j++) {
                for(var g = 0 ; g < allUpload.length; g++){
                    if(commitFiles[j].id === allUpload[g].id){
                        allUpload[g].code = 3;
                        allUpload[g].message = '开始同步版本库';
                        break;
                    }
                }
                tranIframe.document.getElementById(commitFiles[j].id+'message').innerText = "";
                tranIframe.document.getElementById(commitFiles[j].id+'message').innerText = "开始同步版本库";
            }

            if(commitNumber < commitFile.length){
                var com = commitNumber;
                $.ajax({
                    type:'post',
                    url:'userResource/synchronizationSVN.do',
                    dataType:'json',
                    async:true,
                    data:{
                        jsonList:JSON.stringify(commitFile[com])
                    },
                    success:function(data){

                        var resultList = data.result;
                        var message = "";
                        if(data.code === '1000'){
                            message = "版本控制成功";
                        }else if(data.code === '2000') {
                            message = "版本控制失败";
                        }

                        if(commitNumber < commitFile.length){
                            commitSynchronizationSVN();
                        }else{

                            tranIframe.document.getElementById('uploadAllMessage').innerText = "版本控制完成";
                            // stopTime();
                            // t= 0;
                            $.messager.alert('系统提示',message);

                        }

                        //设置数据表的数据
                        for(var i = 0;i<resultList.length;i++){
                            for(var g = 0 ; g < allUpload.length; g++){
                                if(resultList[i] === allUpload[g].id){
                                    allUpload[g].code = 5;
                                    allUpload[g].message = message;
                                    break;
                                }
                            }
                            tranIframe.document.getElementById(resultList[i] + 'message').innerText = "";
                            tranIframe.document.getElementById(resultList[i] + 'message').innerText = message;
                        }

                        allUpload = [];
                    },
                    error:function(){
                        // stopTime();
                        $.messager.alert("系统提示","系统异常，请联系管理员");
                        return;
                    }
                });
                commitNumber ++;
            }



        }
    }

    /**
     * 生成随机Id (15位数)
     * 传入前缀 如 d_
     */
    function randomId(prefix){
        var randomText = "";
        if(prefix != null){
            randomText +=prefix;
        }
        for(var i = 0;i<15;i++){
            randomText += Math.floor(Math.random()*10);
        }
        return randomText;
    }


</script>


</body>
</html>
