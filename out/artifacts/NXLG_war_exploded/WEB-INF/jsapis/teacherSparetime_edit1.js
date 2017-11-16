/**
 * Created by NEU on 2017/4/28.
 * 修改教师空余时间+最多上课节数
 */
function main(context) {
        //数据非空判断
        if(context.teacherId == null){
                return false;
        }
        var con=createconnection();
        for(var i=0;i<context.teacherIds.length;i++) {
                context.teacherId = context.teacherIds[i];
                var r = exec(function () {/*
                UPDATE
                `teacher`
                SET
                `scheduleTime` = ${node},
                `nonscheduleTime` = ${node1},
                 `spareTime` = ${spareTime},
                 `mostClasses` = ${mostClasses}
                WHERE teacherId=${teacherId}
                */}, context);
                if(!r){
                        rollback(con);
                        closeconnection(con);
                        return false;
                }
        }
        commit(con);
        closeconnection(con);
        return true;
}
