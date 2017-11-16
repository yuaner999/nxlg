package com.liuzg.jsweb.controllers;

import com.Services.interfaces.StudentService;
import com.model.*;
import com.utils.PwdUtil;
import org.apache.commons.codec.binary.StringUtils;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;

import static com.utils.ExcelUtil.getCellStringValue;

/**
 * 上传excel文件，批量导入数据库的controller
 * @author hong
 * Created by admin on 2016/7/14.
 */
@Controller
@RequestMapping("/dataupload")
@Scope("prototype")
public class DataUploadFromExcel {
    @Autowired
    private StudentService studentService;
    /**
     * 文件最大值
     */
//    private long maxSize = 10*1024*1024;
    /**
     * 表格的名字，区分是哪些数据
     */
    private String tableName="";
    /**
     * 数据总行数
     */
    private int totalrows=0;
    /**
     * 成功保存的数据行数
     */
    private int saveRows=0;
    /**
     * 批量保存数据库的批次
     */
    private final int batch=2000;

    /**
     * 上传学生信息表
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/studentinfo")
    @ResponseBody
    public ResultData exec(HttpServletRequest request, HttpServletResponse response) {
        long start=System.currentTimeMillis();
        ResultData resultData ;
        response.reset();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");
        //从请求中加载文件
        resultData=getFileFromRequest(request);
        if(resultData.getStatus()!=0)return resultData;
        FileItem item= (FileItem) resultData.getData();
        try {
            //交给excel处理程序 将表格中的数据转换成map的集合，每个map就是一行记录
            List<Map<String ,String >> list=excelProcess(item.getInputStream());
            //验证excel文件中数据的完整及唯一性
            List<ResultData> resultlist=uqValid(list);
//        System.out.println("验证excel文件中数据的完整及唯一性完成");
            if(resultlist.size()>0){
                resultData.sets(1,"文件中有错误");
                resultData.setData(resultlist);
                return resultData;
            }
            //验证数据是否和数据库中的数据有重复
            if(tableName!=null && tableName.contains("students")){
                resultData=primaryKeyValid(list);
                if(resultData.getStatus()!=0)
                    return resultData;
            }
            //把转换完成的数据交给数据存储处理函数
            List<String > error_list=saveStudentData(list);
            resultData.setData(error_list);
        } catch (IOException e) {
            e.printStackTrace();
            resultData.sets(-1, e.getMessage());
            return resultData;
        }catch (ParseException e){
            e.printStackTrace();
            resultData.sets(-1, e.getMessage());
            return resultData;
        }
        long times=System.currentTimeMillis()-start;
        resultData.setMsg("共计"+totalrows+"行数据，成功保存"+saveRows+"行，用时："+times+"ms");
        saveRows=0;
//        if(resultData.getStatus()==0){
//            resultData.setResult(true);
//        }
        return resultData;
    }

    /**
     * 验证上传文件的数据合不合格(主要是重复性检测)
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/validdata")
    @ResponseBody
    public ResultData validUploadFile(HttpServletRequest request, HttpServletResponse response){
        long start=System.currentTimeMillis();
        ResultData resultData ;
        response.reset();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");
        resultData=getFileFromRequest(request);
        if(resultData.getStatus()!=0) return resultData;
        FileItem item= (FileItem) resultData.getData();
        //取出文件后把data清空，否则有可能会被返回给客户端，从而导致报错
        resultData.setData(null);
        //交给excel处理程序 将表格中的数据转换成map的集合，每个map就是一行记录
        List<Map<String ,String >> list= null;
        try {
            list = excelProcess(item.getInputStream());
//            System.out.println("从表格中取出数据完成");
        } catch (IOException e) {
            e.printStackTrace();
            resultData.sets(-1,e.getMessage().substring(2001));
            return resultData;
        }
        //验证excel文件中数据的完整及唯一性
        List<ResultData> resultlist=uqValid(list);
//        System.out.println("验证excel文件中数据的完整及唯一性完成");
        if(resultlist.size()>0){
            resultData.sets(1,"文件中有错误");
            resultData.setData(resultlist);
            return resultData;
        }
        //验证数据是否和数据库中的数据有重复
        if(tableName!=null && tableName.contains("students")){
            resultData=primaryKeyValid(list);
            if(resultData.getStatus()!=0) return resultData;
        }
        long times=System.currentTimeMillis()-start;
        resultData.setMsg("文件检测完成，共计"+totalrows+"行数据，用时："+times+"ms");
        return resultData;
    }

    /**
     * 从request中加载文件
     * @param request
     * @return
     */
    public ResultData getFileFromRequest(HttpServletRequest request) {
        ResultData resultData=new ResultData();
        //检查是否上传了文件
        if (!ServletFileUpload.isMultipartContent(request)) {
            resultData.sets(1, "请选择文件");
            return resultData;
        }
        //获取文件
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List items = null;
        try {
            items = upload.parseRequest(request);
//            System.out.println(items.size());
        } catch (FileUploadException e) {
            e.printStackTrace();
            resultData.sets(-1, e.getMessage());
            return resultData;
        }
        Iterator itr = items.iterator();
        FileItem item=null;
        if(itr.hasNext()) {
            item = (FileItem) itr.next();
            String fileName = item.getName();
            if (!item.isFormField()) {
                tableName=fileName.substring(0,fileName.lastIndexOf("."));
                // 检查扩展名
                String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                if (!"xls".equals(fileExt)) {
                    resultData.sets(1, "上传文件格式不正确！");
                    return resultData;
                }
//                System.out.println("上传文件检查文件完成");
            }
        }
        resultData.setData(item);
        return resultData;
    }

    /**
     * 把数据保存到数据库
     * @param list
     * @return 错误的信息
     * @throws ParseException
     */
    private List<String> saveStudentData(List<Map<String ,String >> list) throws ParseException {
        //学生列表
        List<Student> students=new ArrayList<>();
        //错误信息存放集合
        List<String > errorList=new ArrayList<>();
        List<Map<String ,String >> list1= null;
        int i=0;
        for(Map<String ,String > map:list){
            i++;
            list1 = list.subList(i-1,i);
            if(tableName.contains("students") ){
                try {
//                    System.out.println("|"+idcard);
                    map.put("password", PwdUtil.getPassMD5(PwdUtil.getPassMD5("123456")));
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
            //把map转换成对象
            if(tableName.contains("students")){
                Student_Encoding s= (Student_Encoding) mapToObj(map,Student_Encoding.class);
                students.add(s);
            }
            if(i%batch==0){
                try{
                    int result=0;
                    int re=0;
                    //根据文件名字的不同，调用不同的service
                    if(tableName.contains("students")){
                        result=studentService.saveStudents(students);
                    }
//                    System.out.println(result);
                    if(result<=0){
                        errorList.add("第"+(i-batch<=0?1:i-batch+1)+"行至第"+i+"行保存至数据库失败，原因：未知");
                    }else{
                        saveRows+=result;
                    }
                }catch (Exception e){
                    e.getStackTrace();
                    String msg=e.getMessage();
                    errorList.add("第"+(i-batch<=0?1:i-batch+1)+"行至第"+i+"行保存至数据库失败，原因："+e.getMessage().substring(0,msg.length()>2000?2000:msg.length()));
//                    System.out.println("第"+(i-batch<=0?1:i-batch+1)+"行至第"+i+"行保存至数据库失败，原因："+e.getMessage().substring(0,msg.length()>2000?2000:msg.length()));
                }
            }
        }
        try{
            int result=0;
            int re=0;
            //根据文件名字的不同，调用不同的service
            if(tableName.contains("students")){
                result=studentService.saveStudents(students);
            }
            if(result<=0){
                errorList.add("第"+((i/batch)*batch+1)+"行至第"+i+"行保存至数据库失败，原因：未知");
            }else{
                students.clear();
                int j=0;
                for(Map<String ,String > m:list) {
                    j++;
                    list1 = list.subList(j - 1, j);
                    if (tableName.contains("students")) {
                    List<String> studentId=studentService.getId(list1);
                    m.put("studentId",studentId.get(0));
                    }
                    //把map转换成对象
                    if (tableName.contains("students")) {
                        Student_Encoding s = (Student_Encoding) mapToObj(m, Student_Encoding.class);
                        students.add(s);
                    }
                }
                re=studentService.saveUser(list);
                if(re<=0){
                    errorList.add("第"+(i-batch<=0?1:i-batch+1)+"行至第"+i+"行保存至数据库失败，原因：未知");
                }else{
                    saveRows+=result;
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            String msg=e.getMessage();
            errorList.add("第"+((i/batch)*batch+1)+"行至第"+i+"行保存至数据库失败，原因："+msg.substring(0,msg.length()>2000?2000:msg.length()));
//            System.out.println("第"+((i/batch)*batch+1)+"行至第"+i+"行保存至数据库失败，原因："+e.getMessage().substring(0,msg.length()>2000?2000:msg.length()));
        }
//        System.out.println(errorList.size());
        return errorList;
    }

    /**
     * 处理excel中的数据，返回Map的集合。每个map 就是一行数据
     * @param input
     * @return
     * @throws IOException
     */
    private List<Map<String ,String >> excelProcess(InputStream input) throws IOException{
        List<Map<String ,String >> list=new ArrayList<>();
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook(input);
        HSSFSheet sheet=hssfWorkbook.getSheetAt(0);
        List<String > fieldName=new ArrayList<>();
        //总数据行数 ，表格的总行数，减去前三行标题
//        String tabname=sheet.getRow(0).getCell(0).getStringCellValue();
//        if(tabname!=null && !tabname.equals("")){
//            tableName=tabname.split("#")[0];
//        }
        totalrows=sheet.getLastRowNum()-3+1;
        for(int i=1;i<=sheet.getLastRowNum();i++){
            //跳过第三行 （中文标题）
            if(i==2)continue;
            HSSFRow row=sheet.getRow(i);
            Map<String ,String> map=new HashMap<>();
            for(int j=0;j<=row.getLastCellNum();j++){
                HSSFCell cell=row.getCell(j);
                if(cell==null)continue;
                String cellvalue=getCellStringValue(cell);
                if(cellvalue!=null && !cellvalue.equals("")){
                    cellvalue=cellvalue.trim().replaceAll("[\n\t\r]*","");
                }
                //如果是第二行（字段名）则放到另一个list中
                if(i==1) {
                    fieldName.add(cellvalue);
                }else{
                    map.put(fieldName.get(j),cellvalue);
                }
            }
            if(i!=1) list.add(map);
        }
        return list;
    }

    /**
     * 把map 转换成对象 (调用set方法，方便加密)
     * @param map 需要转换的map
     * @param c 要转换成对象的class
     * @return
     */
    public Object mapToObj(Map map,Class c) throws ParseException {
        Object o=null;
        try {
            o=c.newInstance();
            Method[] methods=c.getMethods();
            for(Method m:methods){
                m.setAccessible(true);
                String methodName=m.getName();
                if(!methodName.contains("set")) continue;   //如果不是set方法则跳过
                Class paraType=m.getParameterTypes()[0];
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
                String value=(String)map.get(methodName.substring(3,4).toLowerCase()+methodName.substring(4));      //把方法名中的set去掉，然后第一个字母转小写，就是bean属性，以此为key从map 中取值
                if(value==null || value.equals(""))continue;    //根据bean属性在map中获取不到值则跳过
                if( paraType== java.sql.Date.class){       //如果该set方法的参数类型是date 或者 timestamp
                    //    System.out.println(value +"需要转换的");
                    m.invoke(o,new java.sql.Date(sdf.parse(value.replaceAll("/","-")).getTime()));
                }else if(paraType==Date.class ){
                    m.invoke(o,new Date(sdf.parse(value).getTime()));
                }else if( paraType== Timestamp.class){
                    m.invoke(o,new Timestamp(sdf.parse(value).getTime()));
                }else if(paraType== int.class){                   //如果该set方法的参数类型是int
                    m.invoke(o,Integer.parseInt(value));
                }else if(paraType==String.class) {                //如果该set方法的参数类型是 string
                    m.invoke(o,value);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return o;
    }

    /**
     * excel中数据的唯一性验证
     * @param list
     * @return
     *///    getStudys getClasss getGrades getMajors getColleges getSchools
    private List<ResultData> uqValid(List<Map<String ,String >> list){
        List<ResultData> resultlist=new ArrayList<>();
//        Map<String ,String > classMap= generateClassMap();  //获取班级的名字map
        List<String> classNameErr=new ArrayList<>();        //存放班级名字错误的信息
        Map<String ,Integer> map=new HashMap<>(batch);       //学号重复验证的容器
        List<String > nlId=new ArrayList<>();               //学号为空的值的集合
        Map<String,String  > stuIdAndTitle=new HashedMap();      //检测活动上传时文件中的重复数据 的临时容器
        List<String > repeatIndex=new ArrayList<>();        //检测活动上传时文件中的重复数据 的结果
        List<String> getStudys =studentService.getStudys(list);
        List<String> getSchools =studentService.getSchools(list);
        List<String> getColleges =studentService.getColleges(list);
        List<String> getGrades =studentService.getGrades(list);
        List<Map<String ,String >> list1= null;
        int i=0;
        for(Map<String ,String > m:list){
            if(tableName!=null && tableName.contains("student")){
                i++;
                //班级名字检测
                /**
                 * 2016-09-23 学生信息表修改
                 * 添加班级名、专业、专业类、学院、年级的字段，以及这几个字段值的非空判断
                 */
                String value=m.get("studentClass");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:班级为空");
                value=m.get("studentMajor");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:专业为空");
                value=m.get("studentGrade");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:年级为空");
                value=m.get("studentCollege");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:学院为空");
                value=m.get("studentIDCard");
                if(value.length()!=18)
                    classNameErr.add("第 "+i+" 行:身份证格式不正确");
                value=m.get("studentGender");
                if((!value.equals("男"))&&(!value.equals("女")))
                    classNameErr.add("第 "+i+" 行:性别格式不正确（正确格式：男/女）");
                value=m.get("studentPolitics");
                if((!value.equals("中共党员"))&&(!value.equals("共青团员"))&&(!value.equals("群众"))&&(!value.equals("其他")))
                    classNameErr.add("第 "+i+" 行:政治面貌格式不正确（正确格式：中共党员/共青团员/群众/其他）");
                value=m.get("studentPhone");
                if(value.length()!=11)
                    classNameErr.add("第 "+i+" 行:手机号格式不正确");
                value=m.get("linkManPhone");
                if(value.length()!=11)
                    classNameErr.add("第 "+i+" 行:联系人手机号格式不正确");
                value=m.get("linkManPostcode");
                if(value.length()!=6)
                    classNameErr.add("第 "+i+" 行:邮编格式不正确");
                value=m.get("studentLevel");
                if((!value.equals("本科"))&&(!value.equals("专科")))
                    classNameErr.add("第 "+i+" 行:培养层次格式不正确（正确格式：本科/专科）");
                value=m.get("studentGrade");
                if(!getGrades.contains(value))
                    classNameErr.add("第 "+i+" 行:年级不存在,正确格式"+getGrades);
                value=m.get("studentCollege");
                if(!getColleges.contains(value))
                    classNameErr.add("第 "+i+" 行:学院不存在");
                value=m.get("studentSchoolAddress");
                if(!getSchools.contains(value))
                    classNameErr.add("第 "+i+" 行:校区不存在");
                value=m.get("studentForm");
                if(!getStudys.contains(value))
                    classNameErr.add("第 "+i+" 行:学习形式不存在");
                list1 = list.subList(i-1,i);
                List<String > getMajors= studentService.getMajors(list1);
                value=m.get("studentMajor");
                if(!getMajors.contains(value))
                    classNameErr.add("第 "+i+" 行:所填写学院不存在该专业");
                List<String > getClasss= studentService.getClasss(list1);
                value=m.get("studentClass");
                if(!getClasss.contains(value))
                    classNameErr.add("第 "+i+" 行:所填写学院、专业不存在该班级");
//                else{
//                    String classid=classMap.get(className);
//                    if(classid==null || classid.equals(""))
//                        classNameErr.add("第 "+i+" 行:班级["+className+"]不存在");
//                }
                //空值检测
                String id=m.get("studentNum");
                if(id==null || id.equals("")){
                    String index=m.get("index");
                    if(index==null || index.equals(""))index=i+"";
                    nlId.add("第"+index+"行附近");
                    continue;
                }
                //重复性检测
                if(!map.containsKey(id)) map.put(id,1);
                else map.put(id,map.get(id)+1);
            }
        }
        //验证班级
        if(classNameErr.size()>0){
            ResultData re=new ResultData();
            re.sets(1,"学生信息数据有错误");
            re.setData(classNameErr);
            resultlist.add(re);
        }
        //验证学号是否有空值
        if(nlId.size()>0){
            ResultData re=new ResultData();
            re.sets(1,"学号有空值");
            re.setData(nlId);
            resultlist.add(re);
        }
        //验证学号是否有重复
        Set<Entry<String ,Integer>> entries=map.entrySet();
        Iterator<Entry<String, Integer>> it=entries.iterator();
        List<String > msg=new ArrayList<>();
        while (it.hasNext()){
            Entry<String, Integer> en=it.next();
            if(en.getValue()>=2) {
                msg.add("学号["+en.getKey()+"]出现次数"+en.getValue());
            }else{
                it.remove();
            }
        }
        if(entries.size()>0){
            ResultData re=new ResultData();
            re.sets(1,"学号有重复");
            re.setData(msg);
            resultlist.add(re);
        }
        if(repeatIndex.size()>0){
            ResultData re=new ResultData();
            re.sets(1,"数据有重复,详见以下行号对");
            re.setData(repeatIndex);
            resultlist.add(re);
        }
        return resultlist;
    }
    /**
     * 检查表格中数据与数据库中数据是否有重复
     * @param list
     * @return
     */
    private ResultData primaryKeyValid(List<Map<String ,String >> list){
        ResultData resultData=new ResultData();
        List<String > temp=new ArrayList<>();
        List<String > Isrepeat=new ArrayList<>();
        int i=0;
        for(;list.size()>i+batch;){
            List<Map<String,String >> sub=list.subList(i,i+=batch);
            List<String > keys=studentService.getKeys(sub);
            List<String > key= studentService.getKey(sub);
            Isrepeat.addAll(key);
            if(Isrepeat.size()>0){
                resultData.sets(1,"第"+i+"行学生学号的用户信息已存在，请查看");
                return resultData;
            }
            Isrepeat.clear();
            if(keys!=null && keys.size()>0){
                temp.addAll(keys);
            }
        }
        if(list.size()==0){
            return resultData;
        }
        List<Map<String,String >> sub=list.subList(i,list.size());
        List<String > keys=studentService.getKeys(sub);
        List<String > key= studentService.getKey(sub);
        if(keys!=null && keys.size()>0){
            temp.addAll(keys);
        }
        if(key!=null && key.size()>0){
            Isrepeat.addAll(key);
        }
        if(temp.size()>0){
            resultData.sets(1,"以下学号的学生信息已存在，请查证");
            resultData.setData(temp);
        }
        if(Isrepeat.size()>0){
            resultData.sets(2,"以下学号的用户信息已存在，请查证");
            resultData.setData(Isrepeat);
        }
        return resultData;
    }


}