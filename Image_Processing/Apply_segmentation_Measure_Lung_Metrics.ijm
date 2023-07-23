Original_image_path="D:/JHU_Preparation/Spring_courses/Machine_Learning_For_MA/Project/Sampled_Data/train/"
segmented_image_path="D:/JHU_Preparation/Spring_courses/Machine_Learning_For_MA/Project/Sampled_Data/Segmented_Images/train/"
masked_image_path="D:/JHU_Preparation/Spring_courses/Machine_Learning_For_MA/Project/Sampled_Data/Segmented_Data_Masks/train/"

pat_list=getFileList(Original_image_path);
masked_list=getFileList(masked_image_path);

run("Close All");
for (i=0; i<pat_list.length; i++) {
	print(pat_list[i]);
	seg_pat_path=segmented_image_path+pat_list[i];
	File.makeDirectory(seg_pat_path);
	slices_list=getFileList(Original_image_path+pat_list[i]);
	for (j=0;j<slices_list.length;j++){
		A=slices_list[j];
		slice_name_only=split(A,'.');
		print(slice_name_only[0]);

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
		run("Divide...", "value=255");
		imageCalculator("Multiply create 32-bit", "DCM_im.dcm","Mask_im.png");
		selectWindow("Result of DCM_im.dcm");
		setOption("ScaleConversions", true);
		run("Scale...", "x=- y=- width=512 height=512 interpolation=Bicubic average create");
		//run("8-bit");
		//Saving segmented images
		saveAs("PNG", segmented_image_path+pat_list[i]+slice_name_only[0]+".png");
		
		run("Close All");
		
	}

}

/*

//rename("Mask_im.png");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(0, 0, "raw");
//setThreshold(0, 0);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Invert");
run("Divide...", "value=255");
imageCalculator("Multiply create 32-bit", "DCM_im.dcm","Mask_im.png");
selectWindow("Result of DCM_im.dcm");
setOption("ScaleConversions", true);
run("8-bit");
*/