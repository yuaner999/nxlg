package com.liuzg.jsweb.controllers;

import com.Services.interfaces.EducatePlanService;
import com.model.ResultData;
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
 * Created by NEU on 2017/5/11.
 */
@Controller
@RequestMapping("/EducatePlanupload")
@Scope("prototype")
public class DataUploadFromExcel_EducatePlan {
    @Autowired
    private EducatePlanService EducatePlanService;
    /**
     * 文件最大值
     */
    //private long maxSize = 10*1024*1024;
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
     * 上传培养计划信息表
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/EducatePlan")
    @ResponseBody
    public ResultData exec(HttpServletRequest request, HttpServletResponse response) {
        long start=System.currentTimeMillis();
        ResultData resultData;
        response.reset();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");
        //从请求中加载文件
        resultData=getFileFromRequest(request);
        if(resultData.getStatus()!=0)return resultData;
        FileItem item= (FileItem) resultData.getData();
        List<Map<String ,String >> list= null;
        try {
            //交给excel处理程序 将表格中的数据转换成map的集合，每个map就是一行记录
            list=excelProcess(item.getInputStream());

            //验证excel文件中数据的完整及唯一性
            List<ResultData> resultlist=uqValid(list);
//        System.out.println("验证excel文件中数据的完整及唯一性完成");
            if(resultlist.size()>0){
                resultData.sets(1,"文件中有错误");
                resultData.setData(resultlist);
                return resultData;
            }
            //验证数据是否和数据库中的数据有重复
            if(tableName!=null && tableName.contains("educatePlan")){
                resultData=primaryKeyValid(list);
                if(resultData.getStatus()!=0) return resultData;
            }
            //把转换完成的数据交给数据存储处理函数
            List<String > error_list=saveEducatePlanData(list);
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
        return resultData;
    }

    /**
     * 验证上传文件的数据合不合格(主要是重复性检测)
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/validate")
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
        if(tableName!=null && tableName.contains("educatePlan")){
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
    private List<String> saveEducatePlanData(List<Map<String ,String >> list) throws ParseException {
        //培养计划列表
        //List<EducatePlan> EducatePlans=new ArrayList<>();
        //错误信息存放集合
        List<String > errorList=new ArrayList<>();
        int i=0;
        List<Map<String ,String >> course =EducatePlanService.getCourse(list);
        if(course==null){
            errorList.add("课程代码有误，请查看课程表");
        }
        System.out.println("1"+course);
        Map<String,String> classCodeAndId=new HashMap(course.size());
        for(Map<String,String> m:course){
            classCodeAndId.put(m.get("courseCode"),m.get("courseId"));
        }
        System.out.println("2"+classCodeAndId);
        for(Map<String ,String > map:list){
            map.put("courseId",classCodeAndId.get(map.get("ep_coursecode")));
            i++;
            if(i%batch==0){
                try{
                    int result=0;
                    //根据文件名字的不同，调用不同的service
                    if(tableName.contains("educatePlan")){
                        result=EducatePlanService.saveEducatePlans(list);
                    }
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
                list.clear();
            }
        }
        try{
            int result=0;
            //根据文件名字的不同，调用不同的service
            if(tableName.contains("educatePlan")){
                //System.out.println("EducatePlans.size:"+list.size());
                result=EducatePlanService.saveEducatePlans(list);
            }
//            System.out.println(result);
            if(result<=0){
                errorList.add("第"+((i/batch)*batch+1)+"行至第"+i+"行保存至数据库失败，原因：未知");
            }else{
                saveRows+=result;
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
     * excel中数据的唯一性验证
     * @param list
     * @return
     */
    private List<ResultData> uqValid(List<Map<String ,String >> list){
        List<ResultData> resultlist=new ArrayList<>();
        List<String> classNameErr=new ArrayList<>();        //存放培养计划错误的信息
        int i=0;
        for(Map<String ,String > m:list){
            if(tableName!=null && tableName.contains("educatePlan")){
                i++;
                //班级名字检测
                /**
                 * 2016-09-23 学生信息表修改
                 * 添加班级名、专业、专业类、学院、年级的字段，以及这几个字段值的非空判断
                 */
                String value=m.get("ep_grade");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:年级为空");
                value=m.get("ep_major");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:学院为空");
                value=m.get("ep_college");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:专业为空");
                value=m.get("ep_term");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:学期为空");
                value=m.get("ep_term");
                if(value==null || value.equals(""))
                    classNameErr.add("第 "+i+" 行:学期为空");
                if(!value.equals("第一学期") && !value.equals("第二学期"))
                    classNameErr.add("第 "+i+" 行:学期格式不正确");
            }
        }
        //验证班级
        if(classNameErr.size()>0){
            ResultData re=new ResultData();
            re.sets(1,"年级、学院、专业、学期 数据有错误");
            re.setData(classNameErr);
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
        int i=0;
        for(;list.size()>i+batch;){
            List<Map<String,String >> sub=list.subList(i,i+=batch);
            List<String > keys=EducatePlanService.getKeys(sub);
            if(keys!=null && keys.size()>0){
                temp.addAll(keys);
            }
        }
        if(list.size()==0){
            return resultData;
        }
        List<Map<String,String >> sub=list.subList(i,list.size());
        List<String > keys=EducatePlanService.getKeys(sub);
        if(keys!=null && keys.size()>0){
            temp.addAll(keys);
        }
        if(temp.size()>0){
            resultData.sets(2,"上传数据与数据库中有重复，请查证");
            //resultData.setData(temp);
        }
        return resultData;
    }
}