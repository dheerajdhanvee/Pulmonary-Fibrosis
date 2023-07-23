# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 02:51:17 2022

Before running the code: Execute the following in command prompt

pip install git+https://github.com/JoHof/lungmask

"""



import os
import sys
os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"



def run_segmentation(Main_Path,Segmented_Path):
    for i,subfolder in enumerate(os.scandir(Main_Path)):
        if os.path.isdir(subfolder):
            print("Patient ID",subfolder.name)
            print("Make Segementation directory folders")
            segpath=Segmented_Path+os.sep+subfolder.name
            os.makedirs(segpath,exist_ok = True)
            for j,filename in enumerate(os.scandir(subfolder.path)):
                file_only_name=filename.name.split('.')[0]
                IP_file=subfolder.path+"\\"+filename.name
                OP_file=segpath+"\\"+file_only_name+".png"
                print("Input File is ",IP_file)
                print("Output File is ",OP_file)
                command_string="lungmask "+IP_file+" "+OP_file
                print("Running",command_string)
                os.system(command_string)
            
            
        
# Make segmentation for Train Images 
Main_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\train"
Segmented_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\Segmented_Data\\train"
run_segmentation(Main_Path,Segmented_Path)

# MAke segmentation for Val Images 
Main_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\val"
Segmented_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\Segmented_Data\\val"
run_segmentation(Main_Path,Segmented_Path)



#Make segmentation for Test Images 
Main_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\test"
Segmented_Path="D:\\JHU_Preparation\\Spring_courses\\Machine_Learning_For_MA\\Project\Sampled_Data\\Segmented_Data\\test"
run_segmentation(Main_Path,Segmented_Path)





