/**
 * Created by gq on 2017/6/2.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT `name`,SUM(booktotalnum) as booktotalnum FROM bookdistribution_info
     where 1=1
     and case when (${className} is not null and ${className}<>"") then className = ${className} else 1=1 end
     GROUP BY bookid
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[
    {
        collegeName:'计算机学院'
    }
]