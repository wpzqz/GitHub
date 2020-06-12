clear all
dist = 1;                                         %声源距离阵列最左端点的距离
step = 10;                                        %角度步长
mic_d = 0.2;                                      %阵列间距
mic_num = 8;                                       %麦克风阵列阵元个数
fs = 160000;                                       %采样频率
width = 26;
pos = [0 2 1];                                     %pos:最右阵元位置
file_num_final = 6;                                   %读取的最后一个语音文件编号
CurrentPath = 'E:\MATLAB\Microphone array\GCC-PHAT\DOA_simulate\';
SavePath = 'TrainData';                           %结果存储路径
read_Wav(fs, dist, step, mic_d, mic_num, pos, file_num_final);
path_ = [CurrentPath SavePath];
list = dir(path_);
for i = 1:size(list, 1)
    if strcmp(list(i).name, '.')||strcmp(list(i).name, '..')
        continue
    end
    path = [path_ '\' list(i).name] ;
    savedir = [path_ '\gcc_man_' num2str(i-2)];
    if ~exist(savedir,'dir')
        mkdir(savedir);
    end
    Cal_Gcc(path, mic_num, savedir, width, fs);
end