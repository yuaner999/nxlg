/**
 * Created by liuzg on 2017/2/22.
 */
var baseurl=pagecontextpath+"/jsons/";
function remotecallasync(apiname,params,callback,errorcallback){
    var url0 = baseurl+apiname+".form";
    $.ajax({
        type:"POST",
        url:url0,
        data:params,
        // data:JSON.stringify(params),
        dataType:'json',
        // contentType:"application/json; charset=utf-8",
        success:function(data){
            if(callback) callback(data);
        },
        error:function(){
            if(errorcallback) errorcallback();
        },
        async:true
    });
}

function remotecall(apiname,params){
    var url0 = baseurl+apiname+".form";
    var result = null;
    $.ajax({
        type:"POST",
        url:url0,
        // data:JSON.stringify(params),
        data:params,
        dataType:'json',
        // contentType:"application/json; charset=utf-8",
        success:function(data){
            result = data;
        },
        error:function(){

        },
        async:false
    });
    return result;
}