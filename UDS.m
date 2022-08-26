function y=UDS(u1,dt,dx1,D1,k1,main,s1,s2,stoic)
    global nx1
    y = main(2:nx1-1) -u1.*(dt./(dx1)).*(main(2:nx1-1)-main(1:nx1-2))+D1.*dt./(dx1.^2).*(main(3:nx1)-2.*main(2:nx1-1)+main(1:nx1-2))+stoic.*k1.*s1(2:nx1-1).*s2(2:nx1-1).*dt; 
end