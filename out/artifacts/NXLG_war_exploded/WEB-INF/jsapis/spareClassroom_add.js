/**
 * Created by NEU on 2017/4/26.
 * 新增空教室信息
 */
function main(context){
    //基础数据非空判断
    if(context.week == null||context.weekday == null||context.classes == null||context.classtype == null||context.num == null){
        return false;
    }
    var r=query(function () {/*
        select scId from spareclassroom where week=${week} and weekday=${weekday} and classes=${classes}
    */},context,"");
    if(r.length>0){
        return 2;
    }
    var result=exec(function(){/*
     INSERT INTO `spareclassroom` (
     `scId`,
     `week`,
     `weekday`,
     `classes`,
     `classtype`,
     `num`
     ) 
     VALUES(UUID(),${week},${weekday},${classes},${classtype},${num})
     */},context);
    return result;
}
