/**
 * Created by gq on 2017/6/1.
 */
function main(context) {
    //加载专业
    var result = query(function () {/*
     SELECT * FROM class WHERE 1=1
     and case when ${gradeName} is not null and ${gradeName}<>'' then  gradeName=${gradeName} else 1=1 end
     */},context,"");
    return result;
}