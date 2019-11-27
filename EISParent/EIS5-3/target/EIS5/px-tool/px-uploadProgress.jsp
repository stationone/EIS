<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-06-21
  Time: 17:36
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
    <title>上传进度</title>
<%--    <link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">--%>
<%--    <link rel="stylesheet" type="text/css" href="css/px-style.css">--%>
<%--    <script src="js/jquery.min.js"></script>--%>
<%--    <script src="js/jquery.easyui.min.1.5.2.js"></script>--%>
    <style>
        .fileUploadPlan_div{
            margin:15px 10px 0 10px;
            padding-bottom:10px;
            height: 21px;border-bottom: 1px solid #cdcdcd
        }
        .fileUpload_name_div{
            overflow: hidden;
            mib-width: 150px;
            height: 16px;
            font-size: 1em;
            float: left;
        }
        .fileUpload_name{
            width: 100%;
            font-size: 14px;
        }
        .fileUploadText{
            font-size: 14px;
            float: right;margin-left: 100px;width: 106px;
        }
        .fileUploadPlan_show{
            width: 165px;
            height: 10px;
            float: right;
        }
    </style>
    <script>
        var fileList = [
             {id:'f_21212156212',name:'文件名称1',code:'2'}
            ,{id:'f_21212121452',name:'文件名称3',code:'2'}
            ,{id:'f_21212121232',name:'文件名称4',code:'2'}
            ,{id:'f_212121186212',name:'文件名5称',code:'2'}
            ,{id:'f_212121223612',name:'文件名6称',code:'2'}
            ,{id:'f_212121210792',name:'文件名7称',code:'2'}
            ,{id:'f_212121215642',name:'文件名8称',code:'2'}

        ];



    </script>
</head>
<body>
<%--<div id="div_upload" style="width:100%;padding:12px 0; position: fixed;background: white;min-width: 1000px; border-bottom: 1px solid #cdcdcd;display: block">--%>
<%--    <span id="uploadAllTitle" style="margin-left: 20px;">上传总进度</span>--%>
<%--    <progress id="uploadAllProgress" max="100" value="0" style="width: 35%;height: 19px;margin-left: 50px"></progress>--%>
<%--    <span style="color:#35ABF9;margin-left: 37px;"><span id="fileSpeed"></span><span style="margin-left:5px;">KB/S</span></span>--%>
<%--    <span style="margin-left: 37px;">已耗时：<span id="fileTime" style="color:#35ABF9;"></span></span>--%>
<%--    <span id="fileSize" style="margin-left: 20px">--%>
<%--                    文件大小:--%>
<%--                    <span id="fileAllSize"></span>--%>
<%--                </span>--%>
<%--    <span id="uploadAllMessage" style="margin-left: 20px"></span>--%>
<%--</div>--%>

    <div>
        <div id="div_upload" style="width:100%; background: white;min-width: 1086px; border-bottom: 1px solid #F5F5F5;">
            <table style="width: 100%;font-size: 14px;padding: 15px 0;padding-left: 5px" cellspacing="0">
                <tr>
                    <td style="width: 100px;text-align: left;margin-left: 20px">
                        <span id="uploadAllTitle" style="font-weight: bold">上传总进度</span>
                    </td>
                    <td style="width: 500px">
                        <div id="uploadAllProgress" class="easyui-progressbar" data-options="value:50" style="margin-left: 15px;width:100%;height: 20px;background: #E5E6EA"></div>
                    </td>
                    <td>
                         <span style="color:#02498F;font-size: 12px;margin-left: 20px;font-weight: bold">
                            <span id="fileSpeed">500</span>
                            <span >KB/S</span>
                        </span>
<%--                        <span>已耗时：--%>
<%--                            <span id="fileTime" style="color:#35ABF9;"></span>--%>
<%--                        </span>--%>
<%--                        <span id="fileSize">--%>
<%--                         文件大小:--%>
<%--                            <span id="fileAllSize"></span>--%>
<%--                         </span>--%>
                    </td>
                    <td style="width:20%">
                        <span id="uploadAllMessage" style="margin-left: 20px"></span>
                    </td>

                </tr>
            </table>

<%--            <span id="uploadAllTitle" style="margin-left: 20px;">上传总进度</span>--%>
<%--            <progress id="uploadAllProgress" max="100" value="0" style="width: 35%;height: 19px;margin-left: 50px"></progress>--%>
<%--            <span style="color:#35ABF9;margin-left: 37px;"><span id="fileSpeed"></span><span style="margin-left:5px;">KB/S</span></span>--%>
<%--            <span style="margin-left: 37px;">已耗时：<span id="fileTime" style="color:#35ABF9;"></span></span>--%>
<%--            <span id="fileSize" style="margin-left: 20px">--%>
<%--                    文件大小:--%>
<%--                    <span id="fileAllSize"></span>--%>
<%--                </span>--%>
<%--            <span id="uploadAllMessage" style="margin-left: 20px"></span>--%>
        </div>
        <style>
            #fileUpload_div table tr td{
                padding:10px 0;
            }
        </style>
        <div id="fileUpload_div" style="overflow-y: auto;">
<%--            <table style="width: 100%" cellspacing="0" cellpadding="0">--%>
<%--                <tr>--%>
<%--                    <td style="width: 20px; padding: 0 5px 0 14px;border-bottom: 1px solid #F5F5F5">--%>
<%--                        <img src="images/px-icon/upload-img.png" style="width: 20px;">--%>
<%--                    </td>--%>
<%--                    <td   style="border-bottom: 1px solid #F5F5F5">--%>
<%--                        <div style="overflow: hidden;height: 20px;font-size: 14px">--%>
<%--                            <span title="" class="easyui-tooltip tooltip-f">client_authentication.h</span>--%>
<%--                        </div>--%>
<%--                        <div style="height: 20px;font-size: 14px">--%>
<%--                            <span  style="font-size: 12px;color: #B4B4B4;font-weight: bold;" >3.26MB</span>--%>
<%--                        </div>--%>
<%--                    </td>--%>
<%--                    <td style="width: 200px;border-bottom: 1px solid #F5F5F5;padding-right: 20px">--%>
<%--                        <div id="pg_f_859788400336235" class="easyui-progressbar progressbar" data-options="value:30" style="width: 100%; height: 15px;">--%>
<%--                        </div>--%>
<%--                        <div style="margin-top: 3px;">--%>
<%--                            <span id="f_8597884003236235message" style="font-size: 12px;color: #B4B4B4;font-weight: bold;">开始同步版本库</span>--%>
<%--                        </div>--%>
<%--                    </td>--%>
<%--                </tr>--%>
<%--            </table>--%>
        </div>
    </div>
</body>
</html>
