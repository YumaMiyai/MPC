function J = Cost(x, uu)
    global horizon; global m;
    global n; global u_prev;global tc;global Ts;
    global MV;
    
    global CA_molm3; global CB_molm3; global CD_molm3;
    
    Fluoro = CA_molm3*(uu(1)/(uu(1)+uu(2)));
    Acrylate = CB_molm3*(uu(2)/(uu(1)+uu(2)));
    Step1 = x(600,1).*((uu(1)+uu(2))./(uu(1)+uu(2)+uu(3)));
    Cyclo = CD_molm3*(uu(3)/(uu(1)+uu(2)+uu(3)));
    
    X = x;
    X(1,1) = Fluoro;
    X(201,1) = Acrylate;
    X(601,1) = Step1;
    X(801,1) = Cyclo;
    
    j = 0;
    
    for k = 2:(horizon + 1)   
          X(:,k) = SystemModel(X(:,k-1), uu);

     % throughput calculation (gram of product/min)
       Step1throughput = X(600,k).*334.17*(uu(1)+uu(2))*60; %MW of 334.17g/mol and per min
       Step2throughput = X(1200,k).*346.18*(uu(1)+uu(2)+uu(3))*60; %MW of 346.18g/mol and per min
 

    Step1 = X(601,k);

    
    stoichiometry_Step1 = [Fluoro Acrylate]';
    
         limiting_Step1 = find(stoichiometry_Step1==min(stoichiometry_Step1));
    
    stoichiometry_Step2 = [Step1 Cyclo]';
        
         limiting_Step2 = find(stoichiometry_Step2==min(stoichiometry_Step2));
    
    LimitingReagent_Step1 = stoichiometry_Step1(limiting_Step1(1,1),:);
    LimitingReagent_Step2 = stoichiometry_Step2(limiting_Step2(1,1),:);
    
    TheoreticalYield_Step1 = LimitingReagent_Step1;
    TheoreticalYield_Step2 = LimitingReagent_Step2;
    
    Yield_Step1 = X(600,k)./TheoreticalYield_Step1;
    Yield_Step2 = X(1200,k)./TheoreticalYield_Step2;
    
    Conversion_Fluoro = abs(X(1,k)-X(200,k))./X(1,k);
    Conversion_Acrylate = abs(X(201,k)-X(400,k))./X(201,k);
    Conversion_Step1 = abs(X(601,k)-X(800,k))./X(601,k);
    Conversion_Cyclo = abs(X(801,k)-X(1000,k))./X(801,k);

    j = (j + abs(Yield_Step1 - TheoreticalYield_Step1)./TheoreticalYield_Step1...
        + abs(Yield_Step2 - TheoreticalYield_Step2)./TheoreticalYield_Step2...
        + (abs(X(600,k) -500)./500)...
        + (abs(X(1200,k) -330)./330)...
        + abs(Step1throughput -0.825)/0.825...    
        + abs(Step2throughput -0.825)/0.825);

    
%         j = (j + 1.2*(abs(Yield_Step1 - TheoreticalYield_Step1)./TheoreticalYield_Step1...
%         + abs(Yield_Step2 - TheoreticalYield_Step2)./TheoreticalYield_Step2)...
%         + (abs(X(600,k) -500)./500)...
%         + (abs(X(1200,k) -330)./330)...
%         + 1.2*(abs(Step1throughput -0.825)/0.825...    
%         + abs(Step2throughput -0.825)/0.825)...
%         + Conversion_Fluoro...
%         + Conversion_Acrylate...
%         + Conversion_Step1...
%         + Conversion_Cyclo);


        %j = j +abs(x(600,k) -500)/500+abs(x(1200,k) -330)/330+abs(Step2throughput -0.825)/0.825;
        
    end      
  

      J=j;
    
end

