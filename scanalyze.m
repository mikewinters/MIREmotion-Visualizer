function out = scanalyze(inputfile)
    
    x = miraudio(inputfile);
    
    c = mirchromagram(x, 'Frame',.046,.5,'Wrap',0','Pitch',0)
    mirchromagram(x)
    ks = mirkeystrength(c);
    [k kc] = mirkey(ks);
    
    out.kc = get(kc,'Data');
    out.k = get(k,'Data');
    out.mo = get(mirmode('that'),'Data');
    
    % Remove empty elements (don't know why they are there in the first
    % place)
    out.errors = sum(isnan(out.kc{1}{1}));
    out.kc{1}{1}(isnan(out.kc{1}{1}))=[];
    out.k = out.k{1}{1}(~cellfun('isempty',out.k{1}{1})); 

    out.kc=out.kc{1}{1};    
    out.k = cell2mat(out.k);
    out.mo = out.mo{1}{1};
    out.kc_mean = mean(out.kc);

    
%   Replace empty elements with zeros
%     out.k = get(k,'Data');
%     emptyIndex = cellfun(@isempty,out.k);       %# Find indices of empty cells
%     out.k(emptyIndex) = {0}                  %# Fill empty cells with 0
    %out.k = logical(cell2mat(out.k));


%    out.this = get(k,'Title');
    
    % Plotting
%    clf
    % subplot(121)
%    copyobj(k,gcf);
%     plot(out.k)
%     title(get(k,'Title'))
%     ylabel(get(k,'Legend'))    
%     subplot(122)
%     plot(out.kc)
%     title(get(kc,'Title'))

%     out.kc = kc;
    
%     subplot(121)
%     plot(k)
%     plot(kc)