close all
% before running please setting up with vl_feat, the vlfeat.zip is included in this folder
% please unzip it and run command like following % "run('yourPath/vlfeat/toolbox/vl_setup')"

SfMConstruction({'handprint/1.jpg','handprint/2.jpg'},'handprint/intrinsic.new', 'handprint');

%imagePathHolder = {'fountain/2.png', 'fountain/3.png', 'fountain/4.png', 'fountain/5.png', 'fountain/6.png', 'fountain/7.png', 'fountain/8.png', 'fountain/9.png'};
%SfMConstruction(flip(imagePathHolder),'fountain/intrinsic.new', 'fountainOrder8Image');
%imagePathHolder = {'fountain/3.png', 'fountain/4.png', 'fountain/5.png', 'fountain/6.png', 'fountain/7.png'};
%SfMConstruction(imagePathHolder,'fountain/intrinsic.new', 'fountainOrder5Image');