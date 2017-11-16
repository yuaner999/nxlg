/**
 * Created by Administrator on 2017/1/1.
 */
function createfile(filepath) {
    return file.createFile(filepath);
}

function listfiles(dir) {
    return file.listFiles(dir);
}

function listfileitems(dir) {
    return file.listFileItems(dir);
}

function searchFiles(dir, keyword) {
    return file.searchFiles(dir,keyword);
}

function mkdir(dir) {
    return file.mkdir(dir);
}

function deletefile(fileordir) {
    return file.deleteFile(fileordir);
}

function readfile(filepath, encoding) {
    if(encoding==null||encoding=='') encoding ="UTF-8";
    return file.readFile(filepath,encoding);
}

function writefile(filepath, content, encoding) {
    if(encoding==null||encoding=='') encoding ="UTF-8";
    return file.writeFile(filepath,content,encoding);
}