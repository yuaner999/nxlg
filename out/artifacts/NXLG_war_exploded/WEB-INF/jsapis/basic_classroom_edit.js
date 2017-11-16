/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    //基础数据非空判断
    if(context.classroomId == null||context.campus == null||context.building == null||context.floor == null||context.classroomNum == null||context.classroomName == null||
        context.classroomType == null||context.classroomCapacity == null||context.classroomArea == null||context.classroomStatus == null
        ||context.classroomUnit == null||context.minCapacityRate == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.classroomCapacity)){
        return false;
    }
    var result=exec(function(){/*
     UPDATE
     `classroom`
     SET
     `campus` = ${campus},
     `building` = ${building},
     `floor` = ${floor},
     `classroomNum` = ${classroomNum},
     `classroomName` = ${classroomName},
     `classroomType` = ${classroomType},
     `classroomCapacity` = ${classroomCapacity},
     `classroomArea` = ${classroomArea},
     `classroomStatus` = ${classroomStatus},
     `classroomUnit` = ${classroomUnit},
     `updateMan` = ${sessionUserName},
     `updateDate` = NOW(),
     `minCapacityRate`=${minCapacityRate}
     WHERE `classroomId` = ${classroomId}
    */},context);
    return result;
}
