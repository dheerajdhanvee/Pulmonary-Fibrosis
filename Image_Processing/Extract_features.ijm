Original_image_path="D:/JHU_Preparation/Spring_courses/Machine_Learning_For_MA/Project/Sampled_Data/train/"
segmented_image_path="D:/JHU_Preparation/Spring_courses/Machine_Learning_For_MA/Project/Sampled_Data/Segmented_Images/train/"
masked_image_path="D:/JHU_Preparation/Spring_courses/Machine_Learning_For_MA/Project/Sampled_Data/Segmented_Data_Masks/train/"

pat_list=getFileList(Original_image_path);
masked_list=getFileList(masked_image_path);

run("Close All");
pat_id = newArray;
slice_id=newArray;
Lung_Area_arr = newArray;
ASM_arr=newArray;
Con_arr = newArray;
Corr_arr=newArray;
IDM_arr = newArray;
Ent_arr=newArray;
siz=0
psi=0
for (i=100; i<pat_list.length; i++) {
	print(pat_list[i]);
	print(psi);
	seg_pat_path=segmented_image_path+pat_list[i];
	File.makeDirectory(seg_pat_path);
	slices_list=getFileList(Original_image_path+pat_list[i]);
	for (j=0;j<slices_list.length;j++){
		A=slices_list[j];
		slice_name_only=split(A,'.');
		//print(slice_name_only[0]);

		//Open the Original Image - dcm
		open(Original_image_path+pat_list[i]+A);
		run("8-bit");
		rename("DCM_im.dcm");
		//Open mask image
		open(masked_image_path+pat_list[i]+slice_name_only[0]+".png");
		rename("Mask_im.png");

		// Apply mask on image - create segmented image 
		setAutoThreshold("Default dark");
		//run("Threshold...");
		setThreshold(0, 0, "raw");
		//setThreshold(0, 0);
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Invert");

		run("Analyze Particles...", "size=100-Infinity show=Outlines display clear add");
		//Add all areas to get total lung volume 
		n=roiManager("count");
		Lung_Area=0;
		for(k=0;k<n;k++){
		Lung_Area=Lung_Area+getResult("Area",k);
		}

		ASM=0;
		Con=0;
		Corr=0;
		IDM=0;
		Ent=0;
		
		for(k=0;k<n;k++){
			selectWindow("DCM_im.dcm");
			roiManager("Select", k);
			run("GLCM Texture", "enter=1 select=[0 degrees] angular contrast correlation inverse entropy");
			ASM=ASM+getResult("Angular Second Moment",0);
			Con=Con+getResult("Contrast",0);
			Corr=Corr+getResult("Correlation",0);
			IDM=IDM+getResult("Inverse Difference Moment",0);
			Ent=Ent+getResult("Entropy",0);
			
		}
		//Getting Average feature values
		ASM=ASM/n;
		Con=Con/n;
		Corr=Corr/n;
		IDM=IDM/n;
		Ent=Ent/n;

		/*
		run("Divide...", "value=255");
		imageCalculator("Multiply create 32-bit", "DCM_im.dcm","Mask_im.png");
		selectWindow("Result of DCM_im.dcm");
		setOption("ScaleConversions", true);
		run("Scale...", "x=- y=- width=512 height=512 interpolation=Bicubic average create");
		//run("8-bit");
		//Saving segmented images
		//saveAs("PNG", segmented_image_path+pat_list[i]+slice_name_only[0]+".png");
		*/
		roiManager("reset")
		run("Close All");
		pat_name_only=split(pat_list[i],'/');
		pat_id[siz]=pat_name_only[0];
		slice_id[siz]=slice_name_only[0];

		Lung_Area_arr[siz]=Lung_Area;

		ASM_arr[siz]=ASM;
		Con_arr[siz]=Con;
		Corr_arr[siz]=Corr;
		IDM_arr[siz]=IDM;
		Ent_arr[siz]=Ent;

		siz=siz+1;
	}
	psi=psi+1;
}

// Make the new results table
Table.create("Features");
Table.setColumn("Patient ID", pat_id);
Table.setColumn("Slice ID", slice_id);

Table.setColumn("Lung Volume", Lung_Area_arr);

Table.setColumn("Angular_Second_Momentum", ASM_arr);
Table.setColumn("Contrast", Con_arr);
Table.setColumn("Correlation", Corr_arr);
//Table.setColumn("Inverse Difference Moment", IDM_arr);
Table.setColumn("Entropy", Ent_arr);


//Save the results table
Table.save("D:/JHU_Preparation/Spring_courses/Machine_Learning_For_MA/Project/CODES/Image_Processing/train3.csv");