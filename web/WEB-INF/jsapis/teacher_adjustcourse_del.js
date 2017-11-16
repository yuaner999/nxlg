/**
 * Created by NEU on 2017/6/5.
 */
function main(context) {
    var result=exec(function(){/*
        delete from manualadjustcourse where mac_id=${mac_id}
     */},context);
    return result;
}