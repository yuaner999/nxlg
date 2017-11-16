/**
 * Created by NEU on 2017/9/19.
 * user : songjian
 */
function main(context){
    var flag = context.v;
    //如果v等于_college，查询学院信息
    if(flag == "_college"){
        //查询学院信息
        var collegeNameAll = query(function(){/*
            SELECT DISTINCT(wordbookValue) FROM wordbook WHERE wordbookKey='学院'
        */},context,"");

        //如果没有学院
        if(collegeNameAll.length == 0){
            return {reslut:false,errormessage:"没有查找到相关学院"};
        };
        //如果有学院
        return {result:true,_select_college1:collegeNameAll};
    };
}