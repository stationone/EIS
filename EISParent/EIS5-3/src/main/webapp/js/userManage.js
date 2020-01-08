var UserManage = {
    param:{
        pageNo:1,
        pageSize:10,
        userName:''
    },
    method: '',
    //初始化页面数据
    init(){
        UserManage.showListData(UserManage.param);
        $('#userTable').datagrid('getPager').pagination({
            //分页监听事件
            onSelectPage: function (pageNumber, pageSize) {
                UserManage.param.pageNo = pageNumber;
                UserManage.param.pageSize = pageSize;
                UserManage.showListData(UserManage.param);
            }
        });

        $("#userDialog").dialog({
            onClose: function () {
                $('#userForm').form('reset')
            }
        });
    },
    //初始化参数
    initParam : function(){
        
    },
    //打开新增/编辑窗口
    openUserDialog(method){
        if(method==='ADD'){
            UserManage.method = 'ADD';
            $('#userDialog').dialog({title:'新增用户'}).dialog('open');
        }else if(method === 'EDIT'){
            UserManage.method = 'EDIT';
            var rows = $('#userTable').datagrid('getChecked');
            if(rows.length !== 1){
                app.msg("请选择一条数据进行编辑!");
            }else{
                $('#userDialog').dialog({title:'编辑用户'}).dialog('open');
                UserManage.showFormData(rows[0]);
            }
        }
    },
    //搜索
    doSearch:function () {
        let userName = $('#userNameParam').val();
        UserManage.param.userName = userName;
        UserManage.showListData(UserManage.param);
    },
    //展示数据
    showListData: function(param){
        let url = "/soda/user/listByPage?pageNo=" + param.pageNo + "&pageSize=" + param.pageSize + "&userName=" + param.userName;
        app.request(url, null,function (res) {
            if(res){
                console.log(res)
                $('#userTable').datagrid('loadData',{
                    total: res.data.total,
                    rows: res.data.list
                });
            }
        });
    },
    showFormData(row){
        $('#userForm').form('load',row);
    },
    //表单提交
    submitForm:function () {
        let data = $("#userForm").serializeJson();
        let url = '';
        let msg = '';
        if(UserManage.method === 'ADD'){
            url = '/soda/user/add';
            msg = "新增用户成功!"
        }else if(UserManage.method === 'EDIT'){
            url = '/soda/user/update';
            msg = "编辑用户成功!"
        }
        if($('#userForm').form('validate')){
            app.request(url,data,function (res) {
                if(res){
                    app.msg(msg);
                    $('#userDialog').dialog('close');
                    UserManage.showListData(UserManage.param);

                }
            },'post')
        }else{
            return false;
        }
    },
    //删除用户
    delUser:function () {
        var rows = $('#userTable').datagrid('getChecked');
        if(rows.length !== 1){
            app.msg("请选择一条数据进行删除!");
        }else{
            $.messager.confirm('警告', '确定要删除此数据吗?', function(r){
                if (r){
                    app.request("/soda/user/del/"+rows[0].id,null,function (res) {
                        if(res){
                            app.msg("删除用户成功!");
                            UserManage.showListData(UserManage.param);
                        }
                    })
                }
            });
        }

    }
};
$(function () {
    UserManage.init();
});