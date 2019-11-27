/**
 * 错误编码
 */
var messagerCode = {
    success:'1000'//成功
    ,defeated:'2000' //失败
    ,user_failure:'2001'//用户失效
    ,nameRepetition:'2004'//名称重复
};


    function message_Show(message, title, time){
        if(title == null || title === ""){
            title = '系统提示';
        }
        if(time == null){
            time = 3000;
        }
        $.messager.show({
            title: title,
            msg:message,
            timeout: time,
            showType: 'slide'
        });
    }

    function message_Alert(message, title){
        if(title == null || title === ""){
            title = '系统提示';
        }
        $.messager.alert(title, message);
    }