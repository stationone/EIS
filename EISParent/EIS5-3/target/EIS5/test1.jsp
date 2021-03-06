<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="ui/jquery.min.js"></script>
    <script src="http://www.easyui-extlib.com/Scripts/jquery-extensions/jquery.jdirk.js"></script>
    <link href="css/easyui.css" rel="stylesheet" />
    <link href="easyui/themes/icon.css" rel="stylesheet" />
    <script src="easyui/jquery.easyui.min.js"></script>
    <script src="easyui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="js/yyan.js"></script>
    <title>learn datagrid</title>
</head>
<body>
<div>
    <input id="cc1" name="dept1" style="width: 60px"> <input
        id="cc" name="dept"> <a href="javascript:void(0);" id="query"
                                class="easyui-linkbutton" iconCls="icon-search">Query</a>
</div>
<script>
    $('#cc1').combobox({
        url : 'data1.json',
        valueField : 'id',
        textField : 'text',
        panelHeight : 'auto',
        panelWidth : 'auto',
        editable : false
    });
    $('#cc').combobox({
        url : 'data1.json',
        valueField : 'id',
        textField : 'text',
        panelHeight : 'auto',
        multiple: false,
        editable : true,
        hasDownArrow : false,
        prompt : '输入关键字后自动搜索',
        filter : function(q, row) {
            var opts = $(this).combobox('options');
            var arr = row[opts.textField].indexOf(q) >= 0;
            return arr;//这里改成>=即可在任意地方匹配
        }
    });
    $('#query').click(
        function() {
            alert($('#cc1').combobox('getText') + ':'
                + $('#cc').combobox('getText'));
        });
</script>
</body>
</html>