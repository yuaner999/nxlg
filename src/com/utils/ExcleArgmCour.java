package com.utils;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;

import java.util.List;
import java.util.Map;

/**
 * Created by NEUNB_Lisy on 2017/5/22.
 */
public class ExcleArgmCour {
    /**
     * 创建excel文档，
     * @param list 数据
     * */
    public static Workbook createWorkBook(List<Map<String ,Object>> list,  String bookTitle) {

        String weekNames[] = {"","", "星期一", "星期二", "星期三","星期四","星期五","星期六","星期日"};//列名

        // 创建excel工作簿
        HSSFWorkbook wb = new HSSFWorkbook();

        // 创建两种单元格格式
        HSSFCellStyle cs = wb.createCellStyle();
        HSSFCellStyle title=wb.createCellStyle();
        cs.setWrapText(true);
        // 创建两种字体
        Font f_t=wb.createFont();
        Font f = wb.createFont();
        //标题的字体
        f_t.setFontHeightInPoints((short)24);
        f_t.setBold(true);
        f.setColor(IndexedColors.BLACK.getIndex());
        title.setFont(f_t);
        title.setBorderLeft(CellStyle.BORDER_THIN);
        title.setBorderRight(CellStyle.BORDER_THIN);
        title.setBorderTop(CellStyle.BORDER_THIN);
        title.setBorderBottom(CellStyle.BORDER_THIN);
        title.setAlignment(CellStyle.ALIGN_CENTER);

        // 设置第一种单元格的样式（用于列名）
        cs.setFont(f);
        cs.setBorderLeft(CellStyle.BORDER_THIN);
        cs.setBorderRight(CellStyle.BORDER_THIN);
        cs.setBorderTop(CellStyle.BORDER_THIN);
        cs.setBorderBottom(CellStyle.BORDER_THIN);
        cs.setAlignment(CellStyle.ALIGN_CENTER);
        cs.setWrapText(true);

        // 创建第一个sheet（页），并命名
        HSSFSheet sheet = wb.createSheet("sheet1");
        //合并单元格
        sheet.addMergedRegion(new CellRangeAddress(0,0,0,8));
        // 创建第一行  标题
        Map<String ,Object> titlemap=list.get(0);
        Row row = sheet.createRow((short) 0);
        Cell cel=row.createCell(0);

        cel.setCellValue(bookTitle);
        /*if (titlemap.containsKey("department")) {
        }else if (titlemap.containsKey("classroomName")){
            cel.setCellValue(titlemap.get("classroomName").toString()+"的"+bookTitle);
        }else {
            cel.setCellValue(titlemap.get("studentName").toString()+"的"+bookTitle);
        }*/
        cel.setCellStyle(title);

        Row row1 = sheet.createRow((short) 1);

        HSSFCell cell[][]=new HSSFCell[7][9];
        //为每个cell添加样式
        for (int i=1;i<7;i++){
            HSSFRow rowx = sheet.createRow((short) i);
            for(int j=0;j<9;j++){
                cell[i][j]=rowx.createCell(j);
                cell[i][j].setCellStyle(cs);
                sheet.autoSizeColumn(j);
                StringBuilder str=new StringBuilder();
                for(int dx=0;dx<list.size();dx++){
                    Map<String ,Object> map=list.get(dx);
                    if(Integer.parseInt(String.valueOf(map.get("al_timeweek")==null?0:map.get("al_timeweek")))==(j-1)&&Integer.parseInt(String.valueOf(map.get("al_timepitch")))==(i-1)){

                        str.append(map.get("chineseName")==null?null:map.get("chineseName").toString()+"\r\n");
                        str.append(map.get("teacherName")==null?null:map.get("teacherName").toString()+"\r\n");
                        str.append(map.get("classroomName")==null?null:map.get("classroomName").toString()+"\r\n");
                        str.append(map.get("tc_class")==null?null:map.get("tc_class").toString()+"\r\n");
                        str.append(map.get("tc_thweek_start")==null?null:map.get("tc_thweek_start").toString()+"-");
                        str.append(map.get("tc_thweek_end")==null?null:map.get("tc_thweek_end").toString()+"周"+"(");
                        str.append(map.get("tc_teachodd")==null?null:map.get("tc_teachodd").toString()+")"+"\r\n");
                        cell[i][j].setCellValue(new HSSFRichTextString(str.length()==0?"无":str.toString()));
                        int width=sheet.getColumnWidth(str.length());
                        if(width < 265*str.length())  sheet.autoSizeColumn(str.length());
                        list.remove(dx);
                        dx--;
                    }
                }
            }
        }


        //设置列名
        for(int i=0;i<weekNames.length;i++){
            Cell cell1 = row1.createCell(i);
            cell1.setCellValue(weekNames[i]);
            cell1.setCellStyle(cs);
            sheet.autoSizeColumn(i);
        }


        //合并单元格的设置
        sheet.addMergedRegion(new CellRangeAddress(1,1,0,1));
        //合并上下晚
        sheet.addMergedRegion(new CellRangeAddress(2,3,0,0));
        sheet.addMergedRegion(new CellRangeAddress(4,5,0,0));
        sheet.addMergedRegion(new CellRangeAddress(6,6,0,0));

        //设置默认值
        cell[1][0].setCellValue("时间");
        cell[2][0].setCellValue("上午");
        cell[4][0].setCellValue("下午");
        cell[6][0].setCellValue("晚上");
        cell[2][1].setCellValue("第一大节");
        cell[3][1].setCellValue("第二大节");
        cell[4][1].setCellValue("第三大节");
        cell[5][1].setCellValue("第四大节");
        cell[6][1].setCellValue("第五大节");

        return wb;
    }
}
