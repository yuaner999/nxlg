/**
 * Created by NEU on 2017/6/3.
 */
function main(context) {
    //基础数据非空判断
    if(context.tc_id == null||context.courseId == null||context.class == null||context.now_timepitch == null
        ||context.odd_teachName == null||context.now_timeweek == null||context.odd_teachweek == null||context.odd_week == null
        ||context.now_teachweek == null||context.now_teachName == null||context.odd_pitch == null){
        return false;
    }
    //调课周是否正确
    var week=query(function () {/*
     SELECT tc_thweek_start,tc_thweek_end,al_timeweek,al_timepitch,tc_teachodd
     FROM teachtask
     INNER JOIN arrangelesson ON arrangelesson.tc_id = teachtask.tc_id
     where teachtask.tc_id=${tc_id}
     */},context,"");
     for(var w=0;w<week.length;w++){
         if(parseInt(week[w].tc_thweek_start)<=parseInt(context.odd_teachweek)&&parseInt(context.odd_teachweek)<=parseInt(week[w].tc_thweek_end)){
             if((week[w].tc_teachodd=="单周"&&parseInt(context.odd_teachweek)%2==1 )||(week[w].tc_teachodd=="双周"&&parseInt(context.odd_teachweek)%2==0)||(week[w].tc_teachodd=="无"))
             {  if(parseInt(week[w].al_timepitch)==parseInt(context.odd_pitch)&&parseInt(week[w].al_timeweek)==parseInt(context.odd_week)){
                 break;
             }
             }
         }
         if(w==week.length-1){
             return{ result:false,message:'您选择的调整周不在原上课时间内'};
         }
     }
    //查找这个教师他的课表冲不冲突
    var n=query(function () {/*
     SELECT tc_thweek_start,tc_thweek_end,al_timeweek,al_timepitch,tc_teachodd
     FROM teachtask
     INNER JOIN arrangelesson ON arrangelesson.tc_id = teachtask.tc_id
    where tc_classteacherid=${now_teachName} and teachtask.tc_id!=${tc_id}
    */},context,"");
    for (var i=0;i<n.length;i++){
        if(parseInt(n[i].tc_thweek_start)<=parseInt(context.now_teachweek)&&parseInt(context.now_teachweek)<=parseInt(n[i].tc_thweek_end)){
            if((n[i].tc_teachodd=="单周"&&context.now_teachweek%2==1 )||(n[i].tc_teachodd=="双周"&&context.now_teachweek%2==0)||n[i].tc_teachodd=="无"){
                if(n[i].al_timeweek==context.now_timeweek&&n[i].al_timepitch==context.now_timepitch){
                    return{ result:false,message:'教师时间冲突'};
                }
            }
        }
    }
    var n2=query(function () {/*
     SELECT now_teachweek,now_timeweek,now_timepitch
     FROM manualadjustcourse
     where now_teachName=${now_teachName} and now_teachweek=${now_teachweek} and now_timeweek=${now_timeweek} and now_timepitch=${now_timepitch}
     */},context,"now_teachweek,now_timeweek,now_timepitch");
    if(n2.length>0){
        return{ result:false,message:'教师时间冲突了'};
    }
    //查教室冲突
    var room=query(function () {/*
     SELECT tc_thweek_start,tc_thweek_end,al_timeweek,al_timepitch,tc_teachodd
     FROM teachtask
     INNER JOIN arrangelesson ON arrangelesson.tc_id = teachtask.tc_id
     where classroomId=${now_room} and teachtask.tc_id!=${tc_id}
     */},context,"");
    for (var i=0;i<room.length;i++){
        if(parseInt(room[i].tc_thweek_start)<=parseInt(context.now_teachweek)&&parseInt(context.now_teachweek)<=parseInt(room[i].tc_thweek_end)){
            if((room[i].tc_teachodd=="单周"&&context.now_teachweek%2==1 )||(room[i].tc_teachodd=="双周"&&context.now_teachweek%2==0)||room[i].tc_teachodd=="无"){
                if(room[i].al_timeweek==context.now_timeweek&&room[i].al_timepitch==context.now_timepitch){
                    return{ result:false,message:'教室时间冲突'};
                }
            }
        }
    }
    var room2=query(function () {/*
     SELECT now_teachweek,now_timeweek,now_timepitch
     FROM manualadjustcourse
     where now_room=${now_room} and now_teachweek=${now_teachweek} and now_timeweek=${now_timeweek} and now_timepitch=${now_timepitch}
     */},context,"");
    if(room2.length>0){
        return{ result:false,message:'教室时间冲突了'};
    }
    var rr = exec(function () {/*
     INSERT INTO `nxlg`.`manualadjustcourse` (`mac_id`, `tc_id`,`courseId`, `class`,`odd_teachweek`, `odd_teachName`, `now_teachweek`, `now_timeweek`, `now_timepitch`, `now_teachName`, `now_room`, `type`, `settime`,odd_pitch,odd_week)
     VALUES(uuid(),${tc_id},${courseId},${class},${odd_teachweek},${odd_teachName},${now_teachweek},${now_timeweek},${now_timepitch},${now_teachName},${now_room}, '调课',NOW(),${odd_pitch},${odd_week}) ;
     */}, context);
    return{ result:rr};
}

inputsamples=[{
    tc_id:'M2',
    courseId:'f188bfb3-3d2d-4eeb-a144-29f2990b04ca',
    class:'美术2班',
    now_timepitch:'1',
    odd_teachName:'test',
    now_timeweek:'1',
    odd_teachweek:11,
    now_teachweek:19,
    now_teachName:'f5450b1f-3bd1-4e43-aff1-80f93f5e905b',
    now_room:'e817cf1c-0aab-11e7-ab6a-00ac2794c53f',
    odd_week:1,
    odd_pitch:1
}]
