# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 08:08:00 2022

@author: Krish
"""

import os
import numpy as np
import shutil

Main_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\DataSet\\train"
Dest_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\train"

#Counting 
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
        
     
print(number_of_slices)
print(patient_ids)

print("Starting Sampling")
sam=30
print("Max Number of samples per patients = ", sam)
# Sampling based on count
for i,subfolder in enumerate(os.scandir(Main_Path)):
    if os.path.isdir(subfolder):
        print("Patient ID",subfolder.name)
        print("Make Segementation directory folders")
        despath=Dest_Path+os.sep+subfolder.name
        os.makedirs(despath,exist_ok = True)
        n=number_of_slices[i]//sam
        count=0
        for j,filename in enumerate(os.scandir(subfolder.path)):
            if number_of_slices[i]>=sam:
                # Copy every nth sample 
                if j%n==0 and count<sam:
                    #Copy only if sample is nth
                    src=filename.path
                    dst=despath+"\\"+filename.name
                    shutil.copyfile(src, dst)
                    print(src)
                    print(dst)
                    count+=1
            else:
                #Copy everything
                src=filename.path
                dst=despath+"\\"+filename.name
                shutil.copyfile(src, dst)
                print(src)
                print(dst)
                
            
