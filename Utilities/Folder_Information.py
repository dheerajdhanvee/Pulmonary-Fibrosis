# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 00:22:32 2022

"""

import os
import numpy as np

#Main_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\DataSet\\train"

Main_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\train"

patient_ids=[]
number_of_slices=[]
for i,subfolder in enumerate(os.scandir(Main_Path)):
    if os.path.isdir(subfolder):
        print("How many in this ",subfolder.name)
        patient_ids.append(str(subfolder.name))
        count=0
        for j,filename in enumerate(os.scandir(subfolder.path)):
            count+=1
        print(count)
        number_of_slices.append(count)
        

print("Minimum number of slices",min(number_of_slices))
print("Minimum number of slices for which patient ",patient_ids[np.argmin(number_of_slices)])
          
print(sorted(number_of_slices))

