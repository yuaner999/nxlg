/**
 * Created by NEU on 2017/6/3.
 */
function main(context) {
    var r= query(function () {/*
    select *, FROM_UNIXTIME(UNIX_TIMESTAMP(manualadjustcourse.settime),'%Y-%m-%d %H:%i:%s') as settime,teacher.teacherName,classroomName
    from manualadjustcourse
    left join teacher on manualadjustcourse.now_teachName =teacher.teacherId
    left join classroom on classroom.classroomId=manualadjustcourse.now_room
    where tc_id=${tc_id} and type='调课'
     */},context,"");
    return r;
}