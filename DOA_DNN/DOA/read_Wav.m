function read_Wav(fs, dist, step, mic_d, mic_num, pos, file_num_final)
%dist: 声源距离阵列最左端点的距离
%step: 角度步长
%mic_d:阵列间距
%mic_num: 麦克风阵列阵元个数
%file_num_final: 读取的最后一个语音文件编号
%SavePath: 结果存储路径                                                    
    for file_num = 1 : file_num_final
        loadpath = ['man_00' num2str(file_num) '.wav'];
        savedir = ['E:\MATLAB\Microphone array\GCC-PHAT\DOA_simulate\TrainData\man_' num2str(file_num)];
        if ~exist(savedir, 'dir')
            mkdir(savedir);
            num_s = 1;
        else
            list = dir(savedir);
            num_s = size(list, 1) - 1;
        end
        [signal, ~] = audioread(loadpath);                  %读取人声文件
        num = floor(length(signal) / (5 * fs));                 %根据人声文件长度选取num
        for n = num_s : num
            savepath_speech = [savedir '\man_wav' num2str(n) '.mat'];
            speech_startpoint = 1+5*(n-1)*fs;                    %从人声信号中选取声源信号的起点
            speech_sign = signal(speech_startpoint : speech_startpoint + 5*fs-1, :);   %信号
            [x, labels] = room_model(speech_sign, fs, dist, step, mic_d, mic_num, pos);
            save(savepath_speech, 'x', 'labels', '-v7.3');
            fprintf('%1d / %2d, %3s complete \n' , n, num, loadpath) 
        end
    end
end
    
        