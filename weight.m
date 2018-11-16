function [W_wing] = weight()
    EMWET MD11;
    
    fid     = fopen('MD11.weight', 'r');
    OUT = textscan(fid, '%s'); 
    fclose(fid);

    out = OUT{1};
    W_wing = str2double(out(4));
end