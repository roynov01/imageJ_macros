COLORS = newArray("Grays", "Grays", "Grays", "Red", "Blue"); // channel colors
DAPI = "Blue"; // color for channels beyond COLORS
Z_PROJ = 1; // 1 = perform Z projection
Z_MIN = 1; // first slice
Z_MAX = 8; // last slice
OUTPUT_SUBFOLDERS = 0; // 0 = all output in one folder, 1 = one folder per TIFF

print("[SCRIPT STARTED]");
run("Close All");
setBatchMode(true);

path = getDirectory("Choose a Directory");
files = getFileList(path);

output = path + "processed_tiff\\";
if (!File.exists(output)) {
    File.mkdir(output);
} else {
    print("Output folder already exists: " + output);
}

print("Processing files in directory: " + path);

for (j = 0; j < files.length; j++) {

    if (!endsWith(files[j], ".tif") && !endsWith(files[j], ".tiff")) {
        print("Skipping non-TIFF file: " + files[j]);
        continue;
    }

    print("**************************************");
    print("Processing: " + files[j]);

    cleanFile = replace(files[j], ".tif", "");
    cleanFile = replace(cleanFile, ".tiff", "");

    if (OUTPUT_SUBFOLDERS == 1) {
        currentOutput = output + cleanFile + "\\";
        if (!File.exists(currentOutput))
            File.mkdir(currentOutput);
    } else {
        currentOutput = output;
    }

    action(path, files[j], currentOutput);
}

print("[FINISHED]");
setBatchMode(false);

function action(path, file, output) {

    run("Bio-Formats Importer", "open=[" + path + file + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");

    title = getTitle();

    Stack.setDisplayMode("color");
    _ = Stack.getDimensions(width, height, nChannels, slices, frames);

    print("Channels: " + nChannels + "  Slices: " + slices);

    for (c = 1; c <= nChannels; c++) {
        Stack.setChannel(c);
        run("Enhance Contrast", "saturated=0.35");

        if (c <= COLORS.length)
            run(COLORS[c - 1]);
        else
            run(DAPI);
    }

    Stack.setDisplayMode("composite");

    activeChannels = "";
    for (c = 1; c <= nChannels; c++)
        activeChannels = activeChannels + "1";
    Stack.setActiveChannels(activeChannels);

    cleanFile = replace(file, ".tif", "");
    cleanFile = replace(cleanFile, ".tiff", "");

    saveAs("tiff", output + cleanFile);
    print("Saved: " + output + cleanFile);

    if (Z_PROJ == 1 && slices > 1) {

        stopSlice = Z_MAX;
        if (stopSlice > slices)
            stopSlice = slices;

        startSlice = Z_MIN;
        if (startSlice < 1)
            startSlice = 1;

        if (startSlice <= stopSlice) {
            run("Z Project...", "start=" + startSlice + " stop=" + stopSlice + " projection=[Max Intensity]");
            saveAs("tiff", output + cleanFile + "_MAXI");
            print("Saved: " + output + cleanFile + "_MAXI");
            close();
        } else {
            print("Skipping Z projection because start slice > end slice.");
        }
    }

    close();
}