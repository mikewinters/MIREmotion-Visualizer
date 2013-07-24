function modechecker(soundfile)

%soundfile= 'that';
load gomezprofs
%notes = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};

    mirkey(soundfile,'Frame',0.046,0.5)

    mirchromagram('that')
    plot(0:11,gomezprofs(24,:)-(max(gomezprofs(24,:))-1),'r')
    plot(0:11,gomezprofs(3,:)-(max(gomezprofs(3,:))-1),'g')
    plot(0:11,gomezprofs(19,:)-(max(gomezprofs(18,:))-1),'c')
    plot(0:11,gomezprofs(7,:)-(max(gomezprofs(6,:))-1),'m')
    xlim([-1 12])
    legend('Chromagram','Minor', 'Relative Major', 'Dominant Minor', 'Dominant Major')