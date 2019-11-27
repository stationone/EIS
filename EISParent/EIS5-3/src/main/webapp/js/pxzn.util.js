        //处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外
      function banBackSpace(e){   
         var ev = e || window.event;//获取event对象   
          var obj = ev.target || ev.srcElement;//获取事件源   
          var t = obj.type || obj.getAttribute('type');//获取事件源类型  
          //获取作为判断条件的事件类型
          var vReadOnly = obj.getAttribute('readonly');
          //处理null值情况
         vReadOnly = (vReadOnly == "") ? false : vReadOnly;
         //当敲Backspace键时，事件源类型为密码或单行、多行文本的，
         //并且readonly属性为true或enabled属性为false的，则退格键失效
         var flag1=(ev.keyCode == 8 && (t=="password" || t=="text" || t=="textarea") 
                     && vReadOnly=="readonly")?true:false;
         //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
         var flag2=(ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea")
                     ?true:false;        
         
         //判断
         if(flag2){
             return false;
         }
         if(flag1){   
             return false;   
         }   
     }
 
 window.onload=function(){
     //禁止后退键 作用于Firefox、Opera
     document.onkeypress=banBackSpace;
     //禁止后退键  作用于IE、Chrome
     document.onkeydown=banBackSpace;
 }

        /**
         * 随机数
         * 1231231343
         */
        function getId(start){
            var id = "";
            if(start != null){
                id = start;
            }
            for(var i= 0;i<10;i++){
                id += Math.round(Math.random()*9);
            }
            return id;
        }
        /**
         * 获取随机编号
         * 返回 20190309141941761231
         */
        function getRandomId(){
            return getDate()+getRandomNumber();
        }
        /**
         * 获取日期
         * 返回 20190309140805
         */
        function getDate(){
            var date = new Date();
            var year = date.getFullYear();
            var month = date.getMonth()+1;
            var day = date.getDate();
            var hour = date.getHours();
            var minute = date.getMinutes();
            var second = date.getSeconds();

            if(month > 0 && month < 10){
                month = '0'+ month;
            }
            if(day > 0 && day < 10){
                day = '0'+ day;
            }
            if(hour >= 0 && hour < 10){
                hour = '0'+ hour;
            }
            if(minute >= 0 && minute < 10){
                minute = '0'+ minute;
            }
            if(second >= 0 && second < 10){
                second = '0'+ second;
            }

            var dates = year+''+month+''+day+''+hour+''+minute+''+second;
            return dates;
        }

        /**
         * 获取随机数
         * 传入 随机数的长度，默认是6位
         * 返回 957506
         */
        function getRandomNumber(number){
            if(number == null || number <= 0){
                number = 6;
            }
            var random = "";
            for(var i = 0;i<number;i++){
                random += Math.floor(Math.random()*10);
            }
            return random;

        }



        /**
 * 权限设置
 * select列表项
 * 公共方法
 */

        //左按键
        function leftButton(){
            var oldSelect =  document.getElementById("oldSelect");
            var str = [];
            for(var i=0;i<oldSelect.length;i++){
                if(oldSelect.options[i].selected){
                    var obj = {};
                    obj.value = oldSelect[i].value;
                    obj.text = oldSelect[i].text;
                    str.push(obj);
                }
            }

            var newSelect =  document.getElementById("newSelect");
            for(var i = 0;i<str.length;i++){
                selectRemove(oldSelect,str[i].value);
                selectAdd(newSelect,str[i].text,str[i].value);
            }

        }

        //右按键
        function rightButton(){
            var newSelect =  document.getElementById("newSelect");

            var str = [];
            for(var i=0;i<newSelect.length;i++){
                if(newSelect.options[i].selected){
                    var obj = {};
                    obj.value = newSelect[i].value;
                    obj.text = newSelect[i].text;
                    str.push(obj);
                }
            }

            var oldSelect =  document.getElementById("oldSelect");
            for(var i = 0;i<str.length;i++){
                selectRemove(newSelect,str[i].value);
                selectAdd(oldSelect, str[i].text ,str[i].value);
            }
        }


        /**
         * 选项列表添加
         * @param select
         * @param itemText
         * @param itemValue
         */
        function selectAdd(select, itemText, itemValue){
            var varItem = new Option(itemText, itemValue);
            select.options.add(varItem);
        }

        /**
         * 选项列表移出
         * @param select
         * @param itemValue
         */
        function selectRemove(select, itemValue){
            for(var i = 0;i<select.options.length;i++){
                if(select.options[i].value == itemValue){
                    select.options.remove(i);
                    break;
                }
            }
        }

        /**
         * 查询
         * @param select
         * @param itemValue
         */
        function selectQuery(select, itemValue){
            var isExit = false;
            for (var i = 0; i < select.options.length; i++) {
                if (select.options[i].value == itemValue) {
                    isExit = true;
                    break;
                }
            }
            return isExit;
        }


        /**
         * 消息处理
         * @param data
         * @return {*}
         */
        function returnMessager(data){
            var code = data.code;
            // if(code == null || code == messagerCode.success){
            //     return data;
            // }else if(code == messagerCode.user_failure){
            //     //用户失效
            //     returnTooltip();
            //     return null;
            // }

            if(code != null && code == messagerCode.user_failure){
                //用户失效
                returnTooltip();
                return null;
            }
            return data;
        }

        /**
         * 消息提示框
         */
        function returnTooltip(){
            jumpNumber = 3;
            $.messager.alert('系统提示','<div>当前登录账户失效，请重新登录！</div><div><span><span id="jumpNumber" style="color:red">'+jumpNumber+'</span>秒后自动跳转</span></div>');
            startTime();
        }

        //倒计时
        var jumpNumber = 3;
        var t;
        function startTime(){

            var spanJump = document.getElementById("jumpNumber");
            if(spanJump != null){
                spanJump.innerHTML = jumpNumber;
            }
            jumpNumber -- ;
            if(jumpNumber <= 0){
                clearTimeout(t);
                top.location='login.jsp';
                return;
            }
            t = setTimeout("startTime()", 1000);
        }


        /**
         * 错误编码
         */
        var messagerCode = {
            success:'1000'//成功
            ,defeated:'2000' //失败
            ,user_failure:'2001'//用户失效
        };

//异常提示

        /**
         * easyui
         * datagrid
         * 超时和错误处理
         */
        function eastyuiOverTimeOrError(datagridObject, datagrid){
            if(datagridObject != null){
                datagridObject[datagrid]({
                    loadFilter:function(data){

                        var datas = returnMessager(data);
                        if(datas == null){
                            //登录超时
                            if(datagrid == "datagrid"){
                                data = {"rows":[],"total":0};
                            }else{
                                data = [];
                            }
                        }
                        return data;
                    },
                    onLoadError:function(none){
                        serverError();
                    }
                });
            }
        }

        /**
         * 服务器异常
         */
        function serverError(){
            $.messager.alert('系统提示','服务器异常，请联系管理员！');
        }



