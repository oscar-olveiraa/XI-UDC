
function diagramaojo(senal,N,L)
%Representacion del diagrama de ojo 

figure;
hold on;
S=(2*N);
T=floor(L/2)+mod(L,2)-1;
for i=1:T
  dib=senal(1,(((2*N)*(i-1))+1):((2*N*i)+1));
  ejex2=0:S;
  plot(ejex2,dib);
end