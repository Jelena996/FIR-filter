
function [h] =KajzerNO()
%Funkcija sintetizuje FIR filtar nepropusnik opsega koriscenjem metoda
%odsjecanja impulsnog odziva Kajzerovom prozorskom funkcijom. Filtar ima
%dva nepropusna opsega, a specifikacije su odredjene u tekstu zadatkua.

%zadavanje specifikacija
wp1=0; wp2=0.15*pi; wp3=0.45*pi; wp4=0.65*pi;
wa1=0.2*pi; wa2=0.3*pi; wa3=0.7*pi; wa4=pi;
H1=1; H2=0.7;
Ap1=0.5; Ap2=0.3; Aa1=35; Aa2=40;

%odredjivanje Bt, wc, da i dp
Bt=min([wa1-wp2, wp3-wa2, wa3-wp4]);

wc1=wp2+Bt/2;
wc2=wp3-Bt/2;
wc3=wp4+Bt/2;

da1=10^(-0.05*Aa1);
da2=10^(-0.05*Aa2);
dp1=H1*( 10^(0.05*Ap1)-1 )/( 10^(0.05*Ap1)+1 );
dp2=H2*( 10^(0.05*Ap2)-1 )/( 10^(0.05*Ap2)+1 );

delta=min([da1,da2,dp1,dp2]);
Aa=-20*log10(delta);

% odredjivanje beta
beta=0;
if ( Aa>=21 && Aa<=50 ), beta=0.5842*(Aa-21)^0.4+0.07886*(Aa-21);end
if Aa >50, beta=0.1102*(Aa-8.7);end

%odredjivanje M
D=0.9222;
if Aa >21, D=(Aa-7.95)/14.36; end
M=ceil(2*pi*D/Bt+1);

%generisanje kajzerovog prozora 
prozor=kaiser(M,beta)';

%odredjivanje impulsnog odziva idealnog filtra
%navedeni filtar cu posmatrati kao kombinaciju tri idealna NF filtra sa
%granicnim ucestanostima wc1,wc2 wc3 i tako poznavajuci impulsni odziv NF
%filtra odrediti i odziv zeljenog
n=-(M-1)/2:(M-1)/2;
b=H1*sin(n*wc1)./(n*pi)+ (H2*(sin(n*wc3)-sin(n*wc2)) )./(n*pi);
if ( M-2*fix(M/2) ) > 0,
        indeks=(M+1)/2 ;
        b(indeks)= H1*wc1/pi+ H2*(wc3-wc2)/pi;
end

% mnozenje za odbircima prozorske funkcije
h=b.*prozor;


%crtanje impulsnog odziva projektovanog filtra
figure(1);
stem(0:M-1,h);
title('Impulsni odziv')
xlabel('n');
ylabel('h[n]');

%crtanje amplitudske k-ke i zadatih gabarita
x1=[wp1 wp2]; y1=[H1+dp1 H1+dp1];
x2=[wp1 wp2]; y2=[H1-dp1 H1-dp1];
x3=[wp1 wp1]; y3=[H1+dp1 dp1/100];
x4=[wp2 wp2]; y4=[H1+dp1 dp1/100];
x5=[wa1 wa2]; y5=[da1 da1];
x6=[wa1 wa1]; y6=[da1 da1/10];
x7=[wa2 wa2]; y7=[da1 da1/10];
x8=[wp3 wp4]; y8=[H2+dp2 H2+dp2];
x9=[wp3 wp4]; y9=[H2-dp2 H2-dp2];
x10=[wp3 wp3]; y10=[H2+dp2 dp2/100];
x11=[wp4 wp4]; y11=[H2+dp2 dp2/100];
x12=[wa3 wa4]; y12=[da2 da2];
x13=[wa3 wa3]; y13=[da2 da2/10];
x14=[wa4 wa4]; y14=[da2 da2/10];

[H,w]=freqz(h,1,1024);  Ha=abs(H); Hp=unwrap(angle(H));
figure(2);
plot(w,Ha);
xlabel('w');
ylabel('|H(e^(jw))|');
title('Amplitudska karakteristika linearna razmera')

line(x1,y1,'LineWidth',2,'Color','r');
line(x2,y2,'LineWidth',2,'Color','r');
line(x3,y3,'LineWidth',2,'Color','r');
line(x4,y4,'LineWidth',2,'Color','r');
line(x5,y5,'LineWidth',2,'Color','r');
line(x6,y6,'LineWidth',2,'Color','r');
line(x7,y7,'LineWidth',2,'Color','r');
line(x8,y8,'LineWidth',2,'Color','r');
line(x9,y9,'LineWidth',2,'Color','r');
line(x10,y10,'LineWidth',2,'Color','r');
line(x11,y11,'LineWidth',2,'Color','r');
line(x12,y12,'LineWidth',2,'Color','r');
line(x13,y13,'LineWidth',2,'Color','r');
line(x14,y14,'LineWidth',2,'Color','r');

%crtanje fazne k-ke
figure(4);
plot(w, Hp);
xlabel('w');
ylabel('arg(H(e^(jw))) [rad/s]');
title('Fazna karakteristika');


end

