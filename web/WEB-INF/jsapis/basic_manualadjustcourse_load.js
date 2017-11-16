/**
 * Created by NEU on 2017/6/5.
 */
function main(context) {
    var result=querypagedata(function(){/*
    select manualadjustcourse.*,course.chineseName,FROM_UNIXTIME(UNIX_TIMESTAMP(manualadjustcourse.settime),'%Y-%m-%d %H:%i:%s') as settime
     ,teacher.teacherName,classroomName
    from manualadjustcourse
    left join course on course.courseId=manualadjustcourse.courseId
     left join teacher on manualadjustcourse.now_teachName =teacher.teacherId
     left join classroom on classroom.classroomId=manualadjustcourse.now_room
     where (class LIKE CONCAT('%',${searchStr},'%')
     or odd_teachName LIKE CONCAT('%',${searchStr},'%')
     or now_teachName LIKE CONCAT('%',${searchStr},'%')
     or chineseName LIKE CONCAT('%',${searchStr},'%')
     or now_room LIKE CONCAT('%',${searchStr},'%')
     or type LIKE CONCAT('%',${searchStr},'%'))
     and  (odd_teachweek LIKE CONCAT('%',${week1},'%') or now_teachweek LIKE CONCAT('%',${week1},'%'))
     and now_timeweek LIKE CONCAT('%',${week2},'%')
     and now_timepitch LIKE CONCAT('%',${week3},'%')
    order by settime desc;
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[{
    week1:'',
    week2:'',
    week3:'',
    searchStr:''
}];
