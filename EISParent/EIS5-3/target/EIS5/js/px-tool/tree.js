/**
 * 设置Easyui-tree树数据
 * @param px_id
 * @param data
 */
function setTreeValue(px_id, data){
    $('#'+px_id).tree({
        data:data
    })
}