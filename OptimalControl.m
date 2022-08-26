
function u = OptimalControl(x,uu)
    global m;
    global horizon; global init_Control;
    global MV;
     
    

s = length(MV(:,1));
%s=2;
%costcomparison=ones(s,1).*100000000000;

for c = 1:s
    
    J = Cost(x,uu(c,:));  %uu is defined as MV
%     output = Cost(x,uu);  %uu is defined as MV
    
    costcomparison(c,:) = J;
    %costcomparison(c,:) = J;
    
    %fprintf('%d ', c);
end

% fprintf('%d ', costcomparison);

OptimalMV = find(costcomparison==min(costcomparison));

u = MV(OptimalMV(1,1),:);

end
