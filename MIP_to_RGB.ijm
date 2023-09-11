setBatchMode(true);	
inputFolder = getDirectory("Select a folder containing images");
run("Close All");
fileList = getFileList(inputFolder);

for (i = 0; i < lengthOf(fileList); i++) {
	imagePath = inputFolder + fileList[i];
    open(imagePath);
    imageTitle = getTitle();
    selectWindow(imageTitle);
	run("RGB Color");
	run("Flatten");
	outputFile = replace(fileList[i], "_ROI.tif", "_ROI_RGB.tif");
    saveAs("Tiff", inputFolder + outputFile);
	close();
	close();

}