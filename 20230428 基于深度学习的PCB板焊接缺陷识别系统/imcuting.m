load('imageLabel.mat');
tableName={'imageFilename','flaw'};
filesname=gTruth.DataSource.Source;
flaw = table2cell(gTruth.LabelData);
trainingData =  table(filesname,flaw,'VariableNames',tableName);
for i = 1:5
    I = imread(trainingData.imageFilename{i});
    box = trainingData.flaw{i};
    if size(box,1)==2
        flawIm=imcrop(I,box(1,:));
        output_filename = sprintf('PCB_flaws/solder_point_11%d.png', i);
        imwrite(flawIm, output_filename);
        flawIm=imcrop(I,box(2,:));
        output_filename = sprintf('PCB_flaws/solder_point_22%d.png', i);
        imwrite(flawIm, output_filename);
    else
        flawIm=imcrop(I,box);
        output_filename = sprintf('PCB_flaws/solder_point_%d.png', i);
        imwrite(flawIm, output_filename);
    end
    
end