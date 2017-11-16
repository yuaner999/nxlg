/**
 * Created by liuzg on 2017/2/22.
 */
function main(context) {
    // return [
    //            {goodname:"a",gooddesp:"aaaa"},
    //            {goodname:"a2",gooddesp:"aaaa2"},
    //            {goodname:"a3",gooddesp:"aaaa3"},
    //        ]
    return query("select * from sp_good",context,"");
}