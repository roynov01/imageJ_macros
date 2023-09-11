inputFolder = getDirectory("Select a folder containing images");
run("Close All");
fileList = getFileList(inputFolder);

// Open all images first
//for (i = 0; i < lengthOf(fileList); i++) {
    //imagePath = inputFolder + fileList[i];
    //open(imagePath);
//}

for (i = 0; i < lengthOf(fileList); i++) {
	imagePath = inputFolder + fileList[i];
    open(imagePath);
    imageTitle = getTitle();
    selectWindow(imageTitle);
    
    // Rotate the image before ROI selection
    Dialog.create("Image Rotation");
    options = newArray("Leave as is", "90° clockwise", "90° anti-clockwise", "180°");
    Dialog.addChoice("Rotate image:", options);
    Dialog.show();
    rotationChoice = Dialog.getChoice();
	if (rotationChoice == "90° clockwise") {
	        run("Rotate 90 Degrees Right");
	    } else if (rotationChoice == "90° anti-clockwise") {
	        run("Rotate 90 Degrees Left");
	    } else if (rotationChoice == "180°") {
	        run("Rotate 90 Degrees Right");
	        run("Rotate 90 Degrees Right");
	    } 

    print("Please draw the ROI on the image and press OK.");
    waitForUser("Draw ROI", "Press OK after drawing the ROI.");

    run("Crop");
    run("Canvas Size...", "width=900 height=600 position=Center zero");
    //for main figure - w=900, h=600, for visium figure: w=675, h=450
    run("Set Scale...", "distance=9.1012 known=1 unit=micron");
    run("Scale Bar...", "width=20 height=5 thickness=10 location=[Upper Left] bold hide overlay");



    outputFile = replace(fileList[i], ".tif", "_ROI.tif");
    saveAs("Tiff", inputFolder + outputFile);
    close();

}
