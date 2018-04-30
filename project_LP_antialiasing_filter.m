function [ b ] =  project_LP_antialiasing_filter ( Fs, Aa, Ap, x )
%Projektovanje NF filtra koristeci Parks-MekKlelanov optimizacioni metod. 

wp1= 20000;
U=x(1);
D=x(2);
Nfft=1024*32;

%odredjivanje specifikacija 
%za NF filtar koji se primjenjuje na interpolirani signal-za granicnu ucestanost
%nepropusnog opsega se mora uzeti stroziji uslov kako bi se zadovoljilo sledece:
%izdvajanje osnovnog opsega signala nakon interpolacije, ali i sprecavanje
%potencijalnog aliasing efekta nakon decimacije 

if(U>D) %faktor interpolacije je veci   
    wa=pi/U;
    wp=(wp1*D)/(Fs/2*(U^2))*pi;   
else    
    wa=pi/D;
    wp=(wp1/(Fs/2*U))*pi;       
   end


dp=( 10^(0.05*Ap)-1 )/( 10^(0.05*Ap)+1 );	
da=10^(-0.05*Aa);
D=(0.005309*log10(dp)*log10(dp)+0.07114*log10(dp)-0.4761)*log10(da);
D=D-(0.00266*log10(dp)*log10(dp)+0.5941*log10(dp)+0.4278);
f=11.01217+0.51244*(log10(dp)-log10(da));

Bt=wa-wp;
M=2*pi*D/Bt-f*Bt/(2*pi) + 1;
M=ceil(M);		% duzina impulsnog odziva
N=M-1;			% red filtra
disp('Potreban red filtra (N) prema empirijskim formulama je:');
disp('wa')
disp(wa)
disp('wp')
disp(wp)
disp(N);

%projektovanje filtra na onovu zadatih paramterara
fa_n=wa/pi; %normalizacija ucestanosti
fp_n=wp/pi;
Hd=[1 1 0 0 ];
F=[0 fp_n fa_n  1];
b=remez(N,F,Hd); %impulsni odziv
[H,w]=freqz(b,1,Nfft);Ha=abs(H);


%provjera gabarita i njihovo iterativno mijenjanje
kp= ceil((Nfft*wp)/pi)+1;
ka= floor((Nfft*wa)/pi)+1;
Hno=Ha(ka:end);
Hpo=Ha(1:kp);


if( (max(Hno)<=da) && (min(Hpo)>=(1-dp)) && ((max(Hpo)<=(1+dp))) )
    disp('Gabariti su zadovoljeni odmah nakon projektovanja filtra ciji red daju empirijske formule');
    
  else
    while(true)
        N=N+1;
        M=M+1;
        b=remez(N,F,Hd);
        [H,w]=freqz(b,1,Nfft); Ha=abs(H);
        Hp=unwrap(angle(H));     
        Hno=Ha(ka:end);
        Hpo=Ha(1:kp);
        if( (max(Hno)<=da) && (min(Hpo)>=(1-dp)) && ((max(Hpo)<=(1+dp))) )            
            disp('Novi red filtra je:')
            disp(N);
            break;
        end
    end
end
  
%crtanje k-ka filtra i impulsnog odziva, kao i odredjivanje linija za gabarite

x1=[0 wp]; y1=[1-dp 1-dp];
x2=[0 wp]; y2=[1+dp 1+dp];
x3=[0 0];  y3=[da/10 1+dp];
x4=[wp wp]; y4=[da/10 1+dp];
x5=[wa pi]; y5=[da da];
x6=[wa wa]; y6=[0 da];
x7=[pi pi]; y7=[0 da];

figure;
plot(w,Ha,'LineWidth',2),title('Amplitudska karakteristika FIR filtra - linearna razmera'),grid on, hold on,
xlabel('w');
ylabel('|H(e^(jw))|');
line(x1,y1,'LineWidth',2,'Color','r');
line(x2,y2,'LineWidth',2,'Color','r');
line(x3,y3,'LineWidth',2,'Color','r');
line(x4,y4,'LineWidth',2,'Color','r');
line(x5,y5,'LineWidth',2,'Color','r');
line(x6,y6,'LineWidth',2,'Color','r');
line(x7,y7,'LineWidth',2,'Color','r');
hold off;

figure;
plot(w,Hp,'LineWidth',2),title('Fazna karakteristika FIR filtra'),xlabel('w');
ylabel('arg{H(e^(jw)}');

figure;
indeksi=0:length(b)-1;	
stem(indeksi,b),title('Impulsni odziv filtra');

end

