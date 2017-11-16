package com.nxlg.utils;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 * Created by NEU on 2017/6/1.
 */
public class SetIndexUtils {

    public static <T> void buildSetIndex(Set<T> dataset, Map<T,Integer> index, Map<Integer,T> reverseIndex,Set<Integer> indexedDataset,int startfrom){
        index.clear();
        reverseIndex.clear();
        indexedDataset.clear();

        int count = dataset.size();
        Iterator<T> it = dataset.iterator();
        for(int i=0;i<count;i++){
            int ii = startfrom+i;
            T value = it.next();
            index.put(value,ii);
            reverseIndex.put(ii,value);
            indexedDataset.add(ii);
        }
    }

    public static <T> T getRealData(int dataid, Map<Integer,T> reverseIndex){
        return reverseIndex.get(dataid);
    }

}
