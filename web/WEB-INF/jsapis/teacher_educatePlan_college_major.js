function main(context){

    var selcol = context.selcol;

    var selmajorInf = query(function(){/*
    SELECT `majorId`, `majorName` FROM `major` WHERE 1=1
     AND CASE WHEN ${selcol} IS NOT NULL AND ${selcol}<>'' THEN  majorCollege=${selcol} ELSE 1=1 END
     AND  (`major`.`checkStatus` = '已通过') AND (ISNULL(`major`.`isDelete`) OR (`major`.`isDelete` = '否'))
    */},{selcol:selcol},"")

    if(selmajorInf.length == 0){
        return {result:false,errormessage:"没有查询到相关专业信息"}
    }

    return {result:true,_sel_major:selmajorInf}
}