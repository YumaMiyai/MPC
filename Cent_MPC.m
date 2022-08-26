function Cent_MPC

global N; global Ts;  global x_init; global t_event; global tc;
global init_Control; global u_prev;global cen_time; global MV;

global CA_molm3; global CB_molm3; global CD_molm3;


%%%% here 'i' is time from 1 to N
    tic     %%% tic toc function measures elapsed time

initialize_CMPC
       
% initial concentrations (fisrt column in matrix X) and
% initial control inputs(uu)
    X = x_init;
    uu = init_Control;
    U = uu;
        
    
    for i = 2:N
                
%         if ((i>=100)&&(i>=(t_event/Ts))&&(mod(i,(tc/Ts))==0))  
%             
%             u = OptimalControl(X(:,i-1), MV); 
%             
%             uu=u;
%             
%             Fluoro = CA_molm3*(uu(1)/(uu(1)+uu(2)));
%             Acrylate = CB_molm3*(uu(2)/(uu(1)+uu(2)));
%             Step1 = X(600,i-1).*((uu(1)+uu(2))./(uu(1)+uu(2)+uu(3)));
%             Cyclo = CD_molm3*(uu(3)/(uu(1)+uu(2)+uu(3)));
%     
%             X(1,i-1) = Fluoro;
%             X(201,i-1) = Acrylate;
%             X(601,i-1) = Step1;
%             X(801,i-1) = Cyclo;
%              
%         
%         fprintf('%d ', i);
%         
%         U(:, i-1) = uu;
%         end
    
    
    X(:, i) = SystemActual(X(:, i-1), U(:,i-1));
    U(:, i) = uu; 
    u_prev=uu;
    
    Step1throughputResult(:, i) = X(600,i).*334.17*(uu(1)+uu(2))*60; %MW of 334.17g/mol and per min
    Step2throughputResult(:, i) = X(1200,i).*346.18*(uu(1)+uu(2)+uu(3))*60; %MW of 346.18g/mol and per min
    
    if i>100
        CB_molm3= CB_molm3-5;
        X(201,i) = CB_molm3*(uu(2)/(uu(1)+uu(2)));
    end
    
    end
    
    Concentration=X;
    ProcessCondition=U;
    
    ss=X(600,1:end); %step 1 concentration at the outlet
    sb=X(1200, 1:end); %step 2 concentration at the outlet
    sss=X(201,1:end); %acrylate concentration at the inlet
      
    figure;
    plot(ss,'.','markersize',5)
    hold on
    plot(sb,'.')
    hold on
    plot(sss,'.')
    ylim([0 600])
    ylabel('Concentration (mol/m^3)');
    xlabel('Time (s)');
    h=legend('Step 1 Product','Step 2 Product','Acrylate','location','south');
    h=legend('Step 1 Product','Step 2 Product','location','south');
    set(h,'FontSize',20);
    
    flowA=U(1,:).*60000000;
    flowB=U(2,:).*60000000;
    flowC=U(3,:).*60000000;
    Temp1=U(4,:);
    
    figure;
    plot(flowA,'.')
    hold on
    plot(flowB,'.')
    hold on
    plot(flowC,'.')
    ylim([0 6])
    ylabel('Flow Rate (mL/min)');
    xlabel('Time (s)');
    h=legend('Fluoro','Acrylate','Cyclo','location','east');
    set(h,'FontSize',20);
    
    figure;
    plot(Temp1);
    ylim([140 170]);
    ylabel('Reactor 1 Temperature (deg C)');
    xlabel('Time (s)');
    h=legend('Reactor 1','location','east');
    set(h,'FontSize',20);
    
    figure;
    plot(Step1throughputResult,'.')
    hold on
    plot(Step2throughputResult,'.')
%     hold on
%     plot(flowC,'.')
%     ylim([0 6])
%     ylabel('Flow Rate (mL/min)');
%     xlabel('Time (s)');
%     h=legend('Fluoro','Acrylate','Cyclo','location','east');
%     set(h,'FontSize',20);
    
    cen_time=toc    %%% tic toc function measures elapsed time
end





