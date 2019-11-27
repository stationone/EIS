/**
 * EasyUi
 * 公共方法
 */
    /**
     * easyui-layout隐藏
     * 根据条件隐藏区域
     * 传入layout的ID和需要隐藏的区域
     * @param layoutId
     * @param region 可用的值：'north'、'south'、'east'、'west'
     */
    function layoutHide(layoutId, region){
        $('#'+layoutId).layout('collapse', region);
    }