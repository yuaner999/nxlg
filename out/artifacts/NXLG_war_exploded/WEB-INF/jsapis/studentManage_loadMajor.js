/**
 * Created by NEU on 2017/4/20.
 */
function main(context) {
    //加载专业
    var result = query(function () {/*
     SELECT `majorName` FROM `major` WHERE 1=1
     and case when ${majorCollege} is not null and ${majorCollege}<>'' then  majorCollege=${majorCollege} else 1=1 end
     AND  (`major`.`checkStatus` = '已通过') AND (ISNULL(`major`.`isDelete`) OR (`major`.`isDelete` = '否'))
     */},context,"");
    return result;
}