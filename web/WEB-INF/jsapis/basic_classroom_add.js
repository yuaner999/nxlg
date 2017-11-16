/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    //基础数据非空判断
    if(context.campus == null||context.building == null||context.floor == null||context.classroomNum == null||context.classroomName == null||
        context.classroomType == null||context.classroomCapacity == null||context.classroomArea == null||context.classroomStatus == null
        ||context.classroomUnit == null||context.minCapacityRate == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.classroomCapacity)){
        return false;
    }
    var result=exec(function(){/*
     INSERT INTO `classroom` (
     `classroomId`,
     `campus`,
     `building`,
     `floor`,
     `classroomNum`,
     `classroomName`,
     `classroomType`,
     `classroomCapacity`,
     `classroomArea`,
     `classroomStatus`,
     `classroomUnit`,
     `createMan`,
     `createDate`,
     minCapacityRate
     )
     VALUES(UUID(),${campus},${building},${floor},${classroomNum},${classroomName},${classroomType},${classroomCapacity},${classroomArea},${classroomStatus},${classroomUnit},${sessionUserName},NOW(),${minCapacityRate})
    */},context);
    return result;
}
