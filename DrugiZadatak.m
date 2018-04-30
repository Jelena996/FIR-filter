%% Tacka 2

%Biranje reprezentativnog signala da se demonstrira rad filtra 
b=KajzerNO();
%relativne vrijednosti frekvencija u odnosu na fs=1
F1=0.1; %nepropusni opseg
F2=0.4; %nepropusni opseg
F4=0.25; %propusni opseg
N=256;
n=0:N-1;
x=sin(2*pi*F1*n)+2*sin(2*pi*F4*n)+sin(2*F2*pi*n);
y=filter(b,1,x);

n=n/(N-1);
n1=n(1:length(n)/2);
Ya=abs(fft(y));
figure;
stem(n1,Ya(1:length(Ya)/2)),title('Spektar signala nakon projektovanog filtra'),xlabel('Relativna ucestanost F/Fs'),ylabel('Isfiltrirani signal');
Xa=abs(fft(x));
figure;
stem(n1,Xa(1:length(Xa)/2)),title('Spektar ulaznog signala'),xlabel('Relativna ucestanost F/Fs'),ylabel('Ulazni signal');

%% Tacka 4
% Odredjivanje broja bita za cijeli i razlomljeni dio signala x, kao i impulsnog odziva filtra

x_word_length=12;
Preferences=fipref; 
reset(Preferences);
Preferences.LoggingMode='on';
Preferences.DataTypeOverride='TrueDoubles';

x_fixed_point=fi(x,1,12,7);
x_range=max(abs(double(minlog(x_fixed_point))),abs(double(maxlog(x_fixed_point)))) ;
x_integer_length=ceil(log2(x_range));
x_fraction_length=x_word_length-x_integer_length-1;
disp('x')
disp(x_integer_length);
disp(x_fraction_length);

b_word_length=12;
b_fixed_point=fi(b,1,12,7);
b_range=max(abs(double(minlog(b_fixed_point))),abs(double(maxlog(b_fixed_point)))) ;
b_integer_length=ceil(log2(b_range));
b_fraction_length=b_word_length-b_integer_length-1;
disp('b')
disp(b_integer_length);
disp(b_fraction_length);

%zbog medjurezultata, da bi imali u vidu koliko je bita dovoljno za izlazni
%signal
y_word_length=12;
y_fixed_point=fi(y,1,12,7);
y_range=max(abs(double(minlog(y_fixed_point))),abs(double(maxlog(y_fixed_point)))) ;
y_integer_length=ceil(log2(y_range));
y_fraction_length=y_word_length-y_integer_length-1;
disp('y')
disp(y_fraction_length);
reset(Preferences);

disp('b-max,min')
disp(max(b))
disp(min(b))
disp('x-max,min')
disp(max(x))
disp(min(x))

%Prethodno odredjene vrijednosti za broj bita razlomljenog i cijelog dijela
%posmatrana tri signala su i ocekivane. Impulsni odziv se krece u intrevalu
%[-0.401,0,3500] pa se moze izabrati s12.12 predstava u fixed-pointu
%x je u intervalu [-3.9021,3.9021], sto znaci da nam trebaju dva bita za
%cjelobrojni dio i biramo predstvanu s12.9, dok je y u intervalu
%[-1.6284,1.5712] pa nam je dovoljan jedan bit za cjelobrojni dio i biramo
%predstavu s12.10

%postavljanje karakteristika za fixed-point podatke
FixedPointAttributes=fimath ( 'ProductMode' , 'SpecifyPrecision' , 'ProductWordLength' , 24 , ...
    'ProductFractionLength' , 16, 'SumMode' , 'SpecifyPrecision', 'SumWordLength' , 24 , 'SumFractionLength' , 16 ) ;

b_fixed_point = fi ( b , 1 , 12 , 12 ) ;
x_fixed_point = fi (x , 1 , 12 , 9 ) ;
b_fixed_point.fimath = FixedPointAttributes ;
x_fixed_point.fimath = FixedPointAttributes ;


%% Uporedjivanje greske izmedju signala sa double i fixed point preciznoscu u zavisnosti od formata za racunanje medjurezultata

figure;
y=Fir_direct_transpose2(b,x);
subplot(311);
plot(n,y),xlabel('vreme'), ylabel('signal');
title('Izlazni x sa double preciznoscu-realizovani filtar fir-direct-transpose');
subplot(312);
y1=filter(b,1,x);
plot(n,y1),title('Ugradjeni filtar u Matlabu'),xlabel('vreme'), ylabel('signal');
subplot(313);
plot(n,y1-y),xlabel('vreme'), ylabel('signal');
title('Greska');

figure
subplot(411);
plot(n,x),xlabel('vreme'), ylabel('signal');
title('Ulazni x');
subplot(412);
plot(n,y),xlabel('vreme'), ylabel('signal');
title('Izlazni x sa double preciznoscu');
subplot(413);
y_fixed_point=Fir_direct_transpose2(b_fixed_point,x_fixed_point);
plot(n,y_fixed_point),xlabel('vreme'), ylabel('signal');
title('Izlazni x sa fixed point preciznoscu');
subplot(414);
plot(n,y-y_fixed_point),xlabel('vreme'), ylabel('signal');
title('Razlika izlazni x sa double i sa fixed point preciznoscu (24.16)');


FixedPointAttributes=fimath ( 'ProductMode' , 'SpecifyPrecision' , 'ProductWordLength' , 16 , ...
    'ProductFractionLength' , 7, 'SumMode' , 'SpecifyPrecision', 'SumWordLength' , 16 , 'SumFractionLength' , 7 ) ;
b_fixed_point.fimath = FixedPointAttributes ;
x_fixed_point.fimath = FixedPointAttributes ;
figure;
subplot(211);
y_fixed_point=Fir_direct_transpose2(b_fixed_point,x_fixed_point);
plot(n,y_fixed_point),xlabel('vreme'), ylabel('signal');
title('Izlazni x sa fixed point preciznoscu');
subplot(212);
plot(n,y-y_fixed_point),xlabel('vreme'), ylabel('signal');
title('Razlika izlazni x sa double i sa fixed point preciznoscu(16.7)');


FixedPointAttributes=fimath ( 'ProductMode' , 'SpecifyPrecision' , 'ProductWordLength' , 12 , ...
    'ProductFractionLength' , 5, 'SumMode' , 'SpecifyPrecision', 'SumWordLength' , 12 , 'SumFractionLength' , 5 ) ;
b_fixed_point.fimath = FixedPointAttributes ;
x_fixed_point.fimath = FixedPointAttributes ;
figure;
subplot(211);
y_fixed_point=Fir_direct_transpose2(b_fixed_point,x_fixed_point);
plot(n,y_fixed_point),xlabel('vreme'), ylabel('signal');
title('Izlazni x sa fixed point preciznoscu');
subplot(212);
plot(n,y-y_fixed_point),xlabel('vreme'), ylabel('signal');
title('Razlika izlazni x sa double i sa fixed point preciznoscu(12.5)');




%% Zavisnost greske od zaokruzivanja koeficijenta filtara i crtanje amplitudskih karakteristika
%postavljanje karakteristika za fixed-point podatke
FixedPointAttributes=fimath ( 'ProductMode' , 'SpecifyPrecision' , 'ProductWordLength' , 32 , ...
    'ProductFractionLength' , 16, 'SumMode' , 'SpecifyPrecision', 'SumWordLength' , 24 , 'SumFractionLength' , 16 ) ;

b_fixed_point = fi ( b , 1 , 12 , 12 ) ;
x_fixed_point = fi (x , 1 , 12 , 9 ) ;
b_fixed_point.fimath = FixedPointAttributes;
x_fixed_point.fimath = FixedPointAttributes;

b_fixed_point = fi ( b , 1 , 9, 6) ;

figure
subplot(411);
plot(n,x),xlabel('vreme');
title('Ulazni x');

subplot(412);
plot(n,y),xlabel('vreme');
title('Izlazni x sa double preciznoscu');

subplot(413);
y_fixed_point=Fir_direct_transpose2(b_fixed_point,x_fixed_point);
plot(n,y_fixed_point),xlabel('vreme');
title('Izlazni x sa fixed point preciznoscu');

subplot(414);
plot(n,y-y_fixed_point),xlabel('vreme');
title('Razlika izlazni x sa double i sa fixed point preciznoscu (9.6)');

b_fixed_point = fi ( b , 1 , 6, 4) ;

figure
subplot(411);
plot(n,x),xlabel('vreme');
title('Ulazni x');

subplot(412);
plot(n,y),xlabel('vreme');
title('Izlazni x sa double preciznoscu');

subplot(413);
y_fixed_point=Fir_direct_transpose2(b_fixed_point,x_fixed_point);
plot(n,y_fixed_point),xlabel('vreme');
title('Izlazni x sa fixed point preciznoscu');

subplot(414);
plot(n,y-y_fixed_point),xlabel('vreme');
title('Razlika izlazni x sa double i sa fixed point preciznoscu-fraction(6.4)');


%% Crtanje amplitudske karakteristike na 4 nacina zaokruzivanja

h1 = round(b*2^12)/2^12;
h2 = round(b*2^9)/2^9;
h3 = round(b*2^6)/2^6;
h4 = round(b*2^5)/2^5;


[H,w]=freqz(b,1,1024);  Ha=abs(H);
[H1,w]=freqz(h1,1,1024);  H1a=abs(H1);
[H2,w]=freqz(h2,1,1024);  H2a=abs(H2);
[H3,w]=freqz(h3,1,1024);  H3a=abs(H3);
[H4,w]=freqz(h4,1,1024); H4a=abs(H4);

figure;
p = plot(w,Ha,'b',w,H1a,'c',w,H2a,'g',w,H3a,'m',w,H4a,'r');
set(p,'LineWidth',2);
legend('Koeficijenti sa double preciznoscu','H1a koeficijetni zaokruzeni na 12 bita','H2 koeficijenti zaokruzeni na 9 bita','H3a koeficijenti zaokruzeni na 6 bita','H4a koeficijenti zaokruzeni na 5 bita');

title('Amplitudske karakteristike razmatranih filtara')
xlabel('w');
ylabel('|H(e^(jw))|');

