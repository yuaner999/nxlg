/**
 * Created by NEU on 2017/6/9.
 */
function main(context) {
    var t=query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    context.studentId=t[0].studentId;
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    var r= query(function () {/*
        select * from stuchoosecourse
        where studentId=${studentId} and term=${term} and ((iscomfirm='0' or iscomfirm is null) or istiaojicomfirm='2')
    */},context,"");
    if(r.length>0){
        return {result:true};
    }else {
        var n=query(function () {/*
         SELECT cantiaoji,tiaojiterm
         FROM `nxlg`.`student`
         where student.studentId=${studentId} and tiaojiterm=${term} and cantiaoji='1'
         */},context,"");
        if(n.length>0){
            return {result:true};
        }else{
            //这里在加上调剂申请的人
            var ff= query(function () {/*
             select * from transferapply
             where studentId=${studentId} and term=${term} and status='已通过'
             */},context,"");
            if(ff.length>0){
                return {result:true};
            }else{
                return {result:false};
            }
        }
    }
}