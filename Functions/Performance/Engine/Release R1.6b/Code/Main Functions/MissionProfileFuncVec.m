function Range_vec = MissionProfileFuncVec( Payload_vec, flag, EngineData, TOM, Par )
% Range_vec = MissionProfileFuncVec( Payload_vec, flag, EngineData, TOM , Par)
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 4
    switch flag
        case 'Design'
            error('This is a Design case, TOM value is missing ... [] = MissionProfileFunc(Payload, flag, EngineData, TOM )');
        case {'MFC','MTOM'}
            TOM = 0;
            Par = AC_DP2001;
            EngineData = GriddedEngineData(Par);
    end
end

if nargin < 1
    Payload_vec = [28000 30000 32000];
    flag        = 'MTOM';
    Par = AC_DP2001;
    EngineData = GriddedEngineData(Par);
    TOM = 0;
end

Range_vec = zeros(size(Payload_vec));
for i=1:length(Payload_vec)
    Payload = Payload_vec(i);
    [diff, TotalFuel, Block, Mission] = MissionProfileFunc(Payload, flag, EngineData, TOM, Par);
    Range_vec(i) = Block.Range;
end
end