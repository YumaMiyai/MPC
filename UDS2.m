function y=UDS2(u2,dt,dx2,D2,k2,main2,s3,s4,stoic2)
    global nx2
    y = main2(2:nx2-1) -u2.*(dt./(dx2)).*(main2(2:nx2-1)-main2(1:nx2-2))+D2.*dt./(dx2.^2).*(main2(3:nx2)-2.*main2(2:nx2-1)+main2(1:nx2-2))+stoic2.*k2.*s3(2:nx2-1).*s4(2:nx2-1).*dt; 
end