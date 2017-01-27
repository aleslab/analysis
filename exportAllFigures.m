function [] = exportAllFigures(format)

if ~exist('format','var') || isempty(format)   
    format = 'jpg';
end


figList = findobj('type','figure');

for iFig = figList';
    

    
    if ~isempty(get(iFig,'filename'))
        %[dir name ext] = fileparts(get(iFig,'filename'));
        name = get(iFig,'filename');
    else
        continue;
    end
       
    
 
    if strcmp(format,'psc2')
        saveas(iFig,[name '.eps'],'psc2')
    else
        saveas(iFig,[name '.' format],format)
    end
    
    
end
