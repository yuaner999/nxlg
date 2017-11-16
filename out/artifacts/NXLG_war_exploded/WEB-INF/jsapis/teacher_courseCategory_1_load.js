/**
 * Created by NEU on 2017/5/18.
 */
function main(context) {
    var r=query(function(){/*
     select courseCategory_1
     from  educateplane
     left join terrace on terrace.terraceName=educateplane.ep_terrace
     where ep_major=${ep_major} and ep_courseid=${courseId} and terrace.terraceId=${terraceId}
     and ep_grade=${ep_grade} and ep_checkStatus='已通过' and (ep_isDelete IS NULL OR ep_isDelete="否")
     */}, context,"");
    return {total: r.length,rows:r};
}
var inputsamples=[{
    ep_major:'体育1',
    courseId:'4df105c9-5f4b-4dd6-b886-8eb63de437a9',
    terraceId:'f2be64fb-24c4-11e7-942b-00ac9c2c0afa'
}]