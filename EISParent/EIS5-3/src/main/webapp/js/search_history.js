function time_deal() {
    //获取目录text
    var node = $('#tt').tree('getSelected');
    if (!node) {
        return {startTime: null, endTime: null};
    }
    var text = node.text;//今天 昨天 过去一周 过去一月 2019/12
    var startTime = '';
    var endTime = '';
    //处理text
    if (text.indexOf('/') === -1) {
        switch (text) {
            case '今天':
                startTime = getDay(-0) + ' 00:00:00';
                endTime = CurrentTime();
                break;
            case '昨天':
                startTime = getDay(-1) + ' 00:00:00';
                endTime = getDay(-0) + ' 00:00:00';
                break;
            case '过去一周':
                startTime = getDay(-7) + ' 00:00:00';
                endTime = CurrentTime();
                break;
            case '过去一月':
                startTime = getDay(-30) + ' 00:00:00';
                endTime = CurrentTime();
                break;

            case '更早' :
                startTime = CurrentTime();
                endTime = CurrentTime();
                break;
        }
    } else {
        //2020/01
        text = text.replace('/', '-');
        startTime = text + '-01 00:00:00';
        endTime = text + '-30 00:00:00';
    }
    return {startTime: startTime, endTime: endTime};
}
function doHandleMonth(month) {

    var m = month;

    if (month.toString().length == 1) {

        m = "0" + month;

    }

    return m;

}
function CurrentTime() {
    var now = new Date();
    var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    var day = now.getDate();            //日
    var hh = now.getHours();            //时
    var mm = now.getMinutes();          //分
    var ss = now.getSeconds();           //秒
    var clock = year + "-";
    if (month < 10)
        clock += "0";
    clock += month + "-";
    if (day < 10)
        clock += "0";
    clock += day + " ";
    if (hh < 10)
        clock += "0";
    clock += hh + ":";
    if (mm < 10) clock += '0';
    clock += mm + ":";
    if (ss < 10) clock += '0';
    clock += ss;
    return (clock);
}
function currentMonth() {
    var now = new Date();
    // var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    // var clock = year + "-";
    // var clock = '';
    // if (month < 10)
    //     clock += "0";
    // // clock += month + "-";
    // clock += month;
    return (month);
}
function currentYear() {
    var now = new Date();
    var year = now.getFullYear();       //年
    // var month = now.getMonth() + 1;     //月
    // var clock = year + "-";
    // var clock = '';
    // if (month < 10)
    //     clock += "0";
    // // clock += month + "-";
    // clock += month;
    return (year);
}
function getDay(day) {

    var today = new Date();

    var targetday_milliseconds = today.getTime() + 1000 * 60 * 60 * 24 * day;

    today.setTime(targetday_milliseconds); //注意，这行是关键代码

    var tYear = today.getFullYear();

    var tMonth = today.getMonth();

    var tDate = today.getDate();

    tMonth = doHandleMonth(tMonth + 1);

    tDate = doHandleMonth(tDate);

    return tYear + "-" + tMonth + "-" + tDate;

}
function treeData() {
    //当前月
    var year = currentYear();
    var month = currentMonth();
    // 定义年数组
    var text = [];
    //当前年依次减一获取数组
    for (var i = 0; i < 10; i++) {
        month--;
        if (month < 1) {
            month = 12;
            year--;
        }
        if (month < 10) {
            month = '0' + month;
        }
        text.push(year + '/' + month);
    }
    //组装tree.json
    var tree = [
        {
            id: 0,
            text: "全部记录"
        },
        {
            id: 1,
            text: "今天"
        },
        {
            id: 2,
            text: "昨天"
        }, {
            id: 3,
            text: "过去一周"
        }, {
            id: 4,
            text: "过去一月"
        }, {
            id: 5,
            text: "更早",
            state: "closed",
            "children": [
                {
                    // id: 1,
                    text: text[0]
                }, {
                    // id: 1,
                    text: text[1]
                }, {
                    // id: 1,
                    text: text[2]
                }, {
                    // id: 1,
                    text: text[3]
                }, {
                    // id: 1,
                    text: text[4]
                }, {
                    // id: 1,
                    text: text[5]
                }, {
                    // id: 1,
                    text: text[6]
                }, {
                    // id: 1,
                    text: text[7]
                }, {
                    // id: 1,
                    text: text[8]
                }, {
                    // id: 1,
                    text: text[9]
                }
                // , {
                //     // id: 1,
                //     text: '加载全部'
                // }
            ]
        },

    ];
    return tree;
}