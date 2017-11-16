/**
 * Created by NEU on 2017/6/3.
 */
function main(context) {
    var r= query(function () {/*
     select *, FROM_UNIXTIME(UNIX_TIMESTAMP(manualadjustcourse.settime),'%Y-%m-%d %H:%i:%s') as settime from manualadjustcourse
     where tc_id=${tc_id} and type='停课'
     */},context,"");
    return r;
}