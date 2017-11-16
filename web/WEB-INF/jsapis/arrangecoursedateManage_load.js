/**
 * Created by NEU on 2017/4/19.
 */
function main(context) {
    //加载、查询排课信息
    var result = querypagedata(function () {/*
     SELECT *,CASE WHEN is_now=TRUE THEN 'true' ELSE 'false' END  AS is_now FROM arrangecourse
     WHERE
     semester LIKE concat('%',${searchStr},'%')
     order by convert(semester USING gbk)
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[
    {
        searchStr:''
    }
    ]