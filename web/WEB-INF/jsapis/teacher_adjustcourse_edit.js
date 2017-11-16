/**
 * Created by NEU on 2017/6/3.
 */
function main(context) {

//基础数据非空判断
    if(context.tc_id == null||context.now_timepitch == null
        ||context.now_timeweek == null||context.odd_teachweek == null||context.now_teachweek == null||context.now_teachName == null
        ||context.now_room == null||context.odd_week == null||context.odd_pitch == null||context.mac_id == null){
        return{ result:false,message:'非空'};
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
     where tc_classteacherid=${now_teachName}and teachtask.tc_id!=${tc_id}
     */},context,"tc_thweek_start,tc_thweek_end,al_timeweek,al_timepitch,tc_teachodd");
    // console(n) ;
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
     and mac_id!=${mac_id}
     */},context,"");
    if(n2.length>0){
        return{ result:false,message:'教师时间冲突了'};
    }
    //查教室冲突
    var room=query(function () {/*
     SELECT tc_thweek_start,tc_thweek_end,al_timeweek,al_timepitch,tc_teachodd
     FROM teachtask
     INNER JOIN arrangelesson ON arrangelesson.tc_id = teachtask.tc_id
     where classroomId=${now_room} and teachtask.tc_id!=${tc_id}
     */},context,"tc_thweek_start,tc_thweek_end,al_timeweek,al_timepitch,tc_teachodd");
    for (var j=0;j<room.length;j++){
        if(parseInt(room[j].tc_thweek_start)<=parseInt(context.now_teachweek)&&parseInt(context.now_teachweek)<=parseInt(room[j].tc_thweek_end)){
            if((room[j].tc_teachodd=="单周"&&context.now_teachweek%2==1 )||(room[j].tc_teachodd=="双周"&&context.now_teachweek%2==0)||room[j].tc_teachodd=="无"){
                if(room[j].al_timeweek==context.now_timeweek&&room[j].al_timepitch==context.now_timepitch){
                    return{ result:false,message:'教室时间冲突'};
                }
            }
        }
    }
    var room2=query(function () {/*
     SELECT now_teachweek,now_timeweek,now_timepitch
     FROM manualadjustcourse
     where now_room=${now_room} and now_teachweek=${now_teachweek} and now_timeweek=${now_timeweek} and now_timepitch=${now_timepitch}
     and mac_id!=${mac_id}
     */},context,"");
    if(room2.length>0){
        return{ result:false,message:'教室时间冲突了'};
    }
    var rr = exec(function () {/*
     UPDATE
     `nxlg`.`manualadjustcourse`
     SET
     `odd_teachweek` = ${odd_teachweek},
     `now_teachweek` =${now_teachweek},
     `now_timeweek` =${now_timeweek},
     `now_timepitch` =${now_timepitch},
     `now_teachName` =${now_teachName},
     `now_room` =${now_room},
     `odd_week`=${odd_week},
     `odd_pitch`=${odd_pitch},
     `settime` = NOW()
     WHERE `mac_id` = ${mac_id};
     */}, context);
    return {result:rr};
}
var inputsamples=[{
    tc_id:'Y1',
    tc_grade:'2013|2014|2015',
    now_timepitch:2,
    odd_teachName:'test',
    now_timeweek:7,
    odd_teachweek:2,
    now_teachweek:11,
    now_teachName:'1ae1dd7d-a458-40bd-b61f-4c1968bbbca6',
    now_room:'e08682f0-1086-11e7-bdbc-00ac9c2c0afa',
    odd_week:1,
    odd_pitch:1,
    mac_id:'ef66cdda-4b30-11e7-a96a-00ac9c2c0afa'
}]
