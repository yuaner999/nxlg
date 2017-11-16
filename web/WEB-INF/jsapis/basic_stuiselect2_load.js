/**
 * Created by NEU on 2017/5/22.
 */
function main(context) {
    var semester=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=semester[0].semester;
    //是否达到开课人数
    var t= query(function () {/*
     select count(studentId) as countstudentId  from stuchoosecourse
     where courseId=${courseId} and class=${tc_class}  and term=${term}
     */},context,"");
    var tc_studentnum=query(function () {/*
     select tc_studentnum from teachtask where tc_courseid=${courseId} and tc_class=${tc_class}
     */}, context,"");
    if(t.length>0){
        if(parseInt(t[0].countstudentId)>=parseInt(tc_studentnum[0].tc_studentnum)){
            //console(parseInt(t[0].countstudentId)+"与"+parseInt(tc_studentnum[0].tc_studentnum));
            return {result: true};
        }else{
            return { result:false }
        }
    }else{
        return {result:false}
    }
}
var inputsamples=[{
    courseId:'1597f967-5bd6-4ca8-8fd7-95ad688970f3',
    tc_class:'英语1班'
}]