/**
 * Created by NEU on 2017/4/28.
 */
function main(context) {
    //数据非空判断
    if(context.terraceId == null ||context.majorId == null){
        return false;
    }
    //专业平台课程设置
    var valid=query(function(){/*
     SELECT * FROM `majorterracecourse` WHERE `majorId`=${majorId} and `terraceId`=${terraceId} and  `courseId`=${courseId}
     and mtc_grade=${ep_grade} and `mtc_courseTerm`=${mtc_courseTerm} and (mtc_isDelete IS NULL OR mtc_isDelete="否")
     */},context,""); console(valid);
    if(valid==null||valid.length<1){
        var rr = exec(function () {/*
         insert into `majorterracecourse` (`mtc_id`, `majorId`, `terraceId`,`courseId`,mtc_grade,`mtc_courseTerm`, `mtc_majorWay`,`mtc_note`,
         `mtc_checkStatus`,`mtc_checkType`, `mtc_setman`,`mtc_settime`)
         values (UUID(), ${majorId},${terraceId}, ${courseId},${ep_grade},${mtc_courseTerm}, ${mtc_majorWay},${mtc_note},"待审核","新增", ${sessionUserName}, NOW() );
         */}, context);
        if(rr){
            var r = exec(function () {/*
             UPDATE  `educateplane`
             SET
             `ep_isset` = "1"  WHERE `ep_id` = ${ep_id}
             */}, context);
            return r;
        }else{
            return false;
        }
    }else{return 0;}
   
    
}
var inputsamples=[{
    terraceId:"11fd3def8-2415-11e7-be40-00ac9c2c0afa1",
    majorId:"d795fafd-0e07-11e7-843d-00ac9c2c0afa",

}]