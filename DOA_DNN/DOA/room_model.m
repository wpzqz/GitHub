%  This script reads in an audio file segment of a phrase about a scare crow
%  and uses the simarraysigim function to simulate this word spoken over an
%  array in a room with reverberation.  It compares the recordings between
%  a near and far mic to compare the impact of the room response (the
%  further the mic from the speaker the more room effects can be heard).
%  This script requires the programs "simarraysigim.m," "regmicsline.m,"
%  "roomimpres.m," and wave file scare_crow.wav
%
%  Written by Kevin D. Donohue (donohue@engr.uky.edu) July 2005 (updated
%  June 2008)
function [x, label] = room_model(speech_sign, fs, dist, step, mic_d, mic_num, pos)

    %Waveform：音源波形
    %fs：音源最高频率
    %dist：音源距离最左阵元的距离
    %step: 角度步长
    %theta：音源入射角度（相对于x轴正方向，相对最左阵元）
    %mic_d：阵元间距
    %mic_num：阵元数量
    %pos：最右阵元位置

    %Reflection coefficients of 4 walls, floor, and ceiling.
    refcoef = [.90 .95 .90 .95 .2 .4];
    %Coordinates of opposite corners of a rectangular room
    foroom = [-7 -3 0; 1 3 1.24]'; 
    %Set speed of sound in propagation data structure for simarraysig.m
    %prop.c = 348;
    %Frequency dependent Attenuation
    temp = 28;         %Temperature centigrade
    press = 29.92;     %pressure inHg
    hum = 80;          %humidity in percent
    prop.freq = fs/2*[0:200]/200;  %Create 201 point frequency axis
    prop.atten = atmAtten(temp, press, hum, dist, prop.freq);  %Attenuation vector
    prop.c = SpeedOfSound(temp, hum, press);
    c = prop.c;

    %Create mic array, 5 mics (1 meter spacing) on the x-axis (2=y and 1=z)
    %starting at -5 meters with a spacing of 1 meter in the positive
    %x direction
    fom = [pos(1)-(mic_num-1)*mic_d pos(2) pos(3); pos]';        %End coordinates of array
    micpos = regmicsline(fom, mic_d);      %Generate linear microphone array
    %Set signal position near far negative end of array and 1 meter in front of
    %the array element
    s = 1;
    x = cell(1, floor(180/step));
    label = zeros(1, floor(180/step));
    for theta = 0 : step : 180-step
        sigpos = [-0.6+cos(theta)*dist; 2+sin(theta)*dist; 1];
        %Simulate array recording
        [sigout, ~] = simarraysigim(speech_sign, fs, sigpos, micpos, foroom, refcoef, prop);
        x{s} = sigout;
        label(s) = theta;
        fprintf('array data: simulation %0d/%2d: complete\n', s, length(x)) ;
        s = s + 1;
    end

end