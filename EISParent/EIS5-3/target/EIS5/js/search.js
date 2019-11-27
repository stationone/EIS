$(function () {

    //显示登陆用户名
    //showName();
    //获取菜单数据
    $.ajax({
        url: 't',
        type: 'post',
        dataType: 'json',
        success: function (rtn) {
            //给菜单赋值
            _menus = rtn;
            InitLeftMenu();
        }
    });
    tabClose();
    tabCloseEven();
})


//初始化左侧
function InitLeftMenu() {
    $("#nav").accordion({animate: false, fit: true, border: false});
    var selectedPanelname = '';

    $.each(_menus.menus, function (i, n) {
        var menulist = '';
        menulist += '<ul class="navlist">';
        $.each(n.menus, function (j, o) {
            menulist += '<li><div ><a ref="' + o.menuid + '" href="#" rel="' + o.url + '" ><span class="icon ' + o.icon + '" >&nbsp;</span><span class="nav">' + o.menuname + '</span></a></div> ';

            menulist += '</li>';
        })
        menulist += '</ul>';

        $('#nav').accordion('add', {
            title: n.menuname,
            content: menulist,
            border: false,
            iconCls: 'icon ' + n.icon
        });

        /*if (i == 0)
            selectedPanelname = n.menuname;*/

    });

    $('#nav').accordion('select', selectedPanelname);


    $('.navlist li a').click(function () {
        var tabTitle = $(this).children('.nav').text();

        var url = $(this).attr("rel");
        var menuid = $(this).attr("ref");
        var icon = $(this).find('.icon').attr('class');

        var third = find(menuid);
        if (third && third.child && third.child.length > 0) {
            $('.third_ul').slideUp();

            var ul = $(this).parent().next();
            if (ul.is(":hidden"))
                ul.slideDown();
            else
                ul.slideUp();


        }
        else {
            addTab(tabTitle, url, icon);
            $('.navlist li div').removeClass("selected");
            $(this).parent().addClass("selected");
        }
    }).hover(function () {
        $(this).parent().addClass("hover");
    }, function () {
        $(this).parent().removeClass("hover");
    });


    //选中第一个
    //var panels = $('#nav').accordion('panels');
    //var t = panels[0].panel('options').title;
    //$('#nav').accordion('select', t);
}