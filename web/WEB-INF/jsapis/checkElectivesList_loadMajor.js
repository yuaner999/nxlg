/**
 * Created by NEUNB_Lisy on 2017/6/6.
 */
function  main(context) {
    var result=querypagedata(function () {/*
           SELECT *
           FROM `nxlg`.`major`
           WHERE
           (isDelete is null or isDelete='否')
           AND checkStatus='已通过'
           AND (
             majorCollege LIKE CONCAT('%',${searchStr},'%')
             or majorName LIKE CONCAT('%',${searchStr},'%')
             or subject LIKE CONCAT('%',${searchStr},'%')
           )
     order by convert(majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}