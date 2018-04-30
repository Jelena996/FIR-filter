%%Tacka A------------------------------------------------------------------

[x,Fs]=audioread('Mozart_96_kHz.wav');
y=audioplayer(x,Fs);

%y.play
duzina=length(x);

%razdvajanje kolona signala x u dva podsignala
prvi=x(:,1);
drugi=x(:,2);

%prikazivanje vremenskog oblika originalog signala i razdvojenih podsignala
dt=1/Fs;
t=0:dt:(length(x)*dt-dt);
subplot(212),plot(t,x), title('Originalni signal'),xlabel('t[s]','Color','r'),ylabel('originalni signal', 'Color','r')
subplot(221),plot(t,prvi), title('Prvi podsignal'),xlabel('t[s]','Color','r'),ylabel('prvi podsignal', 'Color','r')
subplot(222),plot(t,drugi), title('Drugi podsignal'),xlabel('t[s]','Color','r'),ylabel('drugi podsignal', 'Color','r')
%kreiranje potrebnih filtara


   
   %%
   x1=prvi;
    y=audioplayer(x1,Fs);
 
   Fs=44100;
    y=audioplayer(x1,Fs);
   y.play
   
   
  %% Projektovanje filtara i konverzija ucestanosti
  
  %projektovanje filtara i crtanje njihovih k-ka(i to crtanje rade pozvane
  %funkcije)
   Nfft=1024*32;
   h1=project_LP_antialiasing_filter(96000, 40, 0.5, [3 5 ]);
   h2=project_LP_antialiasing_filter(57600, 40, 0.5, [7 8 ]);    
   h3=project_LP_antialiasing_filter(50400, 40, 0.5, [7 8 ]);
   
 %promjena ucestanosti 96kHz u 44,1kHz koristeci tri sistema 
 x1=prvi;
 x2=drugi;
 
   x1=upsample(x1,3);
   x1=filter(h1,1,x1);
   x1=decimate(x1,5);
   
   x1=upsample(x1,7);
   x1=filter(h2,1,x1);
   x1=decimate(x1,8);
   
   x1=upsample(x1,7);
   x1=filter(h3,1,x1);
   x1=decimate(x1,8);  
   
   x2=upsample(x2,3);
   x2=filter(h1,1,x2);
   x2=decimate(x2,5);
   
   x2=upsample(x2,7);
   x2=filter(h2,1,x2);
   x2=decimate(x2,8);
   
   x2=upsample(x2,7);
   x2=filter(h3,1,x2);
   x2=decimate(x2,8);
   
   Fs=44100;   
     
   y1=audioplayer(x1*5,Fs);
   y2=audioplayer(x1*5,Fs);
   

   %spajanje dva podsignala u signal x
   y=[x1 x2];
  
   
%%

 %odredjivanje pojacanja jer je signal oslabljen
figure;
dt=1/Fs;
t=0:dt:(length(y)*dt-dt);
plot(t,70*y), title('Originalni signal nakon promjene frekvencije');

%sada amplituda ne prelazi 0.4 i konacno:
audiowrite('Mozart_44_1_kHz.wav',70*y,Fs); 
     
   
   