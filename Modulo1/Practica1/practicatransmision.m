%Oscar Olveira MIniño
%Grupo:1.2
%Curso:2022/2023

%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%

clear all;
close all;

%=================== Parametros ==================================
N=10;		     % Periodo de simbolo
L=5;		     % Numero de bits a transmitir
A=1;         % Amplitudeº
tipopulso=4 %1: pulso rectangular 
EbNo=100;    % EbNo en dB
W=pi/8;      % Ancho de banda do canal 

       
%=================== Generacion del pulso =========================

if tipopulso == 1  %pulso rectangular
  n=0:N-1;
  pulso=ones(1,N); 
elseif tipopulso == 2 
    n=[0 0 N/2 N/2];
    pulso=[0 1 1 0];
elseif tipopulso == 3
    #n=[0 0 N/2 N/2 N/2 N N];
    #pulso=[0 1 1 0 -1 -1 0];
    n=0:N-1;
    pulso(1:N/2)=ones;
    pulso(N/2+1:N)=zeros;
else tipopulso == 4
    #n=[0 N N];
    #pulso=[0 1 0];
    n=0:N-1;
    pulso=n/(N-1);
   
   
end;
[P,Wrad]=dtft(pulso,(2*L*N)+50);

%=================== Calculo de la energia del pulso =============
%Escriba el codigo para calcular la energia

Eb=sum(abs(pulso).^2)

%=================== Generacion de la senal (modulacion) =========
randn(0); rand(0)


x=rand(1,L);
bits=(x<=0.5); %genera 0 y 1 a partir de un vector de numeros 
                      %aleatorios con distribucion uniforme

%Escriba un bucle que asocie un pulso con amplitud positiva a 0 y 
%un pulso con amplitud negativa a 1
s_mod=[];
for k=1:L
    Ak= 1-2*bits(k);
    s_mod=[s_mod,pulso*Ak]; %concatenacion do pulso e señal
end
%=================== Generacion de canal ======================
NL2=fix(N*L/2);
n2=-NL2:NL2-1;
h=sin(W*n2)./(pi*n2);
pos=find(n2==0);
h(pos)=W/pi;
if (pi/N)>W
h=h*pi/W/N;
end;
[H,Wrad]=dtft(h,(2*L*N)+50);

%=================== Generacion de ruido ======================
%Conversion a dB
EbNo=10^(EbNo/10);
No=Eb/EbNo;
%Cambio a unidades naturales y calculo de No

#ruido=sqrt(No/2)*randn(1,N*L);
#s_rec=secuecia+ruido;

s_rec=conv(s_mod,h);
s_rec=s_rec(NL2+1:length(s_rec)-NL2+1);
ruido=sqrt(No/2)*rand(1,length(s_rec));
s_rec=s_rec+ruido;
%=================== Representacion grafica ===================

figure(1)
plot(n,pulso);
grid;
axis([0,12,-2,2]);
title('Pulso transmitido: p(n)');
 
 
figure(2)  
plot(s_mod, 'b'); 
hold on;  
plot(s_rec, 'r');
grid;
title('Señal modulada e transmitida');
axis([0,10*N,-2,2]);

figure(3)
plot(Wrad,abs(P)/max(abs(P)));
grid;
hold on;
plot(Wrad,abs(H)/max(abs(H)), 'r');
title('Respuesta en frecuencia del canal H(W) y T.F. del pulso P(W)');

%Diagrama OjO

diagramaojo(s_rec,N,L);