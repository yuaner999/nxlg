package com.nxlg.rules.decoder;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.ITCcRSwIndex;

import java.util.List;

/**
 * Created by NEU on 2017/6/1.
 */
public interface ITCcRSwChromosomeDecoder {

    List<TCcRSw> decodeToSection(List<Integer> chromosomeseq, int roomCount, int weekdaysCount, int daysectionsCount, int colen, ITCcRSwIndex tCcRSwIndex);

}
