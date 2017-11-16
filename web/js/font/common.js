//改变分页选中样式的变化
function changeSelect() {
	$(".pageNumber").removeClass('sele').eq(pageNum-1).addClass("sele");
}

//图片上传，无预览
function fileupload(url,tag,callback,errorcallback){
	$.upload({
		url: url+"?tag="+tag,
		fileName: 'filedata',
		params: {},
		dataType: 'json',
		onSend: function() {
			return true;
		},
		onComplate: function(data) {
			if(callback) callback(data)
		}
	});
}
//图片上传，可预览
function imguploadandpreview(imgselector,tag,callback,errorcallback){
	$.upload({
		url: pagecontextpath+"/imgupload.form?tag="+tag,
		fileName: 'filedata',
		params: {},
		dataType: 'json',
		onSend: function() {
			return true;
		},
		onComplate: function(data) {
			$(imgselector).attr("src",serverimg(data.fid));
			if(callback) callback(data)
		}
	});
}
//预览图片
function serverimg(imgid){
	return pagecontextpath+"/imgdown.form?imgid="+imgid;
}
function showmsgpc(str){
	layer.msg(str,{time:2000,offset:window.height/2+'px'});
}

function GetQueryString(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)","i");
	var r = window.location.search.substr(1).match(reg);
	if (r!=null) return (r[2]); return null;
}