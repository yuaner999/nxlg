
function postform(url,formdata){
    return net.postForm(url,formdata);
}
function getform(url,urlparams){
    return net.getForm(url,urlparams);
}
function poststring(url,params){
    return net.postString(url,params);
}
function postfile(url,filepath,formdata){
    return net.postFile(url,filepath,formdata);
}