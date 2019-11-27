<%--
  Created by IntelliJ IDEA.
  User: lvkl
  Date: 2019-07-02
  Time: 10:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>总体概念设计</title>
    <link rel="stylesheet" type="text/css" href="../../css/easyui.css">
    <link rel="stylesheet" type="text/css" href="../../css/px-style.css">
    <script src="../../js/jquery.min.js"></script>
    <script src="../../js/jquery.easyui.min.1.5.2.js"></script>
    <script src="../../js/px-tool/px-util.js"></script>
    <script src="../../js/pxzn.easyui.util.js"></script>
    <script>
        $(function(){
            $('#tt').tree({
                onClick:function(node){
                    if(node.id == null){
                        return;
                    }
                    var divParent = document.getElementById("div_center");
                    var childNodes = divParent.childNodes;
                    for(var i = 0 ;i<childNodes.length;i++){
                        var childNode = childNodes[i];
                        if(childNode.id != null){
                            if(node.id == "tree_"+childNode.id){
                                //一样
                                $('#'+childNode.id).show();
                            }else{
                                //不一样
                                $('#'+childNode.id).hide();
                            }
                            // console.log(childNode.id);
                        }

                    }
                }

            })
        });


        /**
         * 点击
         */
        function img_click(data){
            switch (data) {
                case '1':
                    $('#img_1').show();
                    $('#img_2').hide();
                    break;
                case '2':
                    $('#img_2').show();
                    $('#img_1').hide()
                    break;
                case '3':
                    $('#div_table_1').show();
                    $('#div_table_2').hide();
                    break;
                case '4':
                    $('#div_table_2').show();
                    $('#div_table_1').hide();
                    break;
                case '5':
                    $('#div_5').show();
                    $('#div_6').hide();
                    break;
                case '6':
                    $('#div_6').show();
                    $('#div_5').hide();
            }
        }

    </script>
</head>
<body id="jobManagement_layout" class="easyui-layout">
<div data-options="region:'west'" class="layout-west">
<%--    <div id="mojao" class="layout-title-div">--%>
<%--        <img src="../../images/px-icon/hide-left-black.png" onclick="layoutHide('jobManagement_layout','west')" class="layout-title-img">--%>
<%--    </div>--%>
    <ul id="tt" class="easyui-tree">
        <li>
            <span>飞机总体概念设计</span>
            <ul>
                <li id="tree_a_1">
                    <span>总体设计要求</span>
                </li>
                <li id="tree_a_2">
                    <span>构型设计</span>
                </li>
                <li id="tree_a_3">
                    <span>外形设计</span>
                </li>
                <li id="tree_a_4">
                    <span>重量评估</span>
                </li>
                <li>
                    <span>启动评估</span>
                </li>
                <li>
                    <span>性能评估</span>
                </li>
            </ul>
        </li>
    </ul>

</div>
<div data-options="region:'center'" >
    <div id="div_center">
        <div id="a_1" style="display: none;width: 100%;height: 100%">
            <iframe src="Java编程规范.htm" style="width: 100%;height: 100%;" frameborder="0"></iframe>
        </div>
        <div id="a_2" style="display: block;height: 100%;width: auto">
            <div id="container" style="width:80%;height: 100%">
                <script src="../../js/echarts-3.8.js"></script>
                <script type="text/javascript">
                    var dom = document.getElementById("container");
                    var myChart = echarts.init(dom);
                    var app = {};
                    option = null;
                    var symbolSize = 3;
                    var data = [[15, 0], [-50, 10], [-56.5, 20], [-46.5, 30], [-22.1, 40]];

                    option = {
                        title: {
                            text: '标题'
                        },
                        tooltip: {
                            triggerOn: 'none',
                            formatter: function (params) {
                                return 'X: ' + params.data[0].toFixed(2) + '<br>Y: ' + params.data[1].toFixed(2);
                            }
                        },
                        grid: {
                        },
                        xAxis: {
                            min: -100,
                            max: 80,
                            type: 'value',
                            axisLine: {onZero: false}
                        },
                        yAxis: {
                            min: -30,
                            max: 60,
                            type: 'value',
                            axisLine: {onZero: false}
                        },
                        dataZoom: [
                            {
                                type: 'slider',
                                xAxisIndex: 0,
                                filterMode: 'empty'
                            },
                            {
                                type: 'slider',
                                yAxisIndex: 0,
                                filterMode: 'empty'
                            },
                            {
                                type: 'inside',
                                xAxisIndex: 0,
                                filterMode: 'empty'
                            },
                            {
                                type: 'inside',
                                yAxisIndex: 0,
                                filterMode: 'empty'
                            }
                        ],
                        series: [
                            {
                                id: 'a',
                                type: 'line',
                                smooth: true,
                                symbolSize: symbolSize,
                                data: data
                            }
                        ]
                    };


                    if (!app.inNode) {
                        setTimeout(function () {
                            // Add shadow circles (which is not visible) to enable drag.
                            myChart.setOption({
                                graphic: echarts.util.map(data, function (item, dataIndex) {
                                    return {
                                        type: 'circle',
                                        position: myChart.convertToPixel('grid', item),
                                        shape: {
                                            cx: 0,
                                            cy: 0,
                                            r: symbolSize / 2
                                        },
                                        invisible: true,
                                        draggable: true,
                                        ondrag: echarts.util.curry(onPointDragging, dataIndex),
                                        onmousemove: echarts.util.curry(showTooltip, dataIndex),
                                        onmouseout: echarts.util.curry(hideTooltip, dataIndex),
                                        z: 100
                                    };
                                })
                            });
                        }, 0);

                        window.addEventListener('resize', updatePosition);
                    }

                    myChart.on('dataZoom', updatePosition);

                    function updatePosition() {
                        myChart.setOption({
                            graphic: echarts.util.map(data, function (item, dataIndex) {
                                return {
                                    position: myChart.convertToPixel('grid', item)
                                };
                            })
                        });
                    }

                    function showTooltip(dataIndex) {
                        myChart.dispatchAction({
                            type: 'showTip',
                            seriesIndex: 0,
                            dataIndex: dataIndex
                        });
                    }

                    function hideTooltip(dataIndex) {
                        myChart.dispatchAction({
                            type: 'hideTip'
                        });
                    }

                    function onPointDragging(dataIndex, dx, dy) {
                        data[dataIndex] = myChart.convertFromPixel('grid', this.position);

                        // Update data
                        myChart.setOption({
                            series: [{
                                id: 'a',
                                data: data
                            }]
                        });
                    }
                    ;
                    if (option && typeof option === "object") {
                        myChart.setOption(option, true);
                    }
                </script>
            </div>

<%--参考机型--%>
            <div id="dialog" class="easyui-dialog" data-options="border:'thin',modal:true,closed:true,buttons:'#job_dialog_buttons'">
                <div id="cc" class="easyui-layout" style="min-width:800px;height:400px;">
                    <div data-options="region:'west',split:true" style="width:190px;">
                        <div style="border-bottom: 1px solid #cdcdcd">
                            <table cellspacing="10" class="pxzn-dialog-font" >
                                <tr>
                                    <td><span class="pxzn-span-four">用途</span></td>
                                    <td>
                                        <select id="combox1" class="easyui-combobox" data-options="panelHeight:'auto'" name="dept" style="width:100px;">
                                            <option value="aa">商用飞机</option>
                                            <option>军用飞机</option>
                                            <option>运输飞机</option>
                                            <option>科学飞机</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="pxzn-span-four">子类</span></td>
                                    <td>
                                        <select id="combox2" class="easyui-combobox" data-options="panelHeight:'auto'" name="dept" style="width:100px;">
                                            <option value="aa">干线</option>
                                            <option>支线</option>
                                            <option>公务机</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <ul id="tree_2" class="easyui-tree">
                            <li>
                                <span>商用飞机.干线飞机</span>
                                <ul>
                                    <li>
                                        <span>波音</span>
                                        <ul>
                                            <li>
                                                <span>B737</span>
                                            </li>
                                            <li>
                                                <span>Leaf</span>
                                            </li>
                                            <li>
                                                <span>B787</span>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <span>空客</span>
                                        <ul>
                                            <li>
                                                <span>A320</span>
                                            </li>
                                            <li>
                                                <span>A380</span>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <span>苏霍伊</span>
                                        <ul>
                                            <li>
                                                <span>伊尔76</span>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <span>商飞</span>
                                        <ul>
                                            <li>
                                                <span>ARJ21</span>
                                            </li>
                                            <li>
                                                <span>C919</span>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>

                    </div>
                    <div data-options="region:'center'">
                        <div>
                            <table style="height: 200px">
                                <tr>
                                    <td style="width: 200px;border: 1px solid #cdcdcd" valign="top">
                                        <div style="width: 100%;height: 30px;">
                                            <ui class="ul-top">
                                                <li>
                                                    <span onclick="img_click('1')">产品图</span>
                                                </li>
                                                <li>
                                                    <span onclick="img_click('2')">3D模型</span>
                                                </li>
                                            </ui>
                                        </div>
                                        <div id="img_1" class="div_img">
                                            <img src="../../images/timg2.jpg" style="width: 391px">
                                        </div>
                                        <div id="img_2" class="div_img">
                                        </div>

                                    </td>
                                    <td style="width: 200px;border: 1px solid #cdcdcd" valign="top">
                                        <style>
                                            .ul-top{
                                                margin: 0;
                                                padding: 0;
                                            }
                                            .ul-top li{
                                                float: left;
                                                list-style-type: none;
                                                padding: 5px 15px;
                                            }
                                            .ul-top li span:hover{
                                                color: #0167cb;
                                                cursor: pointer;
                                            }
                                            .div_img{
                                                width: 391px;

                                            }
                                            .table_1{
                                              background: #cdcdcd;
                                            }
                                            .table_1 tr td{
                                                background: #fff;
                                                /*border: 1px solid #cdcdcd;*/
                                                /*border-color: #cdcdcd;*/
                                                width: 100px;
                                            }
                                            .table_1 .easyui-combobox{
                                                width: 100px;
                                                height: 20px;
                                            }
                                        </style>

                                        <div>
                                            <div style="width: 100%;height: 30px;">
                                                <ui class="ul-top">
                                                    <li>
                                                        <span onclick="img_click('3')">参数配置</span>
                                                    </li>
                                                    <li>
                                                        <span onclick="img_click('4')">飞机构型</span>
                                                    </li>
                                                </ui>
                                            </div>
                                            <div id="div_table_1">
                                                <table class="table_1" cellspacing="2" border="0" cellpadding="0" >
                                                    <tr>
                                                        <td>航程</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>通道</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>载客</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>翼展</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>机长</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>机高</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>国别</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>公司</td>
                                                        <td></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div id="div_table_2" style="display: none">
                                                <table class="table_1" cellspacing="2" border="0" cellpadding="0" >
                                                    <tr>
                                                        <td>翼面布局</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'">
                                                                <option value="aa">常规布局</option>
                                                                <option>鸭式布局</option>
                                                                <option>三翼面布局</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>机翼位置</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'" >
                                                                <option value="aa">上单翼</option>
                                                                <option>中单翼</option>
                                                                <option>下单翼</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>尾翼类型</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'" >
                                                                <option value="aa">常规型</option>
                                                                <option>T型</option>
                                                                <option>V型</option>
                                                                <option>Y型</option>
                                                                <option>H型</option>
                                                                <option>环型</option>
                                                            </select>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td>发动机安装位置</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'">
                                                                <option value="aa">翼下布局</option>
                                                                <option>翼上布局</option>
                                                                <option>翼跟布局</option>
                                                                <option>尾吊式布局</option>
                                                                <option>翼吊+尾吊</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>发动机个数</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'">
                                                                <option value="aa">1</option>
                                                                <option>2</option>
                                                                <option>3</option>
                                                                <option>4</option>
                                                                <option>6</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>起落架样式</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'">
                                                                <option value="aa">前三点</option>
                                                                <option>后三点</option>
                                                                <option>自行车式起落架</option>
                                                                <option>多支柱式起落架</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>国别</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'">
                                                                <option value="aa">中国</option>
                                                                <option>法国</option>
                                                                <option>美国</option>
                                                                <option>俄罗斯</option>
                                                                <option>乌克兰</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>公司</td>
                                                        <td>
                                                            <select class="easyui-combobox" name="dept" data-options="panelHeight:'auto'">
                                                                <option value="aa">波音</option>
                                                                <option>空客</option>
                                                                <option>苏霍伊</option>
                                                                <option>安东诺夫</option>
                                                                <option>中国商飞</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>


                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

<%--尾翼类型--%>
            <div id="dialog" class="easyui-dialog" data-options="border:'thin',modal:true,closed:true,buttons:'#job_dialog_buttons'">
                <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                    <input id="create_tNO" name="tNO"  type="hidden">
                    <tr>
                        <td><span class="pxzn-span-four">尾翼类型</span></td>
                        <td>
                            <select class="easyui-combobox pxzn-dialog-select" data-options="panelHeight:'auto'" name="dept" >
                                <option value="aa">常规型</option>
                                <option>T型</option>
                                <option>十字型</option>
                                <option>H型</option>
                                <option>H型</option>
                                <option>H型</option>
                                <option>H型</option>
                                <option>H型</option>
                                <option>H型</option>
                                <option>H型</option>


                            </select>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="a_3" style="display: none;width: 100%;height: 100%">

            <div id="user_dialog" class="easyui-dialog" data-options="border:'thin',modal:true,closed:true,buttons:'#user_dialog_buttons'" style="min-width:600px ;">

                <form id="user_dialog_form" method="post"  novalidate >

                    <table cellspacing="10" class="pxzn-dialog-font" style="margin:20px 50px;" >
                        <tr>
                            <td><span class="pxzn-span-four">飞机长度</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text" data-options="precision:10">
                            </td>
                            <td><span class="pxzn-span-four pxzn-text-margin-left">发动机间距</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                        </tr>
                        <tr>
                            <td><span class="pxzn-span-four">飞机宽度</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                            <td><span class="pxzn-span-four pxzn-text-margin-left">前主轮距</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                        </tr>
                        <tr>
                            <td><span class="pxzn-span-four">飞机高度</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                            <td><span class="pxzn-span-four pxzn-text-margin-left">主轮距</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                        </tr>
                        <tr>
                            <td><span class="pxzn-span-four">机身长度</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                            <td><span class="pxzn-span-four pxzn-text-margin-left">平尾参考面积</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                        </tr>
                        <tr>
                            <td><span class="pxzn-span-four">机翼参考面积</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                            <td><span class="pxzn-span-four pxzn-text-margin-left">垂尾参考面积</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                        </tr>
                        <tr>
                            <td><span class="pxzn-span-four">翼展</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                            <td><span class="pxzn-span-four pxzn-text-margin-left">展弦比</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                        </tr>
                        <tr>
                            <td><span class="pxzn-span-four">稍根比</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                            <td><span class="pxzn-span-four pxzn-text-margin-left">1/4弦线后掠角</span></td>
                            <td>
                                <input name="userId" class="easyui-numberbox pxzn-dialog-text">
                            </td>
                        </tr>
                    </table>
                </form>
                <div id="user_dialog_buttons" class="pxzn-dialog-buttons">
                    <input type="button" onclick="user_dialog_ok()" value="保存" class="pxzn-button">
                    <input type="button" onclick="user_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
                </div>
            </div>


        </div>
        <div id="a_4" style="display: none;width: 100%;height: 100%">

            <div  class="easyui-dialog" data-options="border:'thin',modal:true,closed:false,buttons:'#dialog_buttons3'" style="min-width:600px ;">
                <ui class="ul-top" style="position: absolute;background: #fff;z-index: 9;border-bottom: 1px solid #cdcdcd;width: 100%;">
                    <li>
                        <span onclick="img_click('5')">总体参数</span>
                    </li>
                    <li>
                        <span onclick="img_click('6')">重量清单</span>
                    </li>
                </ui>
                <div id="div_5" style="height: 460px;margin-top: 29px">
                    <form  method="post"  novalidate >

                        <table cellspacing="10" class="pxzn-dialog-font" >
                            <tr>
                                <td><span class="pxzn-span-four">重量(kg)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">密度(kg/m^3)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">重心(mm)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">重心X(mm)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox " style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">重心Y(mm)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">重心Z(mm)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">转动惯量Ix(kgm^2)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">转动惯量Iy(kgm^2)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:true">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">转动惯量Iz(kgm^2)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">惯性积Ixy(kgm^2)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">惯性积Iyz(kgm^2)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>
                            <tr>
                                <td><span class="pxzn-span-four">惯性积Izx(kgm^2)</span></td>
                                <td>
                                    <input name="userId" class="easyui-numberbox pxzn-dialog-text" style="width: 400px" data-options="precision:10">
                                </td>
                            </tr>



                        </table>
                    </form>
                </div>
                <div id="div_6" style="display:none;width: 500px;height: 500px">

                </div>

                <div id="dialog_buttons3" class="pxzn-dialog-buttons">
                    <input type="button" onclick="user_dialog_ok()" value="保存" class="pxzn-button">
                    <input type="button" onclick="user_dialog_close()" value="取消" style="margin-left:40px;" class="pxzn-button">
                </div>
            </div>


        </div>
    </div>

</div>

</body>
</html>
