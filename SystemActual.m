function dX=SystemActual(X, U)

global D1; global dt; global nx1; global nx2; global dx1; global dx2; 
global Ea1; global Ea2; global k01; global k02; global R; 
global Ac1; global Ac2;

% control inputs
    % Flow rate (m^3/s)
    F_QA  = U(1);
    F_QB  = U(2);
    F_QD  = U(3);
    % Reactor Temperature
    T1 = U(4)+273.15;
    T2 = U(5)+273.15;
    
    % Reaction Kinetics
    k1 = k01*exp(-Ea1/R/T1);
    k2 = k02*exp(-Ea2/R/T2);
     
    % Step 1 and Step 2 flow rates
    F_QC=F_QA+F_QB;
    F_QE=F_QC+F_QD;
    
    % Stream Velocities
    u1 = F_QC/Ac1;            %step 1 stream velocity (m/s)
    u2 = F_QE/Ac2;            %step 2 stream velocity (m/s) 

    % Concentration profiles along the tube from the previous time point
    A  = X(1:200)';
    B  = X(201:400)';
    C  = X(401:600)';
    C2 = X(601:800)';
    D  = X(801:1000)';
    E  = X(1001:1200)';
    
    % Inlet concentration (mol/m^3)
%     F_CA  = 1000*F_QA/F_QC;  %m^3/s Fluoro
%     F_CB  = 1200*F_QB/F_QC;  %m^3/s Acrylate
%     F_CD  = 1250*F_QD/F_QE;  %m^3/s Cyclo
% 
%     A(1) = F_CA;
%     B(1) = F_CB;
%     D(1) = F_CD;
    
    % Simulation of Steps 1 and 2
    j=1;
    for j=1:200
        An = A;
        Bn = B;
        Cn = C;
        A(1,nx1) = A(1,nx1-1);
        B(1,nx1) = B(1,nx1-1); 
        C(1,nx1) = C(1,nx1-1); 
        A(2:nx1-1) = UDS(u1,dt,dx1,D1,k1,An,An,Bn,-1);
        B(2:nx1-1) = UDS(u1,dt,dx1,D1,k1,Bn,An,Bn,-1);
        C(2:nx1-1) = UDS(u1,dt,dx1,D1,k1,Cn,An,Bn,1);

        Cn2 = C2;
        Dn  = D;
        En  = E;
        C2(1) = C(nx2)*F_QC/F_QE;
        C2(1,nx2) = C2(1,nx2-1);
        D(1,nx2)  = D(1,nx2-1); 
        E(1,nx2)  = E(1,nx2-1); 
        C2(2:nx2-1) = UDS2(u2,dt,dx2,D1,k2,Cn2,Cn2,Dn,-1);
        D(2:nx2-1) = UDS2(u2,dt,dx2,D1,k2,Dn,Cn2,Dn,-1);
        E(2:nx2-1) = UDS2(u2,dt,dx2,D1,k2,En,Cn2,Dn,1);
    end
  
   dX = [A B C C2 D E]';  
  
  end