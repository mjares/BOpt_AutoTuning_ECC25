function rot_vec = quat_mult (q, r)
    % This function basically works like a java/c## interface, providing a
    % modular way to call the quaternion multiplication function in
    % kronnecker_quat()
    rot_vec = kronnecker_quat(q, r);
    
end