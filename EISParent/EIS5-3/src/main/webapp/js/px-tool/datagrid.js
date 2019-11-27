    /**
     * 设置列字段
     */
    function setDatagridField(px_id,data){
        if(data == null){
            return;
        }
        var colums = [];
        colums.push({field:'cb', title:'', checkbox:'true', align:'center'});
        for(var i = 0;i<data.length;i++){
            var columsObject = {};
            columsObject.field = data[i].id;
            columsObject.title = data[i].name;
            columsObject.width = 50;
            columsObject.align = 'center';
            colums.push(columsObject);
        }
        $('#'+px_id).datagrid({
            columns:[colums],
            rownumbers:true//行号

        });
    }