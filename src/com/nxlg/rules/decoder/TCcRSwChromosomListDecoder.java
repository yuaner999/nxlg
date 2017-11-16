package com.nxlg.rules.decoder;

import com.nxlg.model.TCcRSw;
import com.nxlg.model.TeacherCourse;
import com.nxlg.rules.ITCcRSwIndex;
import com.nxlg.utils.PrjUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by NEU on 2017/6/2.
 */
public class TCcRSwChromosomListDecoder implements ITCcRSwChromosomeDecoder {

    //染色体解码
    @Override
    public List<TCcRSw> decodeToSection(List<Integer> chromosomeseq, int roomCount, int weekdaysCount, int daysectionsCount, int colen, ITCcRSwIndex tCcRSwIndex) {
        int index = 0;

        List<TCcRSw> tCcRSwList = new ArrayList<>();
        for (int roomindex = 0; roomindex < roomCount; roomindex++) {
            for (int dayindex = 0; dayindex < weekdaysCount; dayindex++) {
                for (int sectionindex = 0; sectionindex < daysectionsCount; sectionindex++) {

                    TeacherCourse teachercourse = tCcRSwIndex.getTeacerCourseByteacherCourse(PrjUtils.decodeint(chromosomeseq, index, colen));
                    //teachercourse不表示真实课程时
                    if (teachercourse == null) {
                        tCcRSwList.add(new TCcRSw(0, roomindex + 1, sectionindex + 1, dayindex + 1));
                    } else {
                        int tecoId = PrjUtils.decodeint(chromosomeseq, index, colen);
                        TCcRSw tCcRSw = new TCcRSw(tecoId, roomindex + 1, sectionindex + 1, dayindex + 1);

                        tCcRSwList.add(tCcRSw);
                    }
                    index += colen;
                }
            }
        }
        return tCcRSwList;
    }

}
