


function [ y ] = Fir_direct_transpose2( b, x ) 

m=length(b);
n=length(x);

x1=zeros(1,m);
h1=zeros(1,m);

if isfi(b) 
   h1= fi( h1, b.Signed, b.WordLength, b.FractionLength); 
end

if isfi(x)
      x1= fi( x1, x.Signed, x.WordLength, x.FractionLength); 
end


for i=1:n
   x1=[x(i) x1(1:end-1)];
   
   if(i<=m)
   h1(i)=b(i);
   end
   medju=x1.*h1;
   
   for i1=2:m
       medju(m-i1+1)=medju(m-i1+1)+medju(m-i1+2);
   end  
   y(i)=medju(1);
end
 
end