/**
 * Created by NEU on 2017/4/21.
 */
function main(context) {
    //加载、查询教材信息
    var result = querypagedata(function () {/*
     SELECT * FROM teachingmaterials
     WHERE
     isdelete !='1'
     AND (name LIKE concat('%',${searchStr},'%'))
     order by convert(name USING gbk)
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[
    {
        searchStr:""
    }
]