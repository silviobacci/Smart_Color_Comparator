function similarity = evaluate_similarity(master, copy)
    net = evalin('base','net');
    input_size = net.inputs{1}.size;
    wl_step = floor(842 / input_size);
    master = under_sampling(master,wl_step)';
    copy = under_sampling(copy,wl_step)'; 
    similarity = net([master copy]');
end