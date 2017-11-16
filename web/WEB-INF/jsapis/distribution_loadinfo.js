/**
 * Created by gq on 2017/6/1.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT * FROM bookdistribution_info
      WHERE 1=1
     and case when (${searchStr} is not null and ${searchStr}<>"") then className like concat ('%',${searchStr},'%') else 1=1 end
     and case when (${is_giveout} is not null and ${is_giveout}<>"") then is_giveout = ${is_giveout} else 1=1 end
     and case when (${semester} is not null and ${semester}<>"") then semester = ${semester} else 1=1 end
     and case when (${semester} is  null or ${semester}="") then is_now = "是" else 1=1 end
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[
    {
        collegeName:'美术学院'
    }
]