/**
 * Created by liuzg on 2017/2/22.
 */
var baseurl = pagecontextpath+"/";//基础路径

/**
 * 异步Ajax请求
 * @param apiname:请求名称
 * @param params:参数
 * @param callback:成功回调函数
 * @param errorcallback:失败回调函数
 */
function remotecallasync(apiname,params,callback,errorcallback){
    var url0 = baseurl + apiname + ".form?t="+new Date().getTime();
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
        error:function(data){
            if(errorcallback) errorcallback(data);
        },
        async:true
    });
}

/**
 * Ajax同步请求
 * @param apiname
 * @param params
 * @returns {*}
 */
function remotecall(apiname,params,callback,errorcallback){
    var url0 = baseurl + apiname + ".form?t="+new Date().getTime();
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
        error:function(data){
            if(errorcallback) errorcallback(data);
        },
        async:false
    });
}

/**
 * 表单序列化
 * @returns {{}}
 */
$.fn.serializeObject = function ()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function ()
    {
        if (o[this.name])
        {
            if (!o[this.name].push)
            {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else
        {
            o[this.name] = this.value || '';
        }
    });
    return o;
}