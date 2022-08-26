%
X = x_init;
 X(1,1:1440)=375;
 X(201,1:480)=450;
 
 X(201,481:960)=750;
 
 X(201,961:1200)=450;
 
 X(201,1201:1440)=750;
 
 X(1,1441:2160)=500;
 X(201,1441:1680)=300;
 
 X(201,1681:1920)=600;
 
 X(201,1921:2160)=900;
 
 %
 uu = init_Control;
 uu(1,1:240)=3.33333333e-8;
 uu(2,1:240)=3.33333333e-8;
 uu(4,1:960)=120;
 
 uu(1,241:480)=0.0000001;
 uu(2,241:480)=0.0000001;
 
 uu(1,481:720)=3.33333333e-8;
 uu(2,481:720)=3.33333333e-8;
 
 uu(1,721:960)=0.0000001;
 uu(2,721:960)=0.0000001;
 
 uu(1,961:1200)=3.33333333e-8;
 uu(2,961:1200)=3.33333333e-8;
 uu(4,961:1440)=160;
 
 uu(1,1201:1440)=0.0000001;
 uu(2,1201:1440)=0.0000001;

 
 uu(1,1441:1680)=0.00000005;
 uu(2,1441:1680)=0.00000005;
 uu(4,1441:2160)=140;
 
 uu(1,1681:1920)=0.000000025;
 uu(2,1681:1920)=0.000000025;
 
 uu(1,1921:2160)=0.00000005;
 uu(2,1961:2160)=0.00000005;
 
 global N;

for i=2:2160
  
    X(:,i) = SystemActual(X(:, i-1), uu(:,i-1));
%     U(:, i-1) = uu; 
   
%    if i>120
%        X(201,i) = X(201,i-1)-0.5;
%    end
   
end

    ss=X(600,1:2160)./1000*334;
%     sb=X(1200, 1:600);
%     sss=X(201,1:600);
HPLC(1,:)=[93.6 95.6 66.5 67.8 103.5 108.4 86.1 88.2 106.4 107 104.6 104.6 93.7 93 144.6 143.9 142.8 139.8];
HPLC(2,:)=[120 180 360 420 600 660 840 900 1080 1140 1320 1380 1560 1620 1800 1860 2040 2100];
      
    figure;
    plot(ss,'.','markersize',5)
    hold on
    plot(HPLC(2,:),HPLC(1,:),'.','markersize',5);
    ylim([60 160])
    
    
    
    plot(sb,'.')
    hold on
    plot(sss,'.')
    ylabel('Concentration (mol/m^3)');
    xlabel('Time (s)');
    h=legend('Step 1 Product','Step 2 Product','Acrylate','location','south')
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
    ylim([1 6])
    ylabel('Flow Rate (mL/min)');
    xlabel('Time (s)');
    h=legend('Fluoro','Acrylate','Cyclo','location','east')
    set(h,'FontSize',20);
    
    figure;
    plot(Temp1);
    ylim([140 170]);
    ylabel('Reactor 1 Temperature (deg C)');
    xlabel('Time (s)');
    h=legend('Reactor 1','location','east')
    set(h,'FontSize',20);

