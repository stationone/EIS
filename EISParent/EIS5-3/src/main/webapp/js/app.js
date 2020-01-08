//获取浏览器页面可见高度和宽度
var _PageHeight = document.documentElement.clientHeight,
    _PageWidth = document.documentElement.clientWidth;

//计算loading框距离顶部和左部的距离（loading框的宽度为215px，高度为61px）
var _LoadingTop = _PageHeight > 61 ? (_PageHeight - 61) / 2 : 0,
    _LoadingLeft = _PageWidth > 215 ? (_PageWidth - 215) / 2 : 0;

//加载gif地址
var Loadimagerul="../../themes/metro/images/loading.gif";

//在页面未加载完毕之前显示的loading Html自定义内容
var _LoadingHtml = '<div id="loadingDiv" style="position:absolute;left:0;width:100%;height:' + _PageHeight + 'px;top:0;background:#f3f8ff;opacity:1;filter:alpha(opacity=80);z-index:10000;"><div style="position: absolute; cursor1: wait; left: ' + _LoadingLeft + 'px; top:' + _LoadingTop + 'px; width:100px;; height: 57px; line-height: 57px; padding-left: 25px; padding-right: 5px; background: #fff url('+Loadimagerul+') no-repeat scroll 5px 12px;  color: #696969; font-family:\'Microsoft YaHei\';">Loading</div></div>';
//呈现loading效果
document.write(_LoadingHtml);

//监听加载状态改变
document.onreadystatechange = completeLoading;

//加载状态为complete时移除loading效果
function completeLoading() {
    if (document.readyState == "complete") {
        var loadingMask = document.getElementById('loadingDiv');
        loadingMask.parentNode.removeChild(loadingMask);
    }
}

/**
 * 包含easyui的扩展和常用的方法
 *
 * @author
 *
 * @version 20120806
 */

var app = $.extend({}, app);/* 定义全局对象，类似于命名空间或包的作用 */
//给表单绑定将表单转换成json对象方法
$.fn.serializeJson = function () {
    var serializeObj = {};
    var array = this.serializeArray();
    var str = this.serialize();
    $(array).each(function () {
        if (serializeObj[this.name]) {
            if ($.isArray(serializeObj[this.name])) {
                serializeObj[this.name].push(this.value);
            } else {
                serializeObj[this.name] = [serializeObj[this.name], this.value];
            }
        } else {
            serializeObj[this.name] = this.value;
        }
    });
    return serializeObj;
};
/**
 *
 * @requires jQuery,EasyUI
 *
 * panel关闭时回收内存，主要用于layout使用iframe嵌入网页时的内存泄漏问题
 */
$.fn.panel.defaults.onBeforeDestroy = function() {
    var frame = $('iframe', this);
    try {
        if (frame.length > 0) {
            for ( var i = 0; i < frame.length; i++) {
                frame[i].contentWindow.document.write('');
                frame[i].contentWindow.close();
            }
            frame.remove();
            if ($.browser.msie) {
                CollectGarbage();
            }
        }
    } catch (e) {
    }
};

/**
 * 使panel和datagrid在加载时提示
 *
 *
 * @requires jQuery,EasyUI
 *
 */
$.fn.panel.defaults.loadingMessage = '加载中....';
$.fn.datagrid.defaults.loadMsg = '加载中....';
/**
 *
 * @requires jQuery,EasyUI
 *
 * 扩展validatebox，添加验证两次密码功能
 */
$.extend($.fn.validatebox.defaults.rules, {
    eqPwd : {
        validator : function(value, param) {
            return value == $(param[0]).val();
        },
        message : '密码不一致！'
    },
    idcard : {// 验证身份证
        validator : function(value) {
            return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
        },
        message : '身份证号码格式不正确'
    },
    minLength: {
        validator: function(value, param){
            return value.length >= param[0];
        },
        message: '请输入至少（2）个字符.'
    },
    length:{validator:function(value,param){
            var len=$.trim(value).length;
            return len>=param[0]&&len<=param[1];
        },
        message:"输入内容长度必须介于{0}和{1}之间."
    },
    phone : {// 验证电话号码
        validator : function(value) {
            return /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);
        },
        message : '格式不正确,请使用下面格式:010-88888888'
    },
    mobile : {// 验证手机号码
        validator : function(value) {
            return /^(13|15|18)\d{9}$/i.test(value);
        },
        message : '手机号码格式不正确'
    },
    intOrFloat : {// 验证整数或小数
        validator : function(value) {
            return /^\d+(\.\d+)?$/i.test(value);
        },
        message : '请输入数字，并确保格式正确'
    },
    currency : {// 验证货币
        validator : function(value) {
            return /^\d+(\.\d+)?$/i.test(value);
        },
        message : '货币格式不正确'
    },
    qq : {// 验证QQ,从10000开始
        validator : function(value) {
            return /^[1-9]\d{4,9}$/i.test(value);
        },
        message : 'QQ号码格式不正确'
    },
    integer : {// 验证整数
        validator : function(value) {
            return /^[+]?[1-9]+\d*$/i.test(value);
        },
        message : '请输入整数'
    },
    age : {// 验证年龄
        validator : function(value) {
            return /^(?:[1-9][0-9]?|1[01][0-9]|120)$/i.test(value);
        },
        message : '年龄必须是0到120之间的整数'
    },
    chinese : {// 验证中文
        validator : function(value) {
            return /^[\Α-\￥]+$/i.test(value);
        },
        message : '请输入中文'
    },
    english : {// 验证英语
        validator : function(value) {
            return /^[A-Za-z]+$/i.test(value);
        },
        message : '请输入英文'
    },
    unnormal : {// 验证是否包含空格和非法字符
        validator : function(value) {
            return /.+/i.test(value);
        },
        message : '输入值不能为空和包含其他非法字符'
    },
    username : {// 验证用户名
        validator : function(value) {
            return /^[a-zA-Z][a-zA-Z0-9_]{5,15}$/i.test(value);
        },
        message : '用户名不合法（字母开头，允许6-16字节，允许字母数字下划线）'
    },
    faxno : {// 验证传真
        validator : function(value) {
            return /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);
        },
        message : '传真号码不正确'
    },
    zip : {// 验证邮政编码
        validator : function(value) {
            return /^[0-9]\d{5}$/i.test(value);
        },
        message : '邮政编码格式不正确'
    },
    ip : {// 验证IP地址
        validator : function(value) {
            return /d+.d+.d+.d+/i.test(value);
        },
        message : 'IP地址格式不正确'
    },
    name : {// 验证姓名，可以是中文或英文
        validator : function(value) {
            return /^[\Α-\￥]+$/i.test(value)|/^\w+[\w\s]+\w+$/i.test(value);
        },
        message : '请输入姓名'
    },
    msn:{
        validator : function(value){
            return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);
        },
        message : '请输入有效的msn账号(例：abc@hotnail(msn/live).com)'
    }
});
/**
 * 对Date的扩展，将 Date 转化为指定格式的String
 <br>月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
 <br>年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
 <br>例子：
 <br>(new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423
 <br>(new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18
 * @param {Object} fmt
 */
Date.prototype.Format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};

/**
 *
 * @requires jQuery,EasyUI,jQuery cookie plugin
 *
 * 更换EasyUI主题的方法
 *
 * @param themeName
 *            主题名称
 */
changeTheme = function(themeName) {
    var $easyuiTheme = $('#easyuiTheme');
    var url = $easyuiTheme.attr('href');
    var href = url.substring(0, url.indexOf('themes')) + 'themes/' + themeName + '/easyui.css';
    $easyuiTheme.attr('href', href);

    var $iframe = $('iframe');
    if ($iframe.length > 0) {
        for ( var i = 0; i < $iframe.length; i++) {
            var ifr = $iframe[i];
            $(ifr).contents().find('#easyuiTheme').attr('href', href);
        }
    }

    $.cookie('easyuiThemeName', themeName, {
        expires : 7
    });
};

/**
 * @author
 *
 * @requires jQuery
 *
 * 判断浏览器是否是IE并且版本小于8
 *
 * @returns true/false
 */
app.isLessThanIe7 = function() {
     return ($.browser.msie && $.browser.version < 7);
};

/**
 * 日期格式化
 * @param {Object} date
 */
app.dateFormat=function(date){
    if(date==null){
        return "--";
    }
    return new Date(date).Format("yyyy-MM-dd");
};

/**
 * 日期时间格式化
 * @param {Object} date
 */
app.dateTimeFormat = function (date) {
    if (date == null) {
        return "--";
    }
    return new Date(date).Format("yyyy-MM-dd hh:mm:ss");
};

/**
 * ajax请求
 * @param {Object} url    请求的url地址
 * @param {Object} requestData    请求的参数对象实例
 * @param {Object} callback    回调函数
 * @param {Object} type    请求方式：GET/POST/DELETE/PUT，缺省 GET
 * @param {Object} isJsonType    是否使用json格式传请求参数，true 或者 false，缺省 false。
 */
app.request = function (url, requestData, callback, type, isJsonType) {
    //缺省使用GET请求
    type = (type) ? type : "GET";

    //是否使用json格式传参
    if (isJsonType == null && type.toUpperCase() == "POST") {
        isJsonType = true;
    }

    //请求参数数据格式
    var contentType = "application/x-www-form-urlencoded";

    //设置请求参数，缺省是query结构
    //requestData = (requestData == "{}") ? "" : requestData;
    //requestData = requestData == null ? "" : requestData;
    if (isJsonType && type.toUpperCase() == "POST") {
        requestData = JSON.stringify(requestData);
        contentType = "application/json; charset=utf-8";
    }
    $.ajax({
        url: url,//请求地址
        type: type,
        async: true,//默认为异步
        // cache:true,//默认从浏览器加载缓存
        data: requestData,//参数
        contentType: contentType,//数据请求格式
        //dataType:'json',//响应格式
        complete: function (xhr, st) {//请求完成后回调函数 (请求成功或失败之后均调用)。
            //接收完成时
            if (xhr.readyState == 4) {
                if (xhr.status == '401') {//未登录认证
                    app.msg("没有登录或会话失效，请先登录");
                    setTimeout(function () {
                        window.location.href = '/main/login.html';
                    }, 1000)
                } else if (xhr.status == '403') {//请求不到地址
                    app.msg("您没有操作权限，请联系管理员");
                    setTimeout(function () {
                        window.location.href = '/main/login.html';
                    }, 1000)
                } else if (xhr.status == '404') {//请求不到地址
//                      window.location.href = '/html/404.html';
                    app.msg("没有获取到数据，没有找到服务器");
                } else if (xhr.status == '500') {//服务器错误
//                      window.location.href = '/html/404.html';
						app.msg(xhr.responseText);
                    setTimeout(function () {
                        window.location.href = '/main/login.html';
                    }, 200);
                    xhr.getResponseHeader()
                } else {
                    var obj = "";
                    try {
                        obj = JSON.parse(xhr.responseText);
                        /*if(app.isNotNull(obj.code)&& obj.code=='500'){
                            app.msg(obj.msg);
                            return ;
                        }*/
                    } catch (e) {
                        obj = xhr.responseText;
                    }
                    if(obj.code==0){
                        callback(obj, xhr.status);
                    }else{
                        app.msg(obj.message);
                    }
                }
            }
        },
        beforeSend: function (request) {
            /*request.setRequestHeader("token", app.getToken());
            request.setRequestHeader("euserType", "1");*/
        },
        error: function (rep) {
            console.log(JSON.stringify(rep));
        }
    });
};

app.msg = function (msg) {
    $.messager.show({
        title: '提示',
        msg: msg,
        timeout: 1000,
        showType: 'slide'
    });
};