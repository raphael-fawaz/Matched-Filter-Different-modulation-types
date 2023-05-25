clear all
num_bits = 1e5;
SNR = 0:2:30;
m = 20;
sampling_instant = 20;
s1_amplitude = 1;
s2_amplitude = 0;
s1 = ones(1,m)*s1_amplitude;
s2 = ones(1,m)*s2_amplitude;
bits = randi([0,1],1,num_bits);
waveForm = zeros(1,1e5*m);
for i = 0:length(bits)-1 
    if bits(i+1) == 1                                              
        val = s1;    
    else         
        val = s2;                                               
    end
    waveForm((m*i)+1:m*i+length(val)) = val;                         
end

match_ber = [];
cor_ber = [];
simple_ber = [];
snr=0;
for snr =0:2:30
noise_power = (s1_amplitude^2)*m/(2*10^(snr/10));
    noise = sqrt(noise_power)*randn(1,length(waveForm));
    Rx_sequence = waveForm + noise;
    
    
    
    
    
    
    
    
    
    %matched_filter
diff = s1 - s2;
hmf = diff(end:-1:1);
out_after_sampling = zeros(1,length(bits));
conv_output = zeros(1, (2*m-1)*length(bits));
for i = 0:length(bits)-1
        Rx_sequence_window = Rx_sequence((i*m)+1:(i+1)*m);                          
        c = conv(Rx_sequence_window,hmf);
        
        conv_output( (length(hmf)+length(Rx_sequence_window)-1)*i+1:(length(hmf)+length(Rx_sequence_window)-1)*i+length(c) ) = c;  
        m_1 = m + (length(hmf)+length(Rx_sequence_window)-1)*(i);                     
        out_after_sampling(i+1) = conv_output(m_1);                            
end
    vth=((s1_amplitude^2)*m/2);
    out_after_sampling_th= zeros(1, 1e5);
    for j = 1:length(out_after_sampling)
        if(out_after_sampling(j) >= vth)
            out_after_sampling_th(j)=1;
        else
            out_after_sampling_th(j)=0;
        end 
    end
     [number, ratio] = biterr(bits, out_after_sampling_th, []);
    match_ber = [match_ber ratio]; 
   
    
    
    
    
    
    %correlator
    output_cor=zeros(1,1e5);
    output_cor_th=zeros(1,1e5);
    
    for i = 0:length(bits)-1
        Rx_sequence_window = Rx_sequence((i*m)+1:(i+1)*m);                          
        cc=sum( Rx_sequence_window .* s1);
        output_cor(i+1)=cc;
                                    
    end

    for j = 1:length(output_cor)
        if(output_cor(j) >= vth)
            output_cor_th(j)=1;
        else
            output_cor_th(j)=0;
        end 
    end
    [number, ratio] = biterr(bits, output_cor_th, []);
   cor_ber = [cor_ber ratio]; 
   
   
   
   %simple
   out_after_simple= zeros(1,length(bits));
   for i = 0:length(bits)-1
        Rx_sequence_window = Rx_sequence((i*m)+1:(i+1)*m);                          
                            
        out_after_simple(i+1) = Rx_sequence_window(m/2);                            
end
   vth_simple=0.5;
   out_after_simple_th= zeros(1, 1e5);
    for j = 1:length(out_after_simple)
        if(out_after_simple(j) >= vth_simple)
            out_after_simple_th(j)=1;
        else
            out_after_simple_th(j)=0;
        end 
    end
    
    [number, ratio] = biterr(bits, out_after_simple_th, []);
   simple_ber = [simple_ber ratio]; 
    
    
    
     
    
    
    
end
figure;
semilogy(SNR, match_ber);
title('Matched filter');

figure;
semilogy(SNR, cor_ber);
title('Correlator');

figure;
semilogy(SNR, simple_ber);
title('simple');



