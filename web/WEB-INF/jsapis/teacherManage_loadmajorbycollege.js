/**
 * Created by gq on 2017/5/27.
 * 根据学院加载该学院下的所有专业
 */
function main(context) {
    //加载专业
    var result = query(function () {/*
     SELECT * FROM `major` WHERE 1=1
     and case when ${teachCollege} is not null and ${teachCollege}<>'' then  majorCollege=${teachCollege} else 1=1 end
     AND  (`major`.`checkStatus` = '已通过') AND (ISNULL(`major`.`isDelete`) OR (`major`.`isDelete` = '否'))
     */},context,"");
    return result;
}