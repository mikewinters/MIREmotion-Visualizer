x = wavread('sin');
y = wavread('white');

x = x/max(max(x),-min(x)); % Normalize
y = y/max(max(y),-min(y));

len = min(length(x), length(y));
chop = 14000;
steps = round(len/chop);

z = zeros(length(x)+length(y),1);


for i = 1:steps-1
    
    idx = 2*chop;
    
    z((i-1)*idx+1:i*idx,1) = [x((i-1)*chop+1:i*chop,1); y((i-1)*chop+1:i*chop,1)];
end
        
%soundsc(z,44100);
z = miraudio(z);
                




